import 'dart:convert';

import 'package:dio_lens/dio_lens.dart';
import 'package:flutter/material.dart' show ThemeMode;
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
    expect(s.redactionMode, DioLensRedactionMode.redact);
    expect(s.themeMode, ThemeMode.dark);
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
      s
          .copyWith(redactionMode: DioLensRedactionMode.off)
          .isHeaderRedacted('x-api-key'),
      isFalse,
    );
    expect(
      s
          .copyWith(redactionMode: DioLensRedactionMode.off)
          .isQueryParamRedacted('apikey'),
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

  test('redaction mode masks every combination of targets', () {
    const ui = DioLensRedactionTarget.ui;
    const curl = DioLensRedactionTarget.clipboard;
    const console = DioLensRedactionTarget.console;
    final expected = {
      DioLensRedactionMode.redact: {ui, curl, console},
      DioLensRedactionMode.uiClipboardConsole: {ui, curl, console},
      DioLensRedactionMode.ui: {ui},
      DioLensRedactionMode.clipboard: {curl},
      DioLensRedactionMode.console: {console},
      DioLensRedactionMode.uiClipboard: {ui, curl},
      DioLensRedactionMode.uiConsole: {ui, console},
      DioLensRedactionMode.clipboardConsole: {curl, console},
      DioLensRedactionMode.off: <DioLensRedactionTarget>{},
    };
    expect(expected.keys, containsAll(DioLensRedactionMode.values));
    for (final MapEntry(key: mode, value: targets) in expected.entries) {
      final s = DioLensSettings(redactionMode: mode);
      for (final target in DioLensRedactionTarget.values) {
        final masked = targets.contains(target);
        expect(
          s.isHeaderRedacted('Authorization', target: target),
          masked,
          reason: '$mode $target',
        );
        expect(s.isQueryParamRedacted('token', target: target), masked);
      }
      expect(s.isHeaderRedacted('Authorization'), targets.contains(ui));
    }
  });
}
