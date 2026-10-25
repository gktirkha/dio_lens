import '../../../../core/domain/unit.dart';
import '../../../../core/domain/use_case_base.dart';
import '../repositories/settings_repository.dart';

class ResetSettingsUseCase implements UseCaseBase<Unit, Unit> {
  const ResetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<Unit> call(Unit params) => _repository.resetSettings();
}
