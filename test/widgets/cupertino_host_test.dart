import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/utils/host_app.dart';
import 'package:dio_lens/src/features/home/presentation/pages/dio_lens_home_page.dart';
import 'package:dio_lens/src/features/request_detail/presentation/pages/request_detail_page.dart';
import 'package:dio_lens/src/features/settings/presentation/pages/settings_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/widget_harness.dart';

void main() {
  testWidgets('DioLensHostApp tells Material, Cupertino and other apps apart', (
    tester,
  ) async {
    late DioLensHostApp kind;
    final probe = Builder(
      builder: (context) {
        kind = DioLensHostApp.of(context);
        return const SizedBox();
      },
    );
    await tester.pumpWidget(MaterialApp(home: probe));
    expect(kind, DioLensHostApp.material);
    await tester.pumpWidget(CupertinoApp(home: probe));
    expect(kind, DioLensHostApp.cupertino);
    await tester.pumpWidget(
      WidgetsApp(color: const Color(0xFF000000), builder: (_, _) => probe),
    );
    expect(kind, DioLensHostApp.other);
  });

  testWidgets('works inside a CupertinoApp', (tester) async {
    final h = await Harness.start(tester, cupertino: true);
    await h.send((dio) => dio.get('/v1/orders?page=2'));
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

    DioLens.open();
    await h.settle();
    expect(find.byType(DioLensHomePage), findsOneWidget);

    // Row buttons copy and show a snackbar.
    await tester.tap(find.byTooltip('Copy cURL').first);
    await h.settle();
    expect(clipboard, startsWith('curl -X GET'));
    expect(find.text('cURL copied'), findsOneWidget);

    await tester.tap(
      find.textContaining('/v1/orders', findRichText: true).first,
    );
    await h.settle();
    expect(find.byType(RequestDetailPage), findsOneWidget);
    await tester.tap(find.byTooltip('Back to request list'));
    await h.settle();

    await h.menu('Clear all requests');
    expect(find.text('Clear all requests?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await h.settle();

    await h.menu('Settings');
    expect(find.byType(SettingsSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
