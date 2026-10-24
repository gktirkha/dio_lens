import '../features/request_home/data/data_sources/request_home_data_source.dart';
import '../features/request_home/data/data_sources/request_home_mock_data_source.dart';
import '../features/request_home/data/repositories/request_home_repository_impl.dart';
import '../features/request_home/domain/repositories/request_home_repository.dart';
import '../features/request_home/domain/use_cases/clear_all_requests_use_case.dart';
import '../features/request_home/domain/use_cases/delete_request_use_case.dart';
import '../features/request_home/domain/use_cases/get_requests_use_case.dart';
import '../features/request_home/domain/use_cases/watch_requests_use_case.dart';
import '../features/request_home/presentation/controllers/request_home_controller.dart';

/// Wires Dio Lens' layers together.
///
/// Every dependency is lazy: nothing is created until first accessed, and
/// each is created once per [DioLensDependencies] instance.
class DioLensDependencies {
  DioLensDependencies({RequestHomeDataSource Function()? requestHomeDataSource})
    : _requestHomeDataSourceFactory =
          requestHomeDataSource ?? RequestHomeMockDataSource.new;

  final RequestHomeDataSource Function() _requestHomeDataSourceFactory;

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
}
