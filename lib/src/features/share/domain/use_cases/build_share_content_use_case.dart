import 'dart:isolate';

import '../../../../core/domain/use_case_base.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../entities/dio_lens_share_content.dart';
import '../utils/share_content_builder.dart';

typedef BuildShareContentParams = ({
  RequestDetailEntity request,
  DioLensSettings settings,
});

class BuildShareContentUseCase
    implements UseCaseBase<DioLensShareContent, BuildShareContentParams> {
  const BuildShareContentUseCase();

  @override
  Future<DioLensShareContent> call(BuildShareContentParams params) =>
      _buildInIsolate(params.request, params.settings);

  static Future<DioLensShareContent> _buildInIsolate(
    RequestDetailEntity request,
    DioLensSettings settings,
  ) => Isolate.run(() => ShareContentBuilder.build(request, settings));
}
