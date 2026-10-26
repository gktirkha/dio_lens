import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/runtime/dio_lens_runtime.dart';
import 'package:dio_lens/src/features/request_detail/domain/entities/request_detail_entity.dart';
import 'package:dio_lens/src/interceptor/request_replayer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_adapter.dart';
import '../helpers/memory_storage.dart';

RequestDetailEntity earlier(
  String id, {
  String url = 'https://same.host/v1/x',
  String? client,
  bool upload = false,
  bool incomplete = false,
}) => RequestDetailEntity.fromJson({
  'id': id,
  'method': 'POST',
  'uri': url,
  'started_at': DateTime.now().toIso8601String(),
  'state': 'completed',
  'request_body': {'a': 1},
  'request_content_type': 'application/json',
  'client_name': client,
  'has_file_upload': upload,
  'request_body_incomplete': incomplete,
});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => DioLensRuntime.current = null);

  test('this run: replays the original request exactly', () async {
    DioLens.init(
      navigatorKey: GlobalKey(),
      storage: MemoryStorage(),
      uiMode: DioLensMode.all,
      consoleMode: DioLensMode.none,
      settings: const DioLensSettings(
        maxBodyBytes: 100,
        showBubble: false,
        showNotification: false,
      ),
    );
    final adapter = FakeAdapter((o) async {
      if (o.path.endsWith('/slow')) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      return FakeAdapter.json({'ok': true});
    });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
      ..httpClientAdapter = adapter;
    dio.interceptors.add(DioLensInterceptor(dio: dio));

    await dio.post<dynamic>(
      '/upload',
      data: FormData.fromMap({
        'file': MultipartFile.fromString('FILE-CONTENTS', filename: 'a.txt'),
      }),
    );
    await dio.post<dynamic>(
      '/big',
      data: 'x' * 1000,
      options: Options(contentType: 'text/plain'),
    );
    final token = CancelToken();
    Future<void>.delayed(const Duration(milliseconds: 20), token.cancel);
    await dio
        .get<dynamic>('/slow', cancelToken: token)
        .catchError((_) => Response<dynamic>(requestOptions: RequestOptions()));
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final runtime = DioLensRuntime.current!;
    Future<RequestDetailEntity> captured(String path) async =>
        (await runtime.store.getRequest(
          runtime.store.requests.firstWhere((r) => r.path == path).id,
        ))!;

    final upload = await captured('/upload');
    final big = await captured('/big');
    expect(upload.hasFileUpload, isTrue);
    expect(big.requestBodyIncomplete, isTrue);
    expect(runtime.replayer.unavailableReason(upload), isNull);

    adapter.bodies.clear();
    await runtime.replayer.replay(upload);
    await runtime.replayer.replay(big);
    await runtime.replayer.replay(await captured('/slow'));
    expect(adapter.bodies[0], contains('FILE-CONTENTS'));
    expect(adapter.bodies[1], hasLength(1000));
    expect(adapter.bodies, hasLength(3));
  });

  test('earlier runs: picks the Dio by name, then by host', () async {
    final a = FakeAdapter(), b = FakeAdapter();
    final dioA = Dio(BaseOptions(baseUrl: 'https://same.host'))
      ..httpClientAdapter = a;
    final dioB = Dio(BaseOptions(baseUrl: 'https://same.host'))
      ..httpClientAdapter = b;
    final replayer = RequestReplayer()
      ..register('x1', dioB, name: 'pinned')
      ..register('x2', dioA);

    await replayer.replay(earlier('o1', client: 'pinned'));
    expect((a.requests.length, b.requests.length), (0, 1));
    await replayer.replay(earlier('o2'));
    expect((a.requests.length, b.requests.length), (1, 1));
    expect(a.requests.last.data, {'a': 1});
  });

  test('earlier runs: refuses what was not fully captured', () async {
    final adapter = FakeAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://same.host'))
      ..httpClientAdapter = adapter;
    final replayer = RequestReplayer()..register('x', dio);

    final upload = earlier('u', upload: true);
    final partial = earlier('p', incomplete: true);
    expect(
      replayer.unavailableReason(upload),
      "the file upload wasn't captured",
    );
    expect(
      replayer.unavailableReason(partial),
      "the request body wasn't fully captured",
    );
    await replayer.replay(upload);
    await replayer.replay(partial);
    expect(adapter.requests, isEmpty);
  });
}
