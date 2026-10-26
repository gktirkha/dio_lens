import 'package:dio_lens/dio_lens.dart';
import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/core/enums/request_status_class.dart';
import 'package:dio_lens/src/core/utils/format_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormatUtils', () {
    test('duration', () {
      expect(FormatUtils.duration(null), '—');
      expect(FormatUtils.duration(const Duration(milliseconds: 96)), '96 ms');
      expect(
        FormatUtils.duration(const Duration(milliseconds: 1240)),
        '1.24 s',
      );
    });

    test('bytes', () {
      expect(FormatUtils.bytes(null), '—');
      expect(FormatUtils.bytes(512), '512 B');
      expect(FormatUtils.bytes(1843), '1.8 KB');
      expect(FormatUtils.bytes(3 * 1024 * 1024), '3.0 MB');
    });

    test('shortContentType', () {
      expect(FormatUtils.shortContentType(null), '—');
      expect(FormatUtils.shortContentType('  '), '—');
      expect(
        FormatUtils.shortContentType('application/json; charset=utf-8'),
        '.json',
      );
      expect(FormatUtils.shortContentType('application/problem+json'), '.json');
      expect(FormatUtils.shortContentType('image/jpeg'), '.jpg');
      expect(FormatUtils.shortContentType('multipart/form-data'), 'form');
      expect(FormatUtils.shortContentType('text/plain'), '.txt');
      expect(FormatUtils.shortContentType('application/vnd.api+xml'), '.xml');
      expect(
        FormatUtils.shortContentType('application/x-protobuf'),
        '.protobuf',
      );
    });

    test('relativeTime', () {
      final now = DateTime(2026, 10, 25, 12);
      expect(FormatUtils.relativeTime(now, now: now), 'Just now');
      expect(
        FormatUtils.relativeTime(
          now.subtract(const Duration(minutes: 5)),
          now: now,
        ),
        '5m ago',
      );
      expect(
        FormatUtils.relativeTime(
          now.subtract(const Duration(hours: 3)),
          now: now,
        ),
        '3h ago',
      );
    });
  });

  test('RequestStatusClass.resolve', () {
    expect(
      RequestStatusClass.resolve(RequestState.pending, null),
      RequestStatusClass.pending,
    );
    expect(
      RequestStatusClass.resolve(RequestState.failed, null),
      RequestStatusClass.error,
    );
    for (final (code, expected) in [
      (101, RequestStatusClass.informational),
      (204, RequestStatusClass.success),
      (302, RequestStatusClass.redirect),
      (404, RequestStatusClass.clientError),
      (503, RequestStatusClass.serverError),
    ]) {
      expect(
        RequestStatusClass.resolve(RequestState.completed, code),
        expected,
        reason: '$code',
      );
    }
  });

  test('DioLensMode covers every build mode combination', () {
    final combos = {
      for (final m in DioLensMode.values) (m.inDebug, m.inProfile, m.inRelease),
    };
    expect(combos.length, 8);
    expect(DioLensMode.none.inDebug, isFalse);
    expect(DioLensMode.debug.isEnabled, isTrue);
  });

  test('DioLensSizeUnit', () {
    expect(DioLensSizeUnit.kilobytes.toBytes(512), 512 * 1024);
    expect(DioLensSizeUnit.megabytes.toBytes(1.5), 1572864);
    expect(DioLensSizeUnit.kilobytes.fromBytes(2048), 2);
    expect(DioLensSizeUnit.bytes.label, 'B');
  });
}
