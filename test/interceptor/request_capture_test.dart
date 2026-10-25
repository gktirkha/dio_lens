import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/interceptor/request_capture.dart';
import 'package:flutter_test/flutter_test.dart';

Response<dynamic> response(
  RequestOptions options,
  Object? data, {
  int status = 200,
  String? contentType,
  Map<String, List<String>> headers = const {},
}) => Response<dynamic>(
  requestOptions: options,
  data: data,
  statusCode: status,
  headers: Headers.fromMap({
    ...headers,
    if (contentType != null) Headers.contentTypeHeader: [contentType],
  }),
);

void main() {
  final started = DateTime(2026, 10, 25, 12);

  Future<dynamic> pending(Object? data, {String? contentType, int? max}) =>
      RequestCapture.pending(
        id: '1',
        startedAt: started,
        options: RequestOptions(
          path: 'https://api.example.com/v1/x?page=2',
          method: 'post',
          data: data,
          contentType: contentType,
          headers: {
            'Authorization': 'Bearer t',
            'X-List': ['a', 'b'],
          },
        ),
        maxBodyBytes: max,
      );

  group('request part', () {
    test('JSON map body', () async {
      final r = await pending({
        'item': 1,
        'tags': ['a'],
      }, contentType: Headers.jsonContentType);
      expect(r.method, 'POST');
      expect(r.state, RequestState.pending);
      expect(r.requestBody, {
        'item': 1,
        'tags': ['a'],
      });
      expect(
        r.requestSize,
        utf8
            .encode(
              jsonEncode({
                'item': 1,
                'tags': ['a'],
              }),
            )
            .length,
      );
      expect(r.requestHeaders['X-List'], 'a, b');
      expect(r.requestBodyIncomplete, isFalse);
      expect(r.hasFileUpload, isFalse);
    });

    test('JSON text is decoded', () async {
      final r = await pending('{"a":1}', contentType: Headers.jsonContentType);
      expect(r.requestBody, {'a': 1});
    });

    test('form data keeps fields and describes files', () async {
      final r = await pending(
        FormData.fromMap({
          'caption': 'hi',
          'file': MultipartFile.fromString('abc', filename: 'a.txt'),
        }),
      );
      expect(r.requestBody, {'caption': 'hi', 'file': 'a.txt (3 bytes)'});
      expect(r.requestContentType, contains('multipart/form-data'));
      expect(r.hasFileUpload, isTrue);
    });

    test('bodies over the limit are truncated and flagged', () async {
      final r = await pending('x' * 500, contentType: 'text/plain', max: 100);
      expect(r.requestBody, startsWith('x' * 100));
      expect(r.requestBody, contains('Truncated by Dio Lens'));
      expect(r.requestSize, 500);
      expect(r.requestBodyIncomplete, isTrue);
    });

    test('unlimited keeps everything', () async {
      final r = await pending('x' * 5000, contentType: 'text/plain');
      expect(r.requestBody, 'x' * 5000);
      expect(r.requestBodyIncomplete, isFalse);
    });

    test('objects without toJson fall back to toString', () async {
      final r = await pending(_Thing());
      expect(r.requestBody, 'a thing');
    });

    test(
      'objects that cannot go to an isolate are captured on the caller',
      () async {
        final r = await pending(_WithClosure(() {}));
        expect(r.requestBody, {'closure': true});
      },
    );
  });

  group('response part', () {
    final options = RequestOptions(path: 'https://api.example.com/v1/x');
    final request = RequestCapture.pending(
      id: '1',
      startedAt: started,
      options: options,
    );

    test('JSON response', () async {
      final r = await RequestCapture.completed(
        await request,
        response(
          options,
          {'ok': true},
          status: 201,
          contentType: Headers.jsonContentType,
          headers: {
            'set-cookie': ['a=1', 'b=2'],
          },
        ),
        finishedAt: started.add(const Duration(milliseconds: 96)),
      );
      expect(r.state, RequestState.completed);
      expect(r.statusCode, 201);
      expect(r.duration, const Duration(milliseconds: 96));
      expect(r.responseBody, {'ok': true});
      expect(r.responseHeaders['set-cookie'], 'a=1, b=2');
    });

    test(
      'images are kept as base64 within the limit, dropped above it',
      () async {
        final bytes = List.filled(2048, 7);
        final kept = await RequestCapture.completed(
          await request,
          response(options, bytes, contentType: 'image/png'),
          finishedAt: started,
        );
        expect(kept.responseBody, base64Encode(bytes));
        final dropped = await RequestCapture.completed(
          await request,
          response(options, bytes, contentType: 'image/png'),
          finishedAt: started,
          maxBodyBytes: 1024,
        );
        expect(dropped.responseBody, isNull);
        expect(dropped.responseSize, 2048);
      },
    );

    test('other binary bodies keep only their size', () async {
      final r = await RequestCapture.completed(
        await request,
        response(
          options,
          List.filled(10, 1),
          contentType: 'application/octet-stream',
        ),
        finishedAt: started,
      );
      expect(r.responseBody, isNull);
      expect(r.responseSize, 10);
    });

    test('content-length wins for the size', () async {
      final r = await RequestCapture.completed(
        await request,
        response(
          options,
          'hi',
          contentType: 'text/plain',
          headers: {
            Headers.contentLengthHeader: ['999'],
          },
        ),
        finishedAt: started,
      );
      expect(r.responseSize, 999);
    });

    test('failure without a response', () async {
      final r = RequestCapture.failed(
        await request,
        DioException.connectionTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: options,
        ),
        finishedAt: started.add(const Duration(seconds: 1)),
      );
      expect(r.state, RequestState.failed);
      expect(r.errorType, DioExceptionType.connectionTimeout);
      expect(r.errorMessage, isNotEmpty);
      expect(r.stackTrace, isNotEmpty);
    });
  });
}

class _Thing {
  @override
  String toString() => 'a thing';
}

class _WithClosure {
  _WithClosure(this.callback);
  final void Function() callback;
  Map<String, dynamic> toJson() => {'closure': true};
}
