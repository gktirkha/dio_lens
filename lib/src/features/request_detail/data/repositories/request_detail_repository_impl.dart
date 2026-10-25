import '../../domain/entities/request_detail_entity.dart';
import '../../domain/repositories/request_detail_repository.dart';
import '../data_sources/request_detail_data_source.dart';

/// [RequestDetailRepository] over a [RequestDetailDataSource].
class RequestDetailRepositoryImpl implements RequestDetailRepository {
  /// Creates the repository.
  const RequestDetailRepositoryImpl(this._dataSource);

  final RequestDetailDataSource _dataSource;

  @override
  Stream<RequestDetailEntity?> watchRequest(String id) =>
      _dataSource.watchRequest(id);
}
