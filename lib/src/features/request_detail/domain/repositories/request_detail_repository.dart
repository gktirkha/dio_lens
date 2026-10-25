import '../entities/request_detail_entity.dart';

abstract interface class RequestDetailRepository {
  Stream<RequestDetailEntity?> watchRequest(String id);
}
