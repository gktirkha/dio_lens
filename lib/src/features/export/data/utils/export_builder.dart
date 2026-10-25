import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/dio_lens_version.dart';
import '../../../../core/enums/export_format.dart';
import '../../../../core/enums/request_state.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../../settings/domain/utils/request_redactor.dart';

/// Builds export files from captured requests. Pure, so it can run in an
/// isolate.
abstract final class ExportBuilder {
  /// [requests] in [format], UTF-8 encoded, with values masked as
  /// [settings] say.
  static Uint8List build(
    DioLensExportFormat format,
    List<RequestDetailEntity> requests,
    DioLensSettings settings,
    DateTime createdAt,
  ) {
    final masked = [
      for (final r in requests) RequestRedactor.redact(r, settings),
    ];
    final json = switch (format) {
      DioLensExportFormat.har => har(masked),
      DioLensExportFormat.json => {
        'exported_at': createdAt.toIso8601String(),
        'dio_lens_version': dioLensVersion,
        'request_count': masked.length,
        'requests': [for (final r in masked) r.toJson()],
      },
    };
    return utf8.encode(const JsonEncoder.withIndent('  ').convert(json));
  }

  /// HTTP Archive 1.2 (http://www.softwareishard.com/blog/har-12-spec/).
  static Map<String, Object?> har(List<RequestDetailEntity> requests) => {
    'log': {
      'version': '1.2',
      'creator': {'name': 'Dio Lens', 'version': dioLensVersion},
      'pages': <Object>[],
      // HAR lists entries oldest first.
      'entries': [for (final r in requests.reversed) _harEntry(r)],
    },
  };

  static Map<String, Object?> _harEntry(RequestDetailEntity r) {
    final time = r.duration?.inMilliseconds ?? 0;
    final httpVersion = r.protocol ?? 'HTTP/1.1';
    final requestText = _bodyText(r.requestBody, r.requestContentType);
    final responseImage =
        (r.responseContentType ?? '').toLowerCase().startsWith('image/') &&
        r.responseBody is String;
    final responseText = responseImage
        ? r.responseBody as String
        : _bodyText(r.responseBody, r.responseContentType);
    return {
      'startedDateTime': r.startedAt.toUtc().toIso8601String(),
      'time': time,
      'request': {
        'method': r.method,
        'url': r.uri.toString(),
        'httpVersion': httpVersion,
        'cookies': <Object>[],
        'headers': _pairs(r.requestHeaders.entries),
        'queryString': [
          for (final p in r.queryParameters) {'name': p.key, 'value': p.value},
        ],
        'postData': ?requestText == null
            ? null
            : {'mimeType': r.requestContentType ?? '', 'text': requestText},
        'headersSize': -1,
        'bodySize': r.requestSize ?? -1,
      },
      'response': {
        'status': r.statusCode ?? 0,
        'statusText': '',
        'httpVersion': httpVersion,
        'cookies': <Object>[],
        'headers': _pairs(r.responseHeaders.entries),
        'content': {
          'size': r.responseSize ?? 0,
          'mimeType': r.responseContentType ?? '',
          'text': ?responseText,
          if (responseImage) 'encoding': 'base64',
        },
        'redirectURL': '',
        'headersSize': -1,
        'bodySize': r.responseSize ?? -1,
      },
      'cache': <String, Object>{},
      'timings': {'send': 0, 'wait': time, 'receive': 0},
      if (r.state == RequestState.pending) 'comment': 'Pending',
      if (r.state == RequestState.failed)
        '_error': '${r.errorType?.name ?? 'unknown'}: ${r.errorMessage ?? ''}',
    };
  }

  static List<Map<String, String>> _pairs(
    Iterable<MapEntry<String, String>> entries,
  ) => [
    for (final e in entries) {'name': e.key, 'value': e.value},
  ];

  /// A decoded body as the text that was sent: form maps URL-encoded,
  /// JSON encoded, text as is.
  static String? _bodyText(Object? body, String? contentType) {
    if (body == null) return null;
    if (body is String) return body;
    if ((contentType ?? '').toLowerCase().contains('x-www-form-urlencoded') &&
        body is Map) {
      return [
        for (final e in body.entries)
          '${Uri.encodeQueryComponent('${e.key}')}='
              '${Uri.encodeQueryComponent('${e.value}')}',
      ].join('&');
    }
    return jsonEncode(body);
  }
}
