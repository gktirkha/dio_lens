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

/// Dio Lens' public entry point: set it up with [init], add
/// `DioLensInterceptor` to your Dio, and open the inspector with [open] or the
/// floating bubble.
abstract final class DioLens {
  /// Sets Dio Lens up. Call once, before the first request. [navigatorKey] must
  /// be the key given to the app's `MaterialApp`: Dio Lens shows its pages,
  /// banner and bubble through it. [settings] apply until the user changes them
  /// in the settings screen; from then on the stored ones win. [storage]
  /// persists requests and settings (defaults to `shared_preferences`). [mode]
  /// picks the build modes Dio Lens is enabled in (debug only by default).
  /// [onExport] receives exported files and [onShare] shared requests; without
  /// them export is disabled and share copies to the clipboard.
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

  /// Whether [init] was called.
  static bool get isInitialized => DioLensRuntime.current != null;

  /// Whether requests are being recorded in this build mode.
  static bool get isEnabled => DioLensRuntime.current?.enabled ?? false;

  /// Opens the Dio Lens home over the app.
  static Future<void> open() => _runtime.open();

  /// Opens the detail page of the captured request with [id].
  static Future<void> openRequest(String id) => _runtime.openRequest(id);

  /// Current settings; listen to follow changes.
  static ValueListenable<DioLensSettings> get settings =>
      _runtime.store.settings;

  /// Applies and stores [settings].
  static Future<void> updateSettings(DioLensSettings settings) =>
      _runtime.store.updateSettings(settings);

  /// Deletes the stored settings and goes back to the ones passed to [init].
  /// Captured requests are kept.
  static Future<void> resetSettings() => _runtime.store.resetSettings();

  /// Builds an export of every stored request in [format], in memory, with
  /// values masked as the redaction settings say.
  static Future<DioLensExportFile> export(DioLensExportFormat format) =>
      _runtime.export(format);

  /// Removes every captured request.
  static Future<void> clear() => _runtime.store.clear();

  static DioLensRuntime get _runtime =>
      DioLensRuntime.current ??
      (throw StateError('DioLens.init must be called before using DioLens.'));
}
