import '../features/request_home/data/data_sources/request_home_data_source.dart';
import '../features/request_home/data/data_sources/request_home_mock_data_source.dart';
import '../features/request_home/data/repositories/request_home_repository_impl.dart';
import '../features/request_home/domain/repositories/request_home_repository.dart';
import '../features/request_home/domain/use_cases/clear_all_requests_use_case.dart';
import '../features/request_home/domain/use_cases/delete_request_use_case.dart';
import '../features/request_home/domain/use_cases/get_requests_use_case.dart';
import '../features/request_home/domain/use_cases/watch_requests_use_case.dart';
import '../features/request_home/presentation/controllers/request_home_controller.dart';
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
  }) : _requestHomeDataSourceFactory =
           requestHomeDataSource ?? RequestHomeMockDataSource.new,
       _statsDataSourceFactory = statsDataSource ?? StatsMockDataSource.new;

  final RequestHomeDataSource Function() _requestHomeDataSourceFactory;
  final StatsDataSource Function() _statsDataSourceFactory;

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
}
