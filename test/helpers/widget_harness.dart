import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/runtime/dio_lens_runtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_adapter.dart';
import 'memory_storage.dart';

/// A host app with Dio Lens set up over [MemoryStorage] and a fake network.
class Harness {
  Harness._(
    this.tester,
    this.navigatorKey,
    this.storage,
    this.dio,
    this.adapter,
  );

  /// Pumps a host app and calls `DioLens.init`.
  static Future<Harness> start(
    WidgetTester tester, {
    DioLensSettings settings = const DioLensSettings(showBubble: false),
    DioLensExportCallback? onExport,
    DioLensShareCallback? onShare,
    FakeAdapter? adapter,
    Size size = const Size(420, 900),
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() => DioLensRuntime.current = null);
    final key = GlobalKey<NavigatorState>();
    final storage = MemoryStorage();
    DioLens.init(
      navigatorKey: key,
      storage: storage,
      mode: DioLensMode.show,
      settings: settings,
      onExport: onExport,
      onShare: onShare,
    );
    final fake = adapter ?? FakeAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'))
      ..httpClientAdapter = fake;
    dio.interceptors.add(DioLensInterceptor(dio: dio));
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: const Scaffold(body: Text('host')),
      ),
    );
    final harness = Harness._(tester, key, storage, dio, fake);
    await harness.settle();
    return harness;
  }

  final WidgetTester tester;
  final GlobalKey<NavigatorState> navigatorKey;
  final MemoryStorage storage;
  final Dio dio;
  final FakeAdapter adapter;

  DioLensRuntime get runtime => DioLensRuntime.current!;

  /// Lets real async work (isolates, storage) and animations finish.
  Future<void> settle([int rounds = 4]) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)),
      );
      await tester.pump(const Duration(milliseconds: 150));
    }
    await tester.pump(const Duration(milliseconds: 500));
  }

  /// Makes a request through the app's Dio, ignoring errors.
  Future<void> send(Future<Response<dynamic>> Function(Dio dio) call) async {
    await tester.runAsync(() => call(dio).then<void>((_) {}, onError: (_) {}));
    await settle();
  }

  /// Opens the overflow menu of the visible Dio Lens page and taps [item].
  Future<void> menu(String item) async {
    await tester.tap(find.byTooltip('More options').first);
    await tester.pump();
    await tester.tap(find.text(item));
    await settle();
  }
}
