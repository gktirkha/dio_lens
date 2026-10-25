import '../../features/request_detail/domain/entities/request_detail_entity.dart';

/// Requests read back from storage: the valid ones newest first, plus the
/// ids of rows that no longer parse.
typedef ParsedRequests = ({
  List<RequestDetailEntity> requests,
  List<String> corrupt,
});

/// Parses stored request [rows]. Pure, so it can run in an isolate.
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

/// A storage that can read and parse its requests off the main isolate.
abstract interface class ParsingDioLensStorage {
  /// Same rows as `readRequests`, already parsed by [parseStoredRequests].
  Future<ParsedRequests> readParsedRequests();
}
