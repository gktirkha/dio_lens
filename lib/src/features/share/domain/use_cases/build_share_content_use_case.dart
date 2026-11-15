import '../../../../core/domain/use_case_base.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../entities/dio_lens_share_content.dart';
import '../utils/share_content_builder.dart';
import '../../../../core/utils/background/run_in_background.dart';

/// Parameters of [BuildShareContentUseCase].
typedef BuildShareContentParams = ({
  RequestDetailEntity request,
  DioLensSettings settings,
});

/// Builds the shared report of one request in the background (see
/// [runInBackground]).
class BuildShareContentUseCase
    implements UseCaseBase<DioLensShareContent, BuildShareContentParams> {
  /// Creates the use case.
  const BuildShareContentUseCase();

  @override
  Future<DioLensShareContent> call(BuildShareContentParams params) =>
      _buildInBackground(params.request, params.settings);

  static Future<DioLensShareContent> _buildInBackground(
    RequestDetailEntity request,
    DioLensSettings settings,
  ) => runInBackground(() => ShareContentBuilder.build(request, settings));
}
