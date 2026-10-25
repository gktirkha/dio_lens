import '../../../../core/domain/unit.dart';
import '../entities/dio_lens_settings.dart';

abstract interface class SettingsRepository {
  Stream<DioLensSettings> watchSettings();

  Future<Unit> updateSettings(DioLensSettings settings);

  Future<Unit> resetSettings();
}
