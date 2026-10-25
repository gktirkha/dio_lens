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
}
