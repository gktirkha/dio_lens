import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/core/runtime/dio_lens_runtime.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_adapter.dart';
import '../helpers/memory_storage.dart';

const _quiet = DioLensSettings(showBubble: false, showNotification: false);

Future<void> drain() => Future<void>.delayed(const Duration(milliseconds: 150));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => DioLensRuntime.current = null);

  Dio dioWith(FakeAdapter adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
      ..httpClientAdapter = adapter;
    return dio..interceptors.add(DioLensInterceptor(dio: dio, name: 'api'));
  }

  test('does nothing before init', () async {
    final adapter = FakeAdapter();
    final response = await dioWith(adapter).get<dynamic>('/v1/a');
    expect(response.statusCode, 200);
  });

  test('does nothing when the mode is off', () async {
    final storage = MemoryStorage();
    DioLens.init(
      navigatorKey: GlobalKey(),
      storage: storage,
      uiMode: DioLensMode.none,
      consoleMode: DioLensMode.none,
      settings: _quiet,
    );
    await dioWith(FakeAdapter()).get<dynamic>('/v1/a');
    await drain();
    expect(DioLens.isUiEnabled, isFalse);
    expect(storage.requests, isEmpty);
  });

  test('records responses, error statuses and failures', () async {
    final storage = MemoryStorage();
    DioLens.init(
      navigatorKey: GlobalKey(),
      storage: storage,
      uiMode: DioLensMode.all,
      consoleMode: DioLensMode.none,
      settings: _quiet,
    );
    final dio = dioWith(
      FakeAdapter((o) async {
        if (o.path.endsWith('/missing')) return FakeAdapter.json({'e': 1}, 404);
        if (o.path.endsWith('/timeout')) {
          throw DioException.connectionTimeout(
            timeout: const Duration(seconds: 1),
            requestOptions: o,
          );
        }
        return FakeAdapter.json({'ok': true});
      }),
    );

    await dio.post<dynamic>('/v1/orders', data: {'item': 1});
    await dio
        .get<dynamic>('/v1/missing')
        .catchError((_) => Response<dynamic>(requestOptions: RequestOptions()));
    await dio
        .get<dynamic>('/v1/timeout')
        .catchError((_) => Response<dynamic>(requestOptions: RequestOptions()));
    await drain();

    final store = DioLensRuntime.current!.store;
    final byPath = {for (final r in store.requests) r.path: r};
    expect(
      byPath.keys,
      containsAll(['/v1/orders', '/v1/missing', '/v1/timeout']),
    );
    expect(byPath['/v1/orders']!.statusCode, 200);
    expect(byPath['/v1/missing']!.state, RequestState.completed);
    expect(byPath['/v1/missing']!.statusCode, 404);
    expect(byPath['/v1/timeout']!.state, RequestState.failed);
    expect(
      byPath['/v1/timeout']!.errorType,
      DioExceptionType.connectionTimeout,
    );

    final order = (await store.getRequest(byPath['/v1/orders']!.id))!;
    expect(order.requestBody, {'item': 1});
    expect(order.responseBody, {'ok': true});
    expect(order.clientName, 'api');
    expect(storage.requests, hasLength(3));
  });

  test('never changes the response the app receives', () async {
    DioLens.init(
      navigatorKey: GlobalKey(),
      storage: MemoryStorage(),
      uiMode: DioLensMode.all,
      consoleMode: DioLensMode.none,
      settings: _quiet,
    );
    final response = await dioWith(FakeAdapter()).get<dynamic>('/v1/a');
    expect(response.data, {'ok': true});
  });

  group('console', () {
    Future<List<String>> logsFor({
      required DioLensMode consoleMode,
      DioLensMode uiMode = DioLensMode.none,
    }) async {
      DioLens.init(
        navigatorKey: GlobalKey(),
        storage: MemoryStorage(),
        uiMode: uiMode,
        consoleMode: consoleMode,
        settings: _quiet,
      );
      final lines = <String>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
        ..httpClientAdapter = FakeAdapter((o) async {
          if (o.path.endsWith('/missing')) {
            return FakeAdapter.json({'e': 1}, 404);
          }
          return FakeAdapter.json({'ok': true});
        });
      dio.interceptors.add(
        DioLensInterceptor(dio: dio, logPrint: (line) => lines.add('$line')),
      );
      await dio.get<dynamic>('/v1/a');
      await dio
          .get<dynamic>('/v1/missing')
          .catchError(
            (_) => Response<dynamic>(requestOptions: RequestOptions()),
          );
      return lines;
    }

    test('prints nothing when the console mode is off', () async {
      expect(await logsFor(consoleMode: DioLensMode.none), isEmpty);
      expect(DioLens.isConsoleEnabled, isFalse);
    });

    test(
      'prints requests, responses and errors when on, even with the UI off',
      () async {
        final logs = (await logsFor(consoleMode: DioLensMode.all)).join('\n');
        expect(DioLens.isConsoleEnabled, isTrue);
        expect(DioLens.isUiEnabled, isFalse);
        expect(logs, contains('[REQUEST]'));
        expect(logs, contains('[RESPONSE]'));
        expect(logs, contains('[ERROR]'));
        expect(logs, contains('https://api.example.com/v1/missing'));
      },
    );

    test('prints a single padding line for an empty body', () async {
      DioLens.init(
        navigatorKey: GlobalKey(),
        storage: MemoryStorage(),
        consoleMode: DioLensMode.all,
        settings: _quiet,
      );
      final lines = <String>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
        ..httpClientAdapter = FakeAdapter(
          (_) async => ResponseBody.fromString('', 204),
        );
      dio.interceptors.add(
        DioLensInterceptor(dio: dio, logPrint: (line) => lines.add('$line')),
      );
      await dio.get<dynamic>('/v1/empty');

      final body = lines.indexWhere((l) => l.contains('[RESPONSE] ║ Body'));
      expect(lines[body + 1], '║');
      expect(lines[body + 2], startsWith('╚'));
    });
  });
}
