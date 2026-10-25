import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../domain/entities/request_list_item_entity.dart';

extension RequestListItemMapper on RequestDetailEntity {
  /// The list-row view of this captured request.
  RequestListItemEntity toListItem() => RequestListItemEntity(
    id: id,
    method: method,
    uri: uri,
    startedAt: startedAt,
    state: state,
    statusCode: statusCode,
    duration: duration,
    responseSize: responseSize,
    errorType: errorType,
    requestContentType: requestContentType,
    responseContentType: responseContentType,
  );
}
