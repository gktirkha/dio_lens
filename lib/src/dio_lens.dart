import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'core/enums/dio_lens_mode.dart';
import 'core/enums/export_format.dart';
import 'core/runtime/dio_lens_runtime.dart';
import 'core/storage/dio_lens_storage.dart';
import 'core/storage/shared_preferences_dio_lens_storage.dart';
import 'features/export/domain/entities/dio_lens_export_file.dart';
import 'features/settings/domain/entities/dio_lens_settings.dart';
import 'features/share/domain/entities/dio_lens_share_content.dart';

abstract final class DioLens {
  static void init({
    required GlobalKey<NavigatorState> navigatorKey,
    DioLensSettings settings = const DioLensSettings(),
    DioLensStorage? storage,
    DioLensMode mode = DioLensMode.debug,
    DioLensExportCallback? onExport,
    DioLensShareCallback? onShare,
  }) {
    final runtime = DioLensRuntime.current = DioLensRuntime(
      navigatorKey: navigatorKey,
      enabled: mode.isEnabled,
      onExport: onExport,
      onShare: onShare,
      initialSettings: settings,
      storage: storage != null
          ? () => storage
          : SharedPreferencesDioLensStorage.new,
    );
    if (runtime.enabled) {
      runtime.store.ready;
      runtime.bubble.attach();
    }
  }

  static bool get isInitialized => DioLensRuntime.current != null;

  static bool get isEnabled => DioLensRuntime.current?.enabled ?? false;

  static Future<void> open() => _runtime.open();

  static Future<void> openRequest(String id) => _runtime.openRequest(id);

  static ValueListenable<DioLensSettings> get settings =>
      _runtime.store.settings;

  static Future<void> updateSettings(DioLensSettings settings) =>
      _runtime.store.updateSettings(settings);

  static Future<void> resetSettings() => _runtime.store.resetSettings();

  static Future<DioLensExportFile> export(DioLensExportFormat format) =>
      _runtime.export(format);

  static Future<void> clear() => _runtime.store.clear();

  static DioLensRuntime get _runtime =>
      DioLensRuntime.current ??
      (throw StateError('DioLens.init must be called before using DioLens.'));
}
