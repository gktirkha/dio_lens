import '../features/request_detail/data/data_sources/request_detail_data_source.dart';
import '../features/request_detail/data/data_sources/request_detail_mock_data_source.dart';
import '../features/request_detail/data/repositories/request_detail_repository_impl.dart';
import '../features/request_detail/domain/repositories/request_detail_repository.dart';
import '../features/request_detail/domain/use_cases/watch_request_detail_use_case.dart';
import '../features/request_detail/presentation/controllers/request_detail_controller.dart';
import '../features/request_home/data/data_sources/request_home_data_source.dart';
import '../features/request_home/data/data_sources/request_home_mock_data_source.dart';
import '../features/request_home/data/repositories/request_home_repository_impl.dart';
import '../features/request_home/domain/repositories/request_home_repository.dart';
import '../features/request_home/domain/use_cases/clear_all_requests_use_case.dart';
import '../features/request_home/domain/use_cases/delete_request_use_case.dart';
import '../features/request_home/domain/use_cases/get_requests_use_case.dart';
import '../features/request_home/domain/use_cases/watch_requests_use_case.dart';
import '../features/request_home/presentation/controllers/request_home_controller.dart';
import '../features/settings/data/data_sources/settings_data_source.dart';
import '../features/settings/data/data_sources/settings_mock_data_source.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/domain/use_cases/reset_settings_use_case.dart';
import '../features/settings/domain/use_cases/update_settings_use_case.dart';
import '../features/settings/domain/use_cases/watch_settings_use_case.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';
import '../features/stats/data/data_sources/stats_data_source.dart';
import '../features/stats/data/data_sources/stats_mock_data_source.dart';
import '../features/stats/data/repositories/stats_repository_impl.dart';
import '../features/stats/domain/repositories/stats_repository.dart';
import '../features/stats/domain/use_cases/watch_stats_use_case.dart';
import '../features/stats/presentation/controllers/stats_controller.dart';

/// Wires Dio Lens' layers together.
///
/// Every dependency is lazy: nothing is created until first accessed, and
/// each is created once per [DioLensDependencies] instance.
class DioLensDependencies {
  DioLensDependencies({
    RequestHomeDataSource Function()? requestHomeDataSource,
    StatsDataSource Function()? statsDataSource,
    RequestDetailDataSource Function()? requestDetailDataSource,
    SettingsDataSource Function()? settingsDataSource,
  }) : _requestDetailDataSourceFactory = requestDetailDataSource,
       _settingsDataSourceFactory =
           settingsDataSource ?? SettingsMockDataSource.new,
       _requestHomeDataSourceFactory =
           requestHomeDataSource ?? RequestHomeMockDataSource.new,
       _statsDataSourceFactory = statsDataSource ?? StatsMockDataSource.new;

  final RequestHomeDataSource Function() _requestHomeDataSourceFactory;
  final StatsDataSource Function() _statsDataSourceFactory;
  final SettingsDataSource Function() _settingsDataSourceFactory;

  /// Null: derive details from [requestHomeDataSource] (mock).
  final RequestDetailDataSource Function()? _requestDetailDataSourceFactory;

  // ---- Request home ----

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

  /// A new controller for one request home page; the caller disposes it.
  RequestHomeController createRequestHomeController() => RequestHomeController(
    watchRequests: watchRequestsUseCase,
    deleteRequest: deleteRequestUseCase,
    clearAllRequests: clearAllRequestsUseCase,
  );

  // ---- Stats ----

  late final StatsDataSource statsDataSource = _statsDataSourceFactory();

  late final StatsRepository statsRepository = StatsRepositoryImpl(
    statsDataSource,
  );

  late final WatchStatsUseCase watchStatsUseCase = WatchStatsUseCase(
    statsRepository,
  );

  /// A new controller for one stats page; the caller disposes it.
  StatsController createStatsController() =>
      StatsController(watchStats: watchStatsUseCase);

  // ---- Request detail ----

  late final RequestDetailDataSource requestDetailDataSource =
      _requestDetailDataSourceFactory?.call() ??
      RequestDetailMockDataSource(requestHomeDataSource);

  late final RequestDetailRepository requestDetailRepository =
      RequestDetailRepositoryImpl(requestDetailDataSource);

  late final WatchRequestDetailUseCase watchRequestDetailUseCase =
      WatchRequestDetailUseCase(requestDetailRepository);

  /// A new controller for one request's detail page; the page disposes it.
  RequestDetailController createRequestDetailController(String requestId) =>
      RequestDetailController(
        requestId: requestId,
        watchRequestDetail: watchRequestDetailUseCase,
        watchSettings: watchSettingsUseCase,
      );

  // ---- Settings ----

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

  /// A new controller for the settings sheet; the sheet disposes it.
  SettingsController createSettingsController() => SettingsController(
    watchSettings: watchSettingsUseCase,
    updateSettings: updateSettingsUseCase,
    resetSettings: resetSettingsUseCase,
    watchRequests: watchRequestsUseCase,
  );
}
