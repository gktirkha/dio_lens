import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../entities/dio_lens_settings.dart';
import '../repositories/settings_repository.dart';

/// Live settings.
class WatchSettingsUseCase
    implements UseCaseBase<Stream<DioLensSettings>, Unit> {
  const WatchSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Stream<DioLensSettings> call(Unit params) => _repository.watchSettings();
}
