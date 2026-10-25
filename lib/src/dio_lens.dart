import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'core/runtime/dio_lens_runtime.dart';
import 'core/storage/dio_lens_storage.dart';
import 'core/storage/shared_preferences_dio_lens_storage.dart';
import 'features/settings/domain/entities/dio_lens_settings.dart';

/// Dio Lens' public entry point.
///
/// ```dart
/// final navigatorKey = GlobalKey<NavigatorState>();
///
/// void main() {
///   DioLens.init(navigatorKey: navigatorKey);
///   dio.interceptors.add(DioLensInterceptor());
///   runApp(MaterialApp(navigatorKey: navigatorKey, home: const Home()));
/// }
/// ```
abstract final class DioLens {
  /// Sets Dio Lens up. Call once, before the first request.
  ///
  /// [navigatorKey] must be the key given to the app's `MaterialApp` (or
  /// `Navigator`): Dio Lens shows its pages and banners through it.
  ///
  /// [settings] apply until the user changes them in the settings screen;
  /// from then on the stored settings win.
  ///
  /// [storage] persists requests and settings; defaults to Dio Lens' own
  /// `shared_preferences` storage.
  ///
  /// With [enabled] false (the default outside debug builds), nothing is
  /// recorded.
  static void init({
    required GlobalKey<NavigatorState> navigatorKey,
    DioLensSettings settings = const DioLensSettings(),
    DioLensStorage? storage,
    bool enabled = kDebugMode,
  }) {
    DioLensRuntime.current = DioLensRuntime(
      navigatorKey: navigatorKey,
      enabled: enabled,
      initialSettings: settings,
      storage: storage != null
          ? () => storage
          : SharedPreferencesDioLensStorage.new,
    );
  }

  /// Whether [init] was called.
  static bool get isInitialized => DioLensRuntime.current != null;

  /// Whether requests are being recorded.
  static bool get isEnabled => DioLensRuntime.current?.enabled ?? false;

  /// Opens the inspector over the app.
  static Future<void> open() => _runtime.open();

  /// Opens the detail page of the captured request with [id].
  static Future<void> openRequest(String id) => _runtime.openRequest(id);

  /// Current settings; listen to follow changes.
  static ValueListenable<DioLensSettings> get settings =>
      _runtime.store.settings;

  /// Applies and stores [settings].
  static Future<void> updateSettings(DioLensSettings settings) =>
      _runtime.store.updateSettings(settings);

  /// Removes every captured request.
  static Future<void> clear() => _runtime.store.clear();

  static DioLensRuntime get _runtime =>
      DioLensRuntime.current ??
      (throw StateError('DioLens.init must be called before using DioLens.'));
}
