import '../entities/request_detail_entity.dart';

/// Full details of captured requests.
abstract interface class RequestDetailRepository {
  /// The request with [id]; emits again when it changes (e.g. a pending
  /// request completes) and null once it no longer exists.
  Stream<RequestDetailEntity?> watchRequest(String id);
}
