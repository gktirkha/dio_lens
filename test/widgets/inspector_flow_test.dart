import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/features/bubble/presentation/widgets/dio_lens_bubble.dart';
import 'package:dio_lens/src/features/home/presentation/pages/dio_lens_home_page.dart';
import 'package:dio_lens/src/features/notification/presentation/widgets/request_finished_banner.dart';
import 'package:dio_lens/src/features/request_detail/presentation/pages/request_detail_page.dart';
import 'package:dio_lens/src/features/request_detail/presentation/widgets/json_tree_view.dart';
import 'package:dio_lens/src/features/request_home/presentation/widgets/request_list_tile.dart';
import 'package:dio_lens/src/features/stats/presentation/pages/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/entities.dart';
import '../helpers/fake_adapter.dart';
import '../helpers/widget_harness.dart';

void main() {
  testWidgets('home lists requests, opens details, builds Stats lazily', (
    tester,
  ) async {
    final h = await Harness.start(
      tester,
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
      ),
      adapter: FakeAdapter((_) async => FakeAdapter.json({'answer': 42})),
    );
    await h.send((dio) => dio.post('/v1/orders', data: {'item': 1}));

    DioLens.open();
    await h.settle();
    expect(find.byType(DioLensHomePage), findsOneWidget);
    expect(find.byType(StatsPage), findsNothing);

    await tester.tap(
      find.textContaining('/v1/orders', findRichText: true).first,
    );
    await h.settle();
    await tester.tap(find.text('Response'));
    await h.settle();
    expect(find.byType(JsonTreeView), findsOneWidget);
    expect(find.textContaining('42', findRichText: true), findsWidgets);

    await tester.tap(find.byTooltip('Back to request list'));
    await h.settle();
    await tester.tap(find.text('Stats'));
    await h.settle();
    expect(find.byType(StatsPage), findsOneWidget);
  });

  testWidgets('banner positions and View → detail → home', (tester) async {
    final h = await Harness.start(tester);
    final tops = <DioLensNotificationPosition, double>{};
    for (final position in DioLensNotificationPosition.values) {
      await tester.runAsync(
        () => DioLens.updateSettings(
          DioLens.settings.value.copyWith(notificationPosition: position),
        ),
      );
      await h.send((dio) => dio.get('/v1/${position.name}'));
      tops[position] = tester.getTopLeft(find.byType(RequestFinishedBanner)).dy;
    }
    expect(
      tops[DioLensNotificationPosition.top]!,
      lessThan(tops[DioLensNotificationPosition.center]!),
    );
    expect(
      tops[DioLensNotificationPosition.center]!,
      lessThan(tops[DioLensNotificationPosition.bottom]!),
    );

    await tester.tap(find.text('View'));
    await h.settle();
    expect(find.byType(RequestDetailPage), findsOneWidget);
    await tester.tap(find.byTooltip('Open Dio Lens home'));
    await h.settle();
    expect(find.byType(DioLensHomePage), findsOneWidget);
    expect(find.byType(RequestDetailPage, skipOffstage: false), findsNothing);
  });

  testWidgets(
    'bubble drags, snaps to the nearer edge and hides inside Dio Lens',
    (tester) async {
      final h = await Harness.start(
        tester,
        settings: const DioLensSettings(showNotification: false),
        size: const Size(400, 800),
      );
      final bubble = find.byType(DioLensBubble);
      expect(tester.getTopLeft(bubble).dx, 328);

      await tester.drag(bubble, const Offset(-200, -300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.getTopLeft(bubble).dx, 128);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.getTopLeft(bubble).dx, 16);

      await tester.tap(bubble);
      await h.settle();
      expect(find.byType(DioLensHomePage), findsOneWidget);
      expect(find.byType(DioLensBubble), findsNothing);
    },
  );

  testWidgets('export and share reach the app; without callbacks', (
    tester,
  ) async {
    final exported = <DioLensExportFile>[];
    final shared = <DioLensShareContent>[];
    final h = await Harness.start(
      tester,
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
      ),
      onExport: exported.add,
      onShare: shared.add,
    );
    await h.send(
      (dio) => dio.get(
        '/v1/orders',
        options: Options(headers: {'Authorization': 'Bearer secret'}),
      ),
    );
    DioLens.open();
    await h.settle();
    await h.menu('Export as HAR');
    expect(exported.single.format, DioLensExportFormat.har);
    expect(exported.single.text, isNot(contains('Bearer secret')));
    expect(find.text('Exported 1 request as HAR'), findsOneWidget);

    await tester.tap(
      find.textContaining('/v1/orders', findRichText: true).first,
    );
    await h.settle();
    await tester.tap(find.text('Share'));
    await h.settle();
    expect(shared.single.subject, 'GET /v1/orders · 200');
  });

  testWidgets('share copies to the clipboard without a callback', (
    tester,
  ) async {
    String? clipboard;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    final h = await Harness.start(
      tester,
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
      ),
    );
    await h.send((dio) => dio.get('/v1/orders'));
    DioLens.openRequest(h.runtime.store.requests.single.id);
    await h.settle();
    await tester.tap(find.text('Share'));
    await h.settle();
    expect(find.text('Request copied'), findsOneWidget);
    expect(clipboard, contains('=============== Overview ==============='));
  });

  testWidgets('export is disabled without a callback', (tester) async {
    final h = await Harness.start(tester);
    DioLens.open();
    await h.settle();
    await tester.tap(find.byTooltip('More options').first);
    await tester.pump();
    final item = find.ancestor(
      of: find.text('Export as HAR'),
      matching: find.byType(MenuItemButton),
    );
    expect(tester.widget<MenuItemButton>(item).onPressed, isNull);
  });

  testWidgets('rows share and replay; Replay hidden when it cannot replay', (
    tester,
  ) async {
    final shared = <DioLensShareContent>[];
    final h = await Harness.start(
      tester,
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
      ),
      onShare: shared.add,
    );
    await h.send((dio) => dio.get('/v1/orders'));
    await tester.runAsync(
      () => h.runtime.store.add(
        request(
          'old',
          method: 'POST',
          url: 'https://api.example.com/v1/upload',
        ).copyWith(hasFileUpload: true),
      ),
    );
    DioLens.open();
    await h.settle();

    Finder row(String path) => find.ancestor(
      of: find.textContaining(path, findRichText: true),
      matching: find.byType(RequestListTile),
    );

    Finder action(String path, String tooltip) =>
        find.descendant(of: row(path), matching: find.byTooltip(tooltip));

    await tester.tap(action('/v1/orders', 'Share request'));
    await h.settle();
    expect(shared.single.subject, 'GET /v1/orders · 200');

    String? clipboard;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    await tester.tap(action('/v1/orders', 'Copy cURL'));
    await h.settle();
    expect(
      clipboard,
      startsWith("curl -X GET 'https://api.example.com/v1/orders'"),
    );
    expect(find.text('cURL copied'), findsOneWidget);

    await tester.tap(action('/v1/orders', 'Replay request'));
    await h.settle();
    expect(find.text('Request replayed'), findsOneWidget);
    expect(
      h.adapter.requests.where((o) => o.path == '/v1/orders'),
      hasLength(2),
    );

    expect(action('/v1/upload', 'Share request'), findsOneWidget);
    expect(action('/v1/upload', 'Replay request'), findsNothing);
  });

  testWidgets('empty Stats is centered horizontally', (tester) async {
    await Harness.start(tester, size: const Size(1200, 900));
    DioLens.open();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();

    final screenCenter = tester.view.physicalSize.width / 2;
    for (final finder in [
      find.text('No stats yet'),
      // The empty state's icon, not the Stats tab's.
      find.byWidgetPredicate(
        (w) => w is Icon && w.icon == Icons.bar_chart_rounded && w.size == 40,
      ),
    ]) {
      expect(tester.getCenter(finder).dx, moreOrLessEquals(screenCenter));
    }
  });
}
