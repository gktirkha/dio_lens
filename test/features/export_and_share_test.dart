import 'dart:convert';

import 'package:dio/dio.dart' show DioExceptionType;
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/features/export/data/utils/export_builder.dart';
import 'package:dio_lens/src/features/settings/domain/utils/request_redactor.dart';
import 'package:dio_lens/src/features/share/domain/utils/share_content_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/entities.dart';

void main() {
  const settings = DioLensSettings();

  final post = request(
    'p1',
    method: 'POST',
    url: 'https://api.example.com/v1/orders?token=abc&page=2',
    statusCode: 201,
    requestHeaders: {'Authorization': 'Bearer secret', 'Accept': 'json'},
    responseHeaders: {'set-cookie': 's=1', 'x-request-id': 'r1'},
    requestBody: {'item': 1},
    requestContentType: 'application/json',
    responseBody: {'id': 7},
    responseContentType: 'application/json',
    responseSize: 8,
  );
  final failed = request(
    'f1',
    url: 'https://api.example.com/v1/sync',
    state: RequestState.failed,
    errorType: DioExceptionType.connectionTimeout,
    errorMessage: 'took too long',
    stackTrace: '#0 main\n#1 run',
  );
  final image = request(
    'i1',
    url: 'https://cdn.example.com/a.png',
    responseBody: base64Encode([1, 2, 3]),
    responseContentType: 'image/png',
  );

  group('RequestRedactor', () {
    test('masks listed headers and query values', () {
      final r = RequestRedactor.redact(post, settings);
      expect(r.requestHeaders['Authorization'], RequestRedactor.mask);
      expect(r.requestHeaders['Accept'], 'json');
      expect(r.responseHeaders['set-cookie'], RequestRedactor.mask);
      expect(
        r.queryParameters.firstWhere((p) => p.key == 'token').value,
        RequestRedactor.mask,
      );
      expect(r.queryParameters.firstWhere((p) => p.key == 'page').value, '2');
    });

    test('leaves everything when redaction is off', () {
      final r = RequestRedactor.redact(
        post,
        settings.copyWith(redactionMode: DioLensRedactionMode.none),
      );
      expect(r, post);
    });
  });

  group('ExportBuilder', () {
    test('HAR 1.2', () {
      final har = jsonDecode(
        utf8.decode(
          ExportBuilder.build(
            DioLensExportFormat.har,
            [image, failed, post],
            settings,
            DateTime(2026),
          ),
        ),
      ) as Map<String, dynamic>;
      final log = har['log'] as Map<String, dynamic>;
      expect(log['version'], '1.2');
      final entries = log['entries'] as List;
      expect(entries, hasLength(3));
      expect(
        entries.first['request']['url'],
        contains('/v1/orders'),
        reason: 'oldest first',
      );

      final p = entries.first as Map;
      expect(p['request']['method'], 'POST');
      expect(p['request']['url'], contains('token=%5BREDACTED%5D'));
      expect(
        (p['request']['headers'] as List).firstWhere(
          (h) => h['name'] == 'Authorization',
        )['value'],
        RequestRedactor.mask,
      );
      expect(p['request']['postData']['text'], '{"item":1}');
      expect(p['response']['status'], 201);
      expect(p['response']['content']['text'], '{"id":7}');

      final f = entries[1] as Map;
      expect(f['response']['status'], 0);
      expect(f['_error'], 'connectionTimeout: took too long');

      final i = entries[2] as Map;
      expect(i['response']['content']['encoding'], 'base64');
      expect(i['response']['content']['text'], base64Encode([1, 2, 3]));
    });

    test('JSON keeps Dio Lens records, masked', () {
      final doc = jsonDecode(
        utf8.decode(
          ExportBuilder.build(
            DioLensExportFormat.json,
            [post],
            settings,
            DateTime(2026),
          ),
        ),
      ) as Map<String, dynamic>;
      expect(doc['request_count'], 1);
      final r = (doc['requests'] as List).single as Map;
      expect(r['request_headers']['Authorization'], RequestRedactor.mask);
      expect(r['request_body'], {'item': 1});
    });
  });

  group('ShareContentBuilder', () {
    test('completed request report', () {
      final c = ShareContentBuilder.build(post, settings);
      expect(c.subject, 'POST /v1/orders · 201');
      expect(c.text, contains('=============== Overview ==============='));
      expect(
        c.text,
        contains(
          'URL: https://api.example.com/v1/orders?token=[REDACTED]&page=2',
        ),
      );
      expect(c.text, contains('Authorization: [REDACTED]'));
      expect(c.text, contains('"id": 7'));
      expect(c.text, contains('=============== Response ==============='));
      expect(
        c.text,
        contains(
          "curl -X POST 'https://api.example.com/v1/orders?token=%5BREDACTED%5D",
        ),
      );
      expect(c.text, isNot(contains('Bearer secret')));
    });

    test('failed request report has the error, not a response', () {
      final c = ShareContentBuilder.build(failed, settings);
      expect(c.subject, 'GET /v1/sync · Failed (connectionTimeout)');
      expect(c.text, contains('Type: DioExceptionType.connectionTimeout'));
      expect(c.text, contains('-- Stack trace --'));
      expect(c.text, isNot(contains('=============== Response')));
    });

    test('images are not included', () {
      expect(
        ShareContentBuilder.build(image, settings).text,
        contains('(image, not included)'),
      );
    });
  });

  test('the report is masked for the target it goes to', () {
    String reportFor(
      DioLensRedactionMode mode, {
      DioLensRedactionTarget target = DioLensRedactionTarget.ui,
    }) => ShareContentBuilder.build(
      post,
      DioLensSettings(redactionMode: mode),
      target: target,
    ).text;

    // Handed to the app: the UI target, cURL included.
    final shared = reportFor(DioLensRedactionMode.clipboard);
    expect(shared, contains('Authorization: Bearer secret'));
    expect(
      shared.substring(shared.indexOf('curl -X')),
      contains('Bearer secret'),
    );
    expect(
      reportFor(DioLensRedactionMode.ui),
      isNot(contains('Bearer secret')),
    );

    // Copied: the clipboard target.
    final copied = reportFor(
      DioLensRedactionMode.clipboard,
      target: DioLensRedactionTarget.clipboard,
    );
    expect(copied, contains('Authorization: [REDACTED]'));
    expect(copied, isNot(contains('Bearer secret')));
  });
}
