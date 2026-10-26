import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/features/console/data/dio_lens_console_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RequestOptions request() => RequestOptions(
    path: '/v1/items',
    baseUrl: 'https://api.example.com',
    method: 'POST',
    headers: {'authorization': 'secret', 'accept': 'application/json'},
    queryParameters: {'page': 1, 'token': 'secret'},
    data: {'name': 'Item', 'password': 'secret'},
    extra: {'app': 'test'},
  );

  List<String> capture({
    required bool showState,
    DioLensSettings settings = const DioLensSettings(),
  }) {
    final lines = <String>[];
    final logger = DioLensConsoleLogger(
      settings: DioLensConsoleSettings(showStateInHeader: showState),
      logPrint: (Object line) => lines.add(line.toString()),
    );
    final options = request();
    final responseHeaders = Headers.fromMap({
      'content-type': ['application/json'],
    });

    logger.logRequest(options, settings);
    logger.logResponse(
      Response<dynamic>(
        requestOptions: options,
        statusCode: 201,
        headers: responseHeaders,
        data: {'ok': true},
      ),
      settings,
    );
    logger.logError(
      DioException(
        requestOptions: options,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 500,
          headers: responseHeaders,
          data: {'message': 'failed'},
        ),
        type: DioExceptionType.badResponse,
        message: 'failed',
      ),
      settings,
    );
    return lines;
  }

  test('prefixes every section header with the state', () {
    final logs = capture(showState: true).join('\n');

    expect(logs, contains('[REQUEST] ║ POST'));
    expect(logs, contains('[REQUEST] ║ Query Parameters'));
    expect(logs, contains('[REQUEST] ║ Headers'));
    expect(logs, contains('[REQUEST] ║ Extras'));
    expect(logs, contains('[REQUEST] ║ Request Body'));
    expect(logs, contains('[RESPONSE] ║ POST'));
    expect(logs, contains('[RESPONSE] ║ Headers'));
    expect(logs, contains('[RESPONSE] ║ Body'));
    expect(logs, contains('[ERROR] ║ DioError'));
    expect(logs, contains('[ERROR] ║ Response Headers'));
  });

  test('omits state labels from every section header', () {
    final logs = capture(showState: false).join('\n');

    expect(logs, isNot(contains('[REQUEST]')));
    expect(logs, isNot(contains('[RESPONSE]')));
    expect(logs, isNot(contains('[ERROR]')));
    expect(logs, contains('Query Parameters'));
    expect(logs, contains('Request Body'));
    expect(logs, contains('Response Headers'));
  });

  test('masks secrets as the redaction mode says', () {
    for (final mode in DioLensRedactionMode.values) {
      final masked = mode.inConsole;
      final logs = capture(
        showState: true,
        settings: DioLensSettings(redactionMode: mode),
      ).join('\n');
      expect(logs.contains('secret'), !masked, reason: '$mode');
      expect(logs.contains('[REDACTED]'), masked, reason: '$mode');
    }
  });
}
