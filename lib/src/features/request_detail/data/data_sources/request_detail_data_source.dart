import '../../domain/entities/request_detail_entity.dart';

abstract interface class RequestDetailDataSource {
  Stream<RequestDetailEntity?> watchRequest(String id);
}
