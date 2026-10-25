import '../entities/request_detail_entity.dart';

/// Full requests for the detail page.
abstract interface class RequestDetailRepository {
  /// The request with [id]; emits on change and null once it is gone.
  Stream<RequestDetailEntity?> watchRequest(String id);
}
