import 'dart:io';

import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/storage/dio_lens_store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/entities.dart';
import 'file_storage_example.dart';

void main() {
  test('README file storage works with Dio Lens', () async {
    final dir = Directory.systemTemp.createTempSync('dio_lens_readme');
    addTearDown(() => dir.deleteSync(recursive: true));
    const settings = DioLensSettings(retention: DioLensRetention.always);

    final store = DioLensStore(
      storage: () => FileDioLensStorage(dir),
      initialSettings: settings,
    );
    await store.add(request('a', responseBody: {'n': 1}));
    await store.add(request('b'));
    await store.updateSettings(settings.copyWith(maxRequests: 100));
    await store.delete('b');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final fresh = DioLensStore(
      storage: () => FileDioLensStorage(dir),
      initialSettings: settings,
    );
    await fresh.ready;
    expect(fresh.requests.map((r) => r.id), ['a']);
    expect((await fresh.getRequest('a'))!.responseBody, {'n': 1});
    expect(await fresh.getAllRequests(), hasLength(1));
    expect(fresh.settings.value.maxRequests, 100);

    await fresh.clear();
    await fresh.resetSettings();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(await FileDioLensStorage(dir).readSummaries(), isEmpty);
    expect(await FileDioLensStorage(dir).readSettings(), isNull);
  });
}
