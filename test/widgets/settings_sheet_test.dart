import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/features/request_detail/presentation/pages/request_detail_page.dart';
import 'package:dio_lens/src/features/request_detail/presentation/widgets/key_value_box.dart';
import 'package:dio_lens/src/features/settings/presentation/pages/settings_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/entities.dart';
import '../helpers/widget_harness.dart';

Finder inSheet(String text) =>
    find.descendant(of: find.byType(SettingsSheet), matching: find.text(text));

Finder keyField(String startsWith) => find.byWidgetPredicate(
  (w) => w is TextField && (w.controller?.text.startsWith(startsWith) ?? false),
);

void main() {
  testWidgets('every control updates the settings', (tester) async {
    final h = await Harness.start(
      tester,
      size: const Size(420, 2800),
      settings: const DioLensSettings(showBubble: false, maxRequests: 300),
    );
    DioLens.open();
    await h.settle();
    await h.menu('Settings');
    expect(find.byType(SettingsSheet), findsOneWidget);
    DioLensSettings s() => DioLens.settings.value;

    await tester.tap(inSheet('Light'));
    await h.settle();
    expect(s().themeMode, ThemeMode.light);

    await tester.tap(inSheet('1000'));
    await h.settle();
    await tester.tap(find.byTooltip('Decrease max stored requests'));
    await h.settle();
    expect(s().maxRequests, 990);

    await tester.tap(inSheet('24 hours'));
    await tester.pump();
    await tester.tap(find.text('Always').last);
    await h.settle();
    expect(s().retention, DioLensRetention.always);

    await tester.tap(inSheet('MB'));
    await tester.pump();
    await tester.tap(find.text('Unlimited').last);
    await h.settle();
    expect(s().maxBodyBytes, isNull);

    await tester.tap(inSheet('Center'));
    await h.settle();
    await tester.tap(find.byTooltip('Increase notification duration'));
    await h.settle();
    expect(s().notificationPosition, DioLensNotificationPosition.center);
    expect(s().notificationDuration, const Duration(seconds: 5));

    await tester.enterText(keyField('authorization'), 'X-Trace, authorization');
    await h.settle(8);
    expect(s().redactedHeaders, ['x-trace', 'authorization']);

    FocusManager.instance.primaryFocus?.unfocus();
    await h.settle();
    await tester.tap(inSheet('Everywhere'));
    await h.settle();
    await tester.tap(find.text('UI').last);
    await h.settle();
    expect(s().redactionMode, DioLensRedactionMode.ui);
    expect(h.storage.settings!['redaction_mode'], 'ui');
  });

  testWidgets('reset asks first, then restores the starting values', (
    tester,
  ) async {
    final h = await Harness.start(
      tester,
      size: const Size(420, 2800),
      settings: const DioLensSettings(showBubble: false, maxRequests: 300),
    );
    DioLens.open();
    await h.settle();
    await h.menu('Settings');
    await tester.tap(inSheet('1000'));
    await h.settle();

    await tester.tap(inSheet('Reset').last);
    await h.settle();
    await tester.tap(find.text('Cancel'));
    await h.settle();
    expect(DioLens.settings.value.maxRequests, 1000);

    await tester.tap(inSheet('Reset').last);
    await h.settle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Reset'),
      ),
    );
    await h.settle(6);
    expect(
      DioLens.settings.value,
      const DioLensSettings(showBubble: false, maxRequests: 300),
    );
    expect(h.storage.settings, isNull);
  });

  testWidgets('detail tabs mask what the settings say', (tester) async {
    final h = await Harness.start(
      tester,
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
        redactedHeaders: ['x-trace'],
        redactedQueryParams: [],
      ),
    );
    await h.send(
      (dio) => dio.get(
        '/v1/a?token=abc',
        options: Options(headers: {'X-Trace': 't', 'Accept': 'json'}),
      ),
    );
    DioLens.openRequest(h.runtime.store.requests.single.id);
    await h.settle();
    await tester.tap(find.text('Request'));
    await h.settle();
    final masked = {
      for (final box in tester.widgetList<KeyValueBox>(
        find.byType(KeyValueBox),
      ))
        for (final e in box.entries) e.key: e.redacted,
    };
    expect(masked['X-Trace'], isTrue);
    expect(masked['Accept'], isFalse);
    expect(masked['token'], isFalse);
  });

  testWidgets("replay explains when a request can't be re-sent", (
    tester,
  ) async {
    final h = await Harness.start(
      tester,
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
      ),
    );
    final old = request('old', method: 'POST').copyWith(hasFileUpload: true);
    await tester.runAsync(() => h.runtime.store.add(old));
    DioLens.openRequest('old');
    await h.settle();
    expect(find.byType(RequestDetailPage), findsOneWidget);
    await tester.tap(find.text('Replay'));
    await tester.pump();
    expect(
      find.text("Can't replay: the file upload wasn't captured"),
      findsOneWidget,
    );
    expect(h.adapter.requests, isEmpty);
  });

  testWidgets('Overview and cURL follow the cURL target', (tester) async {
    final h = await Harness.start(
      tester,
      size: const Size(420, 2600),
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
        redactionMode: DioLensRedactionMode.clipboard,
      ),
    );
    await h.send(
      (dio) => dio.get(
        '/v1/a?token=abc',
        options: Options(headers: {'Authorization': 'Bearer secret'}),
      ),
    );
    DioLens.openRequest(h.runtime.store.requests.single.id);
    await h.settle();

    expect(
      find.text('https://api.example.com/v1/a?token=[REDACTED]'),
      findsOneWidget,
    );
    expect(find.textContaining('Bearer secret'), findsNothing);
    expect(
      find.textContaining("-H 'Authorization: [REDACTED]'"),
      findsOneWidget,
    );

    await tester.tap(find.text('Request'));
    await h.settle();
    final masked = {
      for (final box in tester.widgetList<KeyValueBox>(
        find.byType(KeyValueBox),
      ))
        for (final e in box.entries) e.key: e.redacted,
    };
    expect(masked['Authorization'], isFalse, reason: 'UI is not masked');
  });

  testWidgets('list rows follow the UI target live', (tester) async {
    final h = await Harness.start(
      tester,
      settings: const DioLensSettings(
        showBubble: false,
        showNotification: false,
      ),
    );
    await h.send((dio) => dio.get('/v1/a?token=abc&page=2'));
    DioLens.open();
    await h.settle();
    expect(
      find.text('/v1/a?token=[REDACTED]&page=2', findRichText: true),
      findsOneWidget,
    );
    await tester.runAsync(
      () => DioLens.updateSettings(
        DioLens.settings.value.copyWith(
          redactionMode: DioLensRedactionMode.off,
        ),
      ),
    );
    await h.settle();
    expect(
      find.text('/v1/a?token=abc&page=2', findRichText: true),
      findsOneWidget,
    );
  });
}
