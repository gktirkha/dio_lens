import '../../features/request_detail/domain/entities/request_detail_entity.dart';
import '../../features/request_home/domain/entities/request_list_item_entity.dart';

typedef ParsedSummaries = ({
  List<RequestListItemEntity> summaries,
  List<String> corrupt,
});

ParsedSummaries parseStoredSummaries(List<Map<String, dynamic>> rows) {
  final summaries = <RequestListItemEntity>[];
  final corrupt = <String>[];
  for (final json in rows) {
    try {
      summaries.add(RequestListItemEntity.fromJson(json));
    } catch (_) {
      if (json['id'] case final String id) corrupt.add(id);
    }
  }
  summaries.sort((a, b) => b.startedAt.compareTo(a.startedAt));
  return (summaries: summaries, corrupt: corrupt);
}

List<RequestDetailEntity> parseStoredRequests(List<Map<String, dynamic>> rows) {
  final requests = <RequestDetailEntity>[];
  for (final json in rows) {
    try {
      requests.add(RequestDetailEntity.fromJson(json));
    } catch (_) {}
  }
  requests.sort((a, b) => b.startedAt.compareTo(a.startedAt));
  return requests;
}

RequestDetailEntity? parseStoredRequest(Map<String, dynamic>? json) {
  if (json == null) return null;
  try {
    return RequestDetailEntity.fromJson(json);
  } catch (_) {
    return null;
  }
}

abstract interface class ParsingDioLensStorage {
  Future<ParsedSummaries> readParsedSummaries();

  Future<RequestDetailEntity?> readParsedRequest(String id);

  Future<List<RequestDetailEntity>> readParsedRequests();
}
