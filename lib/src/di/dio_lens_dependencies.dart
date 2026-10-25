import '../features/export/data/data_sources/export_data_source.dart';
import '../features/export/data/repositories/export_repository_impl.dart';
import '../features/export/domain/repositories/export_repository.dart';
import '../features/export/domain/use_cases/export_requests_use_case.dart';
import '../features/request_detail/data/data_sources/request_detail_data_source.dart';
import '../features/request_detail/data/repositories/request_detail_repository_impl.dart';
import '../features/request_detail/domain/repositories/request_detail_repository.dart';
import '../features/request_detail/domain/use_cases/watch_request_detail_use_case.dart';
import '../features/request_detail/presentation/controllers/request_detail_controller.dart';
import '../features/request_home/data/data_sources/request_home_data_source.dart';
import '../features/request_home/data/repositories/request_home_repository_impl.dart';
import '../features/request_home/domain/repositories/request_home_repository.dart';
import '../features/request_home/domain/use_cases/clear_all_requests_use_case.dart';
import '../features/request_home/domain/use_cases/delete_request_use_case.dart';
import '../features/request_home/domain/use_cases/get_requests_use_case.dart';
import '../features/request_home/domain/use_cases/remove_expired_requests_use_case.dart';
import '../features/request_home/domain/use_cases/watch_requests_use_case.dart';
import '../features/request_home/presentation/controllers/request_home_controller.dart';
import '../features/settings/data/data_sources/settings_data_source.dart';
import '../features/share/domain/use_cases/build_share_content_use_case.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/domain/use_cases/reset_settings_use_case.dart';
import '../features/settings/domain/use_cases/update_settings_use_case.dart';
import '../features/settings/domain/use_cases/watch_settings_use_case.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import '../features/stats/data/data_sources/stats_data_source.dart';
import '../features/stats/data/repositories/stats_repository_impl.dart';
import '../features/stats/domain/repositories/stats_repository.dart';
import '../features/stats/domain/use_cases/watch_stats_use_case.dart';
import '../features/stats/presentation/controllers/stats_controller.dart';

class DioLensDependencies {
  DioLensDependencies({
    required RequestHomeDataSource Function() requestHomeDataSource,
    required StatsDataSource Function() statsDataSource,
    required RequestDetailDataSource Function() requestDetailDataSource,
    required SettingsDataSource Function() settingsDataSource,
    required ExportDataSource Function() exportDataSource,
  }) : _requestHomeDataSourceFactory = requestHomeDataSource,
       _statsDataSourceFactory = statsDataSource,
       _requestDetailDataSourceFactory = requestDetailDataSource,
       _settingsDataSourceFactory = settingsDataSource,
       _exportDataSourceFactory = exportDataSource;

  final RequestHomeDataSource Function() _requestHomeDataSourceFactory;
  final StatsDataSource Function() _statsDataSourceFactory;
  final SettingsDataSource Function() _settingsDataSourceFactory;
  final ExportDataSource Function() _exportDataSourceFactory;

  final RequestDetailDataSource Function() _requestDetailDataSourceFactory;

  late final RequestHomeDataSource requestHomeDataSource =
      _requestHomeDataSourceFactory();

  late final RequestHomeRepository requestHomeRepository =
      RequestHomeRepositoryImpl(requestHomeDataSource);

  late final WatchRequestsUseCase watchRequestsUseCase = WatchRequestsUseCase(
    requestHomeRepository,
  );

  late final GetRequestsUseCase getRequestsUseCase = GetRequestsUseCase(
    requestHomeRepository,
  );

  late final DeleteRequestUseCase deleteRequestUseCase = DeleteRequestUseCase(
    requestHomeRepository,
  );

  late final ClearAllRequestsUseCase clearAllRequestsUseCase =
      ClearAllRequestsUseCase(requestHomeRepository);

  late final RemoveExpiredRequestsUseCase removeExpiredRequestsUseCase =
      RemoveExpiredRequestsUseCase(requestHomeRepository);

  RequestHomeController createRequestHomeController() => RequestHomeController(
    watchRequests: watchRequestsUseCase,
    deleteRequest: deleteRequestUseCase,
    clearAllRequests: clearAllRequestsUseCase,
    removeExpiredRequests: removeExpiredRequestsUseCase,
  );

  late final StatsDataSource statsDataSource = _statsDataSourceFactory();

  late final StatsRepository statsRepository = StatsRepositoryImpl(
    statsDataSource,
  );

  late final WatchStatsUseCase watchStatsUseCase = WatchStatsUseCase(
    statsRepository,
  );

  StatsController createStatsController() =>
      StatsController(watchStats: watchStatsUseCase);

  late final RequestDetailDataSource requestDetailDataSource =
      _requestDetailDataSourceFactory();

  late final RequestDetailRepository requestDetailRepository =
      RequestDetailRepositoryImpl(requestDetailDataSource);

  late final WatchRequestDetailUseCase watchRequestDetailUseCase =
      WatchRequestDetailUseCase(requestDetailRepository);

  RequestDetailController createRequestDetailController(String requestId) =>
      RequestDetailController(
        requestId: requestId,
        watchRequestDetail: watchRequestDetailUseCase,
        watchSettings: watchSettingsUseCase,
        buildShareContent: buildShareContentUseCase,
      );

  late final BuildShareContentUseCase buildShareContentUseCase =
      const BuildShareContentUseCase();

  late final SettingsDataSource settingsDataSource =
      _settingsDataSourceFactory();

  late final SettingsRepository settingsRepository = SettingsRepositoryImpl(
    settingsDataSource,
  );

  late final WatchSettingsUseCase watchSettingsUseCase = WatchSettingsUseCase(
    settingsRepository,
  );

  late final UpdateSettingsUseCase updateSettingsUseCase =
      UpdateSettingsUseCase(settingsRepository);

  late final ResetSettingsUseCase resetSettingsUseCase = ResetSettingsUseCase(
    settingsRepository,
  );

  SettingsController createSettingsController() => SettingsController(
    watchSettings: watchSettingsUseCase,
    updateSettings: updateSettingsUseCase,
    resetSettings: resetSettingsUseCase,
    watchRequests: watchRequestsUseCase,
  );

  late final ExportDataSource exportDataSource = _exportDataSourceFactory();

  late final ExportRepository exportRepository = ExportRepositoryImpl(
    exportDataSource,
  );

  late final ExportRequestsUseCase exportRequestsUseCase =
      ExportRequestsUseCase(exportRepository);
}
