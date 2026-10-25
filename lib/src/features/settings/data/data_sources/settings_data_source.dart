import '../../domain/entities/dio_lens_settings.dart';

abstract interface class SettingsDataSource {
  Stream<DioLensSettings> watchSettings();

  Future<void> updateSettings(DioLensSettings settings);

  Future<void> resetSettings();
}
