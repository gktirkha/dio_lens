import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/features/request_home/domain/entities/request_list_item_entity.dart';
import 'package:dio_lens/src/features/request_home/presentation/widgets/request_list_tile.dart';
import 'package:dio_lens/src/theme/dio_lens_theme_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

RequestListItemEntity item(RequestState state, String? req, String? res) =>
    RequestListItemEntity(
      id: 'x',
      method: 'GET',
      uri: Uri.parse('https://a.b/c'),
      startedAt: DateTime.now(),
      state: state,
      statusCode: state == RequestState.completed ? 200 : null,
      duration: state == RequestState.pending
          ? null
          : const Duration(milliseconds: 96),
      responseSize: state == RequestState.completed ? 0 : null,
      requestContentType: req,
      responseContentType: res,
    );

void main() {
  const json = 'application/json';
  for (final (name, value, expected) in [
    ('no bodies', item(RequestState.completed, null, null), '96 ms  ·  0 B'),
    (
      'pending with body',
      item(RequestState.pending, json, null),
      'Waiting…  ·  .json → …',
    ),
    (
      'pending without body',
      item(RequestState.pending, null, null),
      'Waiting…',
    ),
    (
      'response only',
      item(RequestState.completed, null, json),
      '96 ms  ·  0 B  ·  — → .json',
    ),
    (
      'both',
      item(RequestState.completed, json, json),
      '96 ms  ·  0 B  ·  .json → .json',
    ),
  ]) {
    testWidgets('meta line: $name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DioLensThemeScope(
            child: Material(child: RequestListTile(item: value)),
          ),
        ),
      );
      expect(find.text(expected, findRichText: true), findsOneWidget);
    });
  }

  group('row actions', () {
    Future<void> pumpTile(
      WidgetTester tester, {
      VoidCallback? onTap,
      VoidCallback? onShare,
      VoidCallback? onCopyCurl,
      VoidCallback? onReplay,
      VoidCallback? onDelete,
    }) => tester.pumpWidget(
      MaterialApp(
        home: DioLensThemeScope(
          child: Material(
            child: RequestListTile(
              item: item(RequestState.completed, null, null),
              onTap: onTap,
              onShare: onShare,
              onCopyCurl: onCopyCurl,
              onReplay: onReplay,
              onDelete: onDelete,
            ),
          ),
        ),
      ),
    );

    testWidgets('share, cURL and replay buttons call back, not the row tap', (
      tester,
    ) async {
      var shared = 0, curls = 0, replayed = 0, opened = 0;
      await pumpTile(
        tester,
        onTap: () => opened++,
        onShare: () => shared++,
        onCopyCurl: () => curls++,
        onReplay: () => replayed++,
      );
      await tester.tap(find.byTooltip('Share request'));
      await tester.tap(find.byTooltip('Copy cURL'));
      await tester.tap(find.byTooltip('Replay request'));
      expect((shared, curls, replayed, opened), (1, 1, 1, 0));
    });

    testWidgets('hides buttons without a callback', (tester) async {
      await pumpTile(tester, onShare: () {});
      expect(find.byTooltip('Share request'), findsOneWidget);
      expect(find.byTooltip('Replay request'), findsNothing);
      await pumpTile(tester);
      expect(find.byTooltip('Share request'), findsNothing);
    });

    testWidgets('swipe still deletes', (tester) async {
      var deleted = 0;
      await pumpTile(tester, onDelete: () => deleted++);
      await tester.drag(find.byType(RequestListTile), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(deleted, 1);
    });
  });

  group('query masking', () {
    final withQuery = RequestListItemEntity(
      id: 'q',
      method: 'GET',
      uri: Uri.parse('https://a.b/v1/a?token=abc&page=2'),
      startedAt: DateTime.now(),
      state: RequestState.completed,
      statusCode: 200,
    );

    Future<void> pump(WidgetTester tester, DioLensSettings settings) =>
        tester.pumpWidget(
          MaterialApp(
            home: DioLensThemeScope(
              child: Material(
                child: RequestListTile(item: withQuery, settings: settings),
              ),
            ),
          ),
        );

    testWidgets('masks redacted query values for the UI target', (
      tester,
    ) async {
      await pump(tester, const DioLensSettings());
      expect(
        find.text('/v1/a?token=[REDACTED]&page=2', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('shows them when the UI is not masked', (tester) async {
      await pump(
        tester,
        const DioLensSettings(redactionMode: DioLensRedactionMode.console),
      );
      expect(
        find.text('/v1/a?token=abc&page=2', findRichText: true),
        findsOneWidget,
      );
    });
  });
}
