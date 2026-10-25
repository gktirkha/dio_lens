import '../../domain/entities/dio_lens_settings.dart';

/// Where settings live.
abstract interface class SettingsDataSource {
  /// The current settings on listen, then every change.
  Stream<DioLensSettings> watchSettings();

  Future<void> updateSettings(DioLensSettings settings);

  Future<void> resetSettings();
}
