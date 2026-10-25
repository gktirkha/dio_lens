import '../../../../core/domain/unit.dart';
import '../entities/dio_lens_settings.dart';

abstract interface class SettingsRepository {
  /// The current settings, then every change.
  Stream<DioLensSettings> watchSettings();

  Future<Unit> updateSettings(DioLensSettings settings);

  /// Back to the settings given to `DioLens.init`.
  Future<Unit> resetSettings();
}
