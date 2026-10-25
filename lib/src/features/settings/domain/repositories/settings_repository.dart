import '../../../../core/domain/unit.dart';
import '../entities/dio_lens_settings.dart';

/// Dio Lens settings.
abstract interface class SettingsRepository {
  /// The current settings, then every change.
  Stream<DioLensSettings> watchSettings();

  /// Applies and stores [settings].
  Future<Unit> updateSettings(DioLensSettings settings);

  /// Goes back to the settings given to `DioLens.init`.
  Future<Unit> resetSettings();
}
