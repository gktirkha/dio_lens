import '../../../../core/domain/unit.dart';
import '../../domain/entities/request_filter_params.dart';
import '../../domain/entities/request_list_item_entity.dart';
import '../../domain/repositories/request_home_repository.dart';
import '../data_sources/request_home_data_source.dart';

/// [RequestHomeRepository] over a [RequestHomeDataSource], applying the filter.
class RequestHomeRepositoryImpl implements RequestHomeRepository {
  /// Creates the repository.
  const RequestHomeRepositoryImpl(this._dataSource);

  final RequestHomeDataSource _dataSource;

  @override
  Stream<List<RequestListItemEntity>> watchRequests(
    RequestFilterParams params,
  ) => _dataSource.watchRequests().map((all) => _apply(all, params));

  @override
  Future<List<RequestListItemEntity>> getRequests(
    RequestFilterParams params,
  ) async => _apply(await _dataSource.getRequests(), params);

  @override
  Future<Unit> deleteRequest(String id) async {
    await _dataSource.deleteRequest(id);
    return unit;
  }

  @override
  Future<Unit> clearAll() async {
    await _dataSource.clearAll();
    return unit;
  }

  @override
  Future<Unit> removeExpired() async {
    await _dataSource.removeExpired();
    return unit;
  }

  static List<RequestListItemEntity> _apply(
    List<RequestListItemEntity> all,
    RequestFilterParams params,
  ) {
    if (params.isEmpty) return all;
    return List.unmodifiable(all.where(params.matches));
  }
}
