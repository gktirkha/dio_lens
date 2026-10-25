import '../../domain/entities/dio_lens_settings.dart';

/// Where settings live.
abstract interface class SettingsDataSource {
  /// The current settings on listen, then every change.
  Stream<DioLensSettings> watchSettings();

  /// Applies and stores [settings].
  Future<void> updateSettings(DioLensSettings settings);

  /// Goes back to the initial settings.
  Future<void> resetSettings();
}
