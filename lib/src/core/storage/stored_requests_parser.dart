import '../../features/request_detail/domain/entities/request_detail_entity.dart';

typedef ParsedRequests = ({
  List<RequestDetailEntity> requests,
  List<String> corrupt,
});

ParsedRequests parseStoredRequests(List<Map<String, dynamic>> rows) {
  final requests = <RequestDetailEntity>[];
  final corrupt = <String>[];
  for (final json in rows) {
    try {
      requests.add(RequestDetailEntity.fromJson(json));
    } catch (_) {
      if (json['id'] case final String id) corrupt.add(id);
    }
  }
  requests.sort((a, b) => b.startedAt.compareTo(a.startedAt));
  return (requests: requests, corrupt: corrupt);
}

abstract interface class ParsingDioLensStorage {
  Future<ParsedRequests> readParsedRequests();
}
