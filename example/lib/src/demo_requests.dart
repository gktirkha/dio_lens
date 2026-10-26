import 'package:dio/dio.dart';

/// One button: a request the example can make.
class DemoRequest {
  /// Creates the request.
  const DemoRequest(this.method, this.title, this.subtitle, this.send);

  /// HTTP method shown on the button.
  final String method;

  /// Button title.
  final String title;

  /// What the request does.
  final String subtitle;

  /// Makes the request.
  final Future<Response<dynamic>> Function() send;
}

/// One request per HTTP method.
List<DemoRequest> methodRequests(Dio dio) => [
  DemoRequest('GET', 'Get', 'GET /get?page=2&limit=20', () {
    return dio.get('/get', queryParameters: {'page': 2, 'limit': 20});
  }),
  DemoRequest(
    'GET',
    'Secret query',
    'GET /get?token=…&apikey=… (redacted)',
    () {
      // token and apikey are in redactedQueryParams by default; page is not.
      return dio.get(
        '/get',
        queryParameters: {
          'token': 'example-token',
          'apikey': 'example-key',
          'page': 1,
        },
      );
    },
  ),
  DemoRequest('POST', 'Create', 'POST /post with a JSON body', () {
    return dio.post(
      '/post',
      data: {
        'title': 'New order',
        'items': [
          {'id': 301, 'quantity': 1},
          {'id': 302, 'quantity': 2},
        ],
        'express': true,
      },
    );
  }),
  DemoRequest('PUT', 'Replace', 'PUT /put with a JSON body', () {
    return dio.put('/put', data: {'id': 42, 'name': 'Ava', 'role': 'admin'});
  }),
  DemoRequest('PATCH', 'Update', 'PATCH /patch with a partial body', () {
    return dio.patch('/patch', data: {'marketingEmails': false});
  }),
  DemoRequest(
    'DELETE',
    'Delete',
    'DELETE /delete',
    () => dio.delete('/delete'),
  ),
  DemoRequest('QUERY', 'Query', 'QUERY /anything/orders/search', () {
    return dio.request(
      '/anything/orders/search',
      data: {
        'filter': {
          'status': ['shipped'],
          'minTotal': 50,
        },
        'limit': 20,
      },
      options: Options(method: 'QUERY'),
    );
  }),
  DemoRequest(
    'HEAD',
    'Head',
    'HEAD /get (headers only)',
    () => dio.head('/get'),
  ),
  DemoRequest('OPTIONS', 'Options', 'OPTIONS /anything', () {
    return dio.request('/anything', options: Options(method: 'OPTIONS'));
  }),
];

/// Request and response bodies of every kind, and non-2xx statuses.
List<DemoRequest> bodyRequests(Dio dio) => [
  DemoRequest('POST', 'Form login', 'x-www-form-urlencoded body', () {
    return dio.post(
      '/post',
      data: {'username': 'ava', 'password': 'hunter2'},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }),
  DemoRequest('POST', 'Upload file', 'multipart/form-data with a file', () {
    return dio.post(
      '/post',
      data: FormData.fromMap({
        'caption': 'Avatar',
        'file': MultipartFile.fromString(
          'pretend these are image bytes',
          filename: 'avatar.jpg',
        ),
      }),
    );
  }),
  DemoRequest('GET', 'Image', 'image/png response body', () {
    return dio.get(
      '/image/png',
      options: Options(responseType: ResponseType.bytes),
    );
  }),
  DemoRequest('GET', 'Plain text', 'text/plain response body', () {
    return dio.get('/robots.txt');
  }),
  DemoRequest('GET', 'Redirect', '302 followed to /get', () {
    return dio.get('/redirect/1');
  }),
  DemoRequest('GET', 'Not found', '404 response', () => dio.get('/status/404')),
  DemoRequest('POST', 'Server error', '500 response', () {
    return dio.post('/status/500', data: {'retry': true});
  }),
  DemoRequest('GET', 'Slow', 'Responds after 3 seconds', () {
    return dio.get('/delay/3');
  }),
];

/// Requests that fail without a response, one per [DioExceptionType], so
/// Dio Lens shows the error card and stack trace. [pinnedDio] rejects every
/// certificate.
List<DemoRequest> failureRequests(Dio dio, Dio pinnedDio) => [
  DemoRequest(
    'GET',
    'Connection timeout',
    'Unroutable IP, 2s connectTimeout',
    () {
      return dio.fetch(
        RequestOptions(
          path: 'http://10.255.255.1/v1/sync',
          connectTimeout: const Duration(seconds: 2),
        ),
      );
    },
  ),
  DemoRequest(
    'POST',
    'Send timeout',
    '5 MB upload with a 1 ms sendTimeout',
    () {
      return dio.post(
        '/post',
        data: 'x' * (5 * 1024 * 1024),
        options: Options(
          contentType: 'text/plain',
          sendTimeout: const Duration(milliseconds: 1),
        ),
      );
    },
  ),
  DemoRequest(
    'GET',
    'Receive timeout',
    '1s receiveTimeout on a 5s endpoint',
    () {
      return dio.get(
        '/delay/5',
        options: Options(receiveTimeout: const Duration(seconds: 1)),
      );
    },
  ),
  DemoRequest('GET', 'Bad certificate', 'Certificate pinning rejects host', () {
    return pinnedDio.get('/get');
  }),
  DemoRequest('GET', 'Connection error', 'Host does not resolve', () {
    return dio.get('https://no-such-host.invalid/v1/status');
  }),
  DemoRequest('GET', 'Cancelled', 'Cancelled 50 ms after sending', () {
    final token = CancelToken();
    Future<void>.delayed(const Duration(milliseconds: 50), token.cancel);
    return dio.get('/delay/2', cancelToken: token);
  }),
  DemoRequest('GET', 'Unknown', 'Response decoder throws', () {
    return dio.get(
      '/get',
      options: Options(
        responseDecoder: (_, _, _) =>
            throw const FormatException('Unexpected token < in JSON at 0'),
      ),
    );
  }),
];
