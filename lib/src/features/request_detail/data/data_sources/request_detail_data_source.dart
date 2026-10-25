import '../../domain/entities/request_detail_entity.dart';

/// Raw storage of full request details.
abstract interface class RequestDetailDataSource {
  /// The request with [id]; emits on change and null once it is gone.
  Stream<RequestDetailEntity?> watchRequest(String id);
}
