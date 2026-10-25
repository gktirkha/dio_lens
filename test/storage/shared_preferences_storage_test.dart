import 'dart:convert';

import 'package:dio_lens/src/core/storage/shared_preferences_dio_lens_storage.dart';
import 'package:dio_lens/src/features/request_home/data/mappers/request_list_item_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../helpers/entities.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  Future<void> write(
    SharedPreferencesDioLensStorage s,
    String id, {
    Duration ago = Duration.zero,
  }) {
    final r = request(id, ago: ago, responseBody: {'id': id});
    return s.writeRequest(
      id,
      request: r.toJson(),
      summary: r.toListItem().toJson(),
    );
  }

  test('stores a summary and a full record per request', () async {
    final storage = SharedPreferencesDioLensStorage();
    await write(storage, 'a');
    final prefs = SharedPreferencesAsync();
    final summary =
        jsonDecode((await prefs.getString('dio_lens.summary.a'))!) as Map;
    final full =
        jsonDecode((await prefs.getString('dio_lens.request.a'))!) as Map;
    expect(summary.containsKey('response_body'), isFalse);
    expect(full['response_body'], {'id': 'a'});
  });

  test(
    'reads summaries, one request and all requests, parsed in isolates',
    () async {
      final storage = SharedPreferencesDioLensStorage();
      await write(storage, 'old', ago: const Duration(minutes: 5));
      await write(storage, 'new');
      final fresh = SharedPreferencesDioLensStorage();

      final summaries = await fresh.readParsedSummaries();
      expect(summaries.summaries.map((s) => s.id), ['new', 'old']);
      expect(summaries.corrupt, isEmpty);
      expect((await fresh.readParsedRequest('old'))!.responseBody, {
        'id': 'old',
      });
      expect(await fresh.readParsedRequest('missing'), isNull);
      expect(await fresh.readParsedRequests(), hasLength(2));
      expect(await fresh.readSummaries(), hasLength(2));
    },
  );

  test('records stored before summaries existed still load', () async {
    final prefs = SharedPreferencesAsync();
    final legacy = request('legacy');
    await prefs.setString(
      'dio_lens.request.legacy',
      jsonEncode(legacy.toJson()),
    );
    await prefs.setStringList('dio_lens.request_ids', ['legacy']);
    final summaries = await SharedPreferencesDioLensStorage()
        .readParsedSummaries();
    expect(summaries.summaries.single.id, 'legacy');
  });

  test('delete and clear remove both entries; settings are separate', () async {
    final storage = SharedPreferencesDioLensStorage();
    await write(storage, 'a');
    await write(storage, 'b');
    await storage.writeSettings({'max_requests': 100});
    await storage.deleteRequests(['a', 'unknown']);
    final prefs = SharedPreferencesAsync();
    expect(await prefs.getString('dio_lens.summary.a'), isNull);
    expect(await prefs.getString('dio_lens.request.a'), isNull);
    expect((await storage.readSummaries()).single['id'], 'b');

    await storage.clearRequests();
    expect(await SharedPreferencesDioLensStorage().readSummaries(), isEmpty);
    expect(await storage.readSettings(), {'max_requests': 100});
    await storage.clearSettings();
    expect(await storage.readSettings(), isNull);
  });

  test('a custom key prefix keeps entries apart', () async {
    final a = SharedPreferencesDioLensStorage(keyPrefix: 'one');
    final b = SharedPreferencesDioLensStorage(keyPrefix: 'two');
    await write(a, 'x');
    expect(await b.readSummaries(), isEmpty);
    expect(await a.readSummaries(), hasLength(1));
  });
}
