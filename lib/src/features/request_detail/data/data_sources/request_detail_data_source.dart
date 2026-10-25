import '../../domain/entities/request_detail_entity.dart';

/// Where full requests for the detail page come from.
abstract interface class RequestDetailDataSource {
  /// The request with [id]; emits on change and null once it is gone.
  Stream<RequestDetailEntity?> watchRequest(String id);
}
