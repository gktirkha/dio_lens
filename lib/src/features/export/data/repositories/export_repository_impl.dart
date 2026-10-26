import 'dart:typed_data';

import '../../../../core/enums/export_format.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../domain/entities/dio_lens_export_file.dart';
import '../../domain/repositories/export_repository.dart';
import '../data_sources/export_data_source.dart';
import '../utils/export_builder.dart';
import '../../../../core/utils/background/run_in_background.dart';

/// Builds exports in the background (see [runInBackground]).
class ExportRepositoryImpl implements ExportRepository {
  /// Creates the repository over [ExportDataSource].
  const ExportRepositoryImpl(this._dataSource);

  final ExportDataSource _dataSource;

  @override
  Future<DioLensExportFile> exportRequests(DioLensExportFormat format) async {
    final requests = await _dataSource.getRequests();
    final createdAt = DateTime.now();
    final bytes = await _buildInBackground(
      format,
      requests,
      _dataSource.settings,
      createdAt,
    );
    return DioLensExportFile(
      format: format,
      fileName: 'dio_lens_${_stamp(createdAt)}.${format.extension}',
      bytes: bytes,
      requestCount: requests.length,
      createdAt: createdAt,
    );
  }

  static Future<Uint8List> _buildInBackground(
    DioLensExportFormat format,
    List<RequestDetailEntity> requests,
    DioLensSettings settings,
    DateTime createdAt,
  ) => runInBackground(
    () => ExportBuilder.build(format, requests, settings, createdAt),
  );

  static String _stamp(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}${two(t.month)}${two(t.day)}_'
        '${two(t.hour)}${two(t.minute)}${two(t.second)}';
  }
}
