import '../../../../core/domain/unit.dart';
import '../../domain/entities/dio_lens_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._dataSource);

  final SettingsDataSource _dataSource;

  @override
  Stream<DioLensSettings> watchSettings() => _dataSource.watchSettings();

  @override
  Future<Unit> updateSettings(DioLensSettings settings) async {
    await _dataSource.updateSettings(settings);
    return unit;
  }

  @override
  Future<Unit> resetSettings() async {
    await _dataSource.resetSettings();
    return unit;
  }
}
