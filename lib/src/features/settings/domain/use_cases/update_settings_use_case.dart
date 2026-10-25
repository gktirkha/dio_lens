import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../entities/dio_lens_settings.dart';
import '../repositories/settings_repository.dart';

/// Applies and stores new settings.
class UpdateSettingsUseCase implements UseCaseBase<Unit, DioLensSettings> {
  const UpdateSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Unit> call(DioLensSettings settings) =>
      _repository.updateSettings(settings);
}
