import 'dart:convert';

import 'package:dio_lens/dio_lens.dart';
import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults', () {
    const s = DioLensSettings();
    expect(s.maxRequests, 500);
    expect(s.maxBodyBytes, 1024 * 1024);
    expect(s.retention, DioLensRetention.oneDay);
    expect(s.showNotification, isTrue);
    expect(s.notificationPosition, DioLensNotificationPosition.top);
    expect(s.notificationDuration, const Duration(seconds: 4));
    expect(s.showBubble, isTrue);
    expect(s.bubblePosition, DioLensBubblePosition.bottomEnd);
    expect(s.redactionTargets, DioLensSettings.allRedactionTargets);
    expect(s.themeMode, ThemeMode.dark);
    expect(s.deleteConfirmation, {DioLensDeleteConfirmation.all});
    expect(s.isDeleteAllowed, isTrue);
  });

  test('JSON round trip keeps every value', () {
    const s = DioLensSettings(
      maxRequests: 200,
      maxBodyBytes: 4096,
      retention: DioLensRetention.always,
      notificationPosition: DioLensNotificationPosition.center,
      bubblePosition: DioLensBubblePosition.topStart,
      redactedHeaders: ['x-trace'],
      themeMode: ThemeMode.system,
    );
    final back = DioLensSettings.fromJson(
      jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>,
    );
    expect(back, s);
  });

  test(
    'missing body size uses the default; stored unlimited stays unlimited',
    () {
      expect(DioLensSettings.fromJson(const {}).maxBodyBytes, 1024 * 1024);
      final unlimited = const DioLensSettings().copyWith(maxBodyBytes: null);
      final back = DioLensSettings.fromJson(
        jsonDecode(jsonEncode(unlimited.toJson())) as Map<String, dynamic>,
      );
      expect(back.maxBodyBytes, isNull);
    },
  );

  test('redaction matches case-insensitively and respects the toggles', () {
    const s = DioLensSettings(
      redactedHeaders: ['X-Api-Key'],
      redactedQueryParams: ['ApiKey'],
    );
    expect(s.isHeaderRedacted('x-api-key'), isTrue);
    expect(s.isHeaderRedacted('X-API-KEY'), isTrue);
    expect(s.isHeaderRedacted('Accept'), isFalse);
    expect(s.isQueryParamRedacted('APIKEY'), isTrue);
    expect(
      s.copyWith(redactionTargets: const {}).isHeaderRedacted('x-api-key'),
      isFalse,
    );
    expect(
      s.copyWith(redactionTargets: const {}).isQueryParamRedacted('apikey'),
      isFalse,
    );
  });

  test('default redaction lists', () {
    const s = DioLensSettings();
    for (final h in ['Authorization', 'Cookie', 'Set-Cookie', 'X-Api-Key']) {
      expect(s.isHeaderRedacted(h), isTrue, reason: h);
    }
    for (final q in ['token', 'apikey', 'password']) {
      expect(s.isQueryParamRedacted(q), isTrue, reason: q);
    }
  });

  test('redaction masks exactly the chosen targets', () {
    const targets = DioLensRedactionTarget.values;
    // Every subset of the targets.
    for (var mask = 0; mask < 1 << targets.length; mask++) {
      final chosen = {
        for (var i = 0; i < targets.length; i++)
          if (mask & (1 << i) != 0) targets[i],
      };
      final s = DioLensSettings(redactionTargets: chosen);
      for (final target in targets) {
        final masked = chosen.contains(target);
        expect(
          s.isHeaderRedacted('Authorization', target: target),
          masked,
          reason: '$chosen $target',
        );
        expect(s.isQueryParamRedacted('token', target: target), masked);
      }
      expect(
        s.isHeaderRedacted('Authorization'),
        chosen.contains(DioLensRedactionTarget.ui),
      );
    }
  });

  test('redaction targets round-trip through JSON', () {
    const s = DioLensSettings(
      redactionTargets: {
        DioLensRedactionTarget.ui,
        DioLensRedactionTarget.external,
      },
    );
    expect(s.toJson()['redaction_targets'], ['ui', 'external']);
    expect(DioLensSettings.fromJson(s.toJson()).redactionTargets, {
      DioLensRedactionTarget.ui,
      DioLensRedactionTarget.external,
    });
  });

  test('settings stored before 2.0.0 keep their redaction', () {
    Set<DioLensRedactionTarget> from(String mode) =>
        DioLensSettings.fromJson({'redaction_mode': mode}).redactionTargets;
    expect(from('all'), DioLensSettings.allRedactionTargets);
    expect(from('none'), isEmpty);
    expect(from('ui_clipboard'), {
      DioLensRedactionTarget.ui,
      DioLensRedactionTarget.clipboard,
    });
    expect(from('console_external'), {
      DioLensRedactionTarget.console,
      DioLensRedactionTarget.external,
    });
    expect(
      DioLensSettings.fromJson(const {}).redactionTargets,
      DioLensSettings.allRedactionTargets,
      reason: 'nothing stored: the default',
    );
  });

  test('the redaction lock is code only and never stored', () {
    const s = DioLensSettings(lockRedaction: DioLensMode.enabled);
    expect(s.toJson().keys.any((k) => k.contains('lock')), isFalse);
    expect(
      DioLensSettings.fromJson(s.toJson()).lockRedaction,
      DioLensMode.disabled,
    );
    expect(const DioLensSettings().isRedactionLocked, isFalse);
  });

  test('delete confirmation round-trips through JSON', () {
    const s = DioLensSettings(
      deleteConfirmation: {DioLensDeleteConfirmation.single},
    );
    expect(s.toJson()['delete_confirmation'], ['single']);
    final back = DioLensSettings.fromJson(s.toJson());
    expect(back.confirmsDelete(DioLensDeleteConfirmation.single), isTrue);
    expect(back.confirmsDelete(DioLensDeleteConfirmation.all), isFalse);
    expect(
      DioLensSettings.fromJson(const {}).deleteConfirmation,
      DioLensSettings.defaultDeleteConfirmation,
      reason: 'nothing stored: the default',
    );
  });

  test('allowDelete is code only and never stored', () {
    const s = DioLensSettings(allowDelete: DioLensMode.disabled);
    expect(s.isDeleteAllowed, isFalse);
    expect(s.toJson().keys.any((k) => k.contains('allow')), isFalse);
    expect(
      DioLensSettings.fromJson(s.toJson()).allowDelete,
      DioLensMode.enabled,
    );
  });
}
