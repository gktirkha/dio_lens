import '../../../../core/domain/use_case_base.dart';
import '../../../../core/enums/export_format.dart';
import '../entities/dio_lens_export_file.dart';
import '../repositories/export_repository.dart';

/// Builds an export file of the stored requests.
class ExportRequestsUseCase
    implements UseCaseBase<DioLensExportFile, DioLensExportFormat> {
  const ExportRequestsUseCase(this._repository);

  final ExportRepository _repository;

  @override
  Future<DioLensExportFile> call(DioLensExportFormat format) =>
      _repository.exportRequests(format);
}
