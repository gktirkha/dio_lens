import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/features/request_detail/presentation/pages/request_detail_page.dart';
import 'package:dio_lens/src/features/settings/presentation/pages/settings_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/widget_harness.dart';

void main() {
  Future<Harness> start(WidgetTester tester, DioLensSettings settings) async {
    final h = await Harness.start(tester, settings: settings);
    await h.send((dio) => dio.get('/v1/orders'));
    await h.send((dio) => dio.get('/v1/users'));
    DioLens.open();
    await h.settle();
    return h;
  }

  List<String> paths(Harness h) =>
      h.runtime.store.requests.map((r) => r.path).toList();

  const quiet = DioLensSettings(showBubble: false, showNotification: false);

  group('single', () {
    final asks = quiet.copyWith(
      deleteConfirmation: {DioLensDeleteConfirmation.single},
    );

    testWidgets('a row asks first; Cancel keeps the request', (tester) async {
      final h = await start(tester, asks);
      await tester.tap(find.byTooltip('Delete request').last);
      await h.settle();
      expect(find.text('Delete request?'), findsOneWidget);
      expect(
        find.text('Delete GET /v1/orders? This cannot be undone.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Cancel'));
      await h.settle();
      expect(paths(h), unorderedEquals(['/v1/orders', '/v1/users']));

      await tester.tap(find.byTooltip('Delete request').last);
      await h.settle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await h.settle();
      expect(paths(h), ['/v1/users']);
    });

    testWidgets('the detail page asks, then deletes and goes back', (
      tester,
    ) async {
      final h = await start(tester, asks);
      await tester.tap(find.textContaining('/v1/orders', findRichText: true));
      await h.settle();
      await tester.tap(find.byTooltip('Delete request'));
      await h.settle();
      expect(find.byType(RequestDetailPage), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await h.settle();
      expect(find.byType(RequestDetailPage), findsNothing);
      expect(paths(h), ['/v1/users']);
    });

    testWidgets('off: deletes at once', (tester) async {
      final h = await start(tester, quiet.copyWith(deleteConfirmation: {}));
      await tester.tap(find.byTooltip('Delete request').last);
      await h.settle();
      expect(find.byType(Dialog), findsNothing);
      expect(paths(h), ['/v1/users']);
    });
  });

  group('all', () {
    testWidgets('asks by default, from Requests and Stats', (tester) async {
      final h = await start(tester, quiet);
      await h.menu('Clear all requests');
      expect(find.text('Clear all requests?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await h.settle();

      await tester.tap(find.text('Stats'));
      await h.settle();
      await h.menu('Clear all requests');
      expect(find.text('Clear all requests?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Clear all'));
      await h.settle();
      expect(paths(h), isEmpty);
    });

    testWidgets('off: clears at once, from Stats too', (tester) async {
      final h = await start(tester, quiet.copyWith(deleteConfirmation: {}));
      await tester.tap(find.text('Stats'));
      await h.settle();
      await h.menu('Clear all requests');
      expect(find.byType(Dialog), findsNothing);
      expect(paths(h), isEmpty);
    });
  });

  group('allowDelete', () {
    final locked = quiet.copyWith(allowDelete: DioLensMode.disabled);

    testWidgets('disabled hides every delete', (tester) async {
      final h = await start(tester, locked);
      expect(find.byTooltip('Delete request'), findsNothing, reason: 'rows');
      await tester.tap(find.byTooltip('More options').first);
      await tester.pump();
      expect(find.text('Clear all requests'), findsNothing);
      await tester.tapAt(Offset.zero);
      await h.settle();

      await tester.tap(find.text('Stats'));
      await h.settle();
      await tester.tap(find.byTooltip('More options').first);
      await tester.pump();
      expect(find.text('Clear all requests'), findsNothing, reason: 'Stats');
      await tester.tapAt(Offset.zero);
      await h.settle();

      DioLens.openRequest(h.runtime.store.requests.first.id);
      await h.settle();
      expect(find.byTooltip('Delete request'), findsNothing, reason: 'detail');
    });

    testWidgets('the settings sheet hides Ask before deleting', (tester) async {
      final h = await start(tester, locked);
      await h.menu('Settings');
      expect(find.byType(SettingsSheet), findsOneWidget);
      expect(find.text('Ask before deleting'), findsNothing);
    });

    testWidgets('updateSettings cannot allow it again', (tester) async {
      final h = await start(tester, locked);
      await DioLens.updateSettings(
        DioLens.settings.value.copyWith(allowDelete: DioLensMode.enabled),
      );
      await h.settle();
      expect(DioLens.settings.value.isDeleteAllowed, isFalse);
      expect(find.byTooltip('Delete request'), findsNothing);
    });
  });
}
