import 'package:dio/dio.dart' show DioExceptionType;
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/core/storage/dio_lens_store.dart';
import 'package:dio_lens/src/features/request_detail/domain/entities/request_detail_entity.dart';
import 'package:dio_lens/src/features/request_home/data/mappers/request_list_item_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/entities.dart';
import '../helpers/memory_storage.dart';

Future<void> drain() => Future<void>.delayed(const Duration(milliseconds: 50));

DioLensStore storeOver(
  MemoryStorage storage, {
  DioLensSettings settings = const DioLensSettings(
    retention: DioLensRetention.always,
  ),
}) => DioLensStore(storage: () => storage, initialSettings: settings);

void seed(MemoryStorage storage, RequestDetailEntity r) => storage.writeRequest(
  r.id,
  request: r.toJson(),
  summary: r.toListItem().toJson(),
);

void main() {
  test(
    'add and update keep summaries in memory and full records stored',
    () async {
      final storage = MemoryStorage();
      final store = storeOver(storage);
      await store.add(request('a', state: RequestState.pending));
      await store.update(request('a', statusCode: 201, responseBody: {'x': 1}));
      await drain();
      expect(store.requests.single.statusCode, 201);
      expect(storage.summaries['a']!.containsKey('response_body'), isFalse);
      expect(storage.requests['a']!['response_body'], {'x': 1});
      expect((await store.getRequest('a'))!.responseBody, {'x': 1});
    },
  );

  test('update of an unknown request is ignored', () async {
    final store = storeOver(MemoryStorage());
    await store.update(request('ghost'));
    expect(store.requests, isEmpty);
  });

  test('loads summaries newest first and full records on demand', () async {
    final storage = MemoryStorage();
    for (var i = 0; i < 30; i++) {
      seed(
        storage,
        request(
          'r$i',
          ago: Duration(minutes: 30 - i),
          responseBody: {'n': i},
        ),
      );
    }
    final store = storeOver(storage);
    await store.ready;
    expect(store.requests, hasLength(30));
    expect(store.requests.first.id, 'r29');
    expect((await store.getRequest('r3'))!.responseBody, {'n': 3});
    expect(await store.getAllRequests(), hasLength(30));
  });

  test(
    'requests left pending by an earlier run are settled as failed',
    () async {
      final storage = MemoryStorage();
      seed(storage, request('p', state: RequestState.pending));
      final store = storeOver(storage);
      await store.ready;
      expect(store.requests.single.state, RequestState.failed);
      await drain();
      final stored = (await store.getRequest('p'))!;
      expect(stored.state, RequestState.failed);
      expect(stored.errorType, DioExceptionType.unknown);
    },
  );

  test('corrupt stored rows are dropped and deleted', () async {
    final storage = MemoryStorage();
    storage.requests['bad'] = {'id': 'bad', 'nonsense': true};
    final store = storeOver(storage);
    await store.ready;
    await drain();
    expect(store.requests, isEmpty);
    expect(storage.deleted, contains('bad'));
  });

  test('max requests drops the oldest', () async {
    final storage = MemoryStorage();
    final store = storeOver(
      storage,
      settings: const DioLensSettings(
        maxRequests: 10,
        retention: DioLensRetention.always,
      ),
    );
    for (var i = 0; i < 13; i++) {
      await store.add(request('r$i'));
    }
    await drain();
    expect(store.requests, hasLength(10));
    expect(store.requests.last.id, 'r3');
    expect(storage.requests.keys, isNot(contains('r0')));
  });

  test(
    'retention drops expired requests on load, update and removeExpired',
    () async {
      final storage = MemoryStorage();
      seed(storage, request('old', ago: const Duration(hours: 2)));
      seed(storage, request('fresh'));
      final store = storeOver(
        storage,
        settings: const DioLensSettings(retention: DioLensRetention.oneHour),
      );
      await store.ready;
      expect(store.requests.map((r) => r.id), ['fresh']);

      final later = storeOver(
        MemoryStorage(),
        settings: const DioLensSettings(retention: DioLensRetention.oneHour),
      );
      await later.add(
        request(
          'edge',
          ago: const Duration(hours: 1) - const Duration(milliseconds: 100),
        ),
      );
      expect(later.requests.map((r) => r.id), ['edge']);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(later.requests, hasLength(1), reason: 'no timer');
      await later.removeExpired();
      expect(later.requests, isEmpty);
    },
  );

  test('session retention clears earlier runs without reading them', () async {
    final storage = MemoryStorage()
      ..settings = const DioLensSettings(retention: DioLensRetention.session)
          .toJson();
    seed(storage, request('a'));
    final store = storeOver(storage);
    await store.ready;
    await drain();
    expect(store.requests, isEmpty);
    expect(storage.clears, 1);
  });

  test('watchRequest follows updates and removal', () async {
    final store = storeOver(MemoryStorage());
    final events = <RequestDetailEntity?>[];
    final sub = store.watchRequest('w').listen(events.add);
    await store.add(request('w', state: RequestState.pending));
    await drain();
    await store.update(request('w', statusCode: 204));
    await drain();
    await store.delete('w');
    await drain();
    await sub.cancel();
    expect(events.whereType<RequestDetailEntity>().map((e) => e.state), [
      RequestState.pending,
      RequestState.completed,
    ]);
    expect(events.last, isNull);
  });

  test('details stay readable beyond the cache size', () async {
    final store = storeOver(MemoryStorage());
    for (var i = 0; i < DioLensStore.detailCacheSize + 10; i++) {
      await store.add(request('c$i', responseBody: {'n': i}));
    }
    await drain();
    expect((await store.getRequest('c0'))!.responseBody, {'n': 0});
  });

  test('clear and delete', () async {
    final storage = MemoryStorage();
    final store = storeOver(storage);
    await store.add(request('a'));
    await store.add(request('b'));
    await store.delete('a');
    expect(store.requests.map((r) => r.id), ['b']);
    expect(await store.getRequest('a'), isNull);
    await store.clear();
    await drain();
    expect(store.requests, isEmpty);
    expect(storage.requests, isEmpty);
  });

  test('settings: stored copy wins, update trims, reset restores', () async {
    final storage = MemoryStorage()
      ..settings = const DioLensSettings(maxRequests: 50).toJson();
    final store = storeOver(
      storage,
      settings: const DioLensSettings(maxRequests: 300),
    );
    await store.ready;
    expect(store.settings.value.maxRequests, 50);

    for (var i = 0; i < 20; i++) {
      await store.add(request('r$i'));
    }
    await store.updateSettings(store.settings.value.copyWith(maxRequests: 10));
    expect(store.requests, hasLength(10));
    await drain();
    expect(storage.settings!['max_requests'], 10);

    await store.resetSettings();
    await drain();
    expect(store.settings.value.maxRequests, 300);
    expect(storage.settings, isNull);
  });

  test('locked redaction stays as given in code', () async {
    final storage = MemoryStorage()
      ..settings = const DioLensSettings(
        redactionMode: DioLensRedactionMode.none,
        redactedHeaders: [],
        maxRequests: 50,
      ).toJson();
    final store = storeOver(
      storage,
      settings: const DioLensSettings(
        lockRedaction: DioLensMode.all,
        redactionMode: DioLensRedactionMode.uiConsole,
        redactedHeaders: ['x-secret'],
      ),
    );
    await store.ready;
    var s = store.settings.value;
    expect(s.maxRequests, 50, reason: 'other stored settings still load');
    expect(s.redactionMode, DioLensRedactionMode.uiConsole);
    expect(s.redactedHeaders, ['x-secret']);
    expect(s.isRedactionLocked, isTrue);

    await store.updateSettings(
      s.copyWith(redactionMode: DioLensRedactionMode.none, maxRequests: 20),
    );
    s = store.settings.value;
    expect(s.redactionMode, DioLensRedactionMode.uiConsole);
    expect(s.maxRequests, 20);
  });

  test('redaction is not locked outside the chosen build modes', () async {
    final store = storeOver(MemoryStorage(), settings: const DioLensSettings());
    await store.ready;
    await store.updateSettings(
      store.settings.value.copyWith(redactionMode: DioLensRedactionMode.none),
    );
    expect(store.settings.value.redactionMode, DioLensRedactionMode.none);
    expect(store.settings.value.isRedactionLocked, isFalse);
  });
}
