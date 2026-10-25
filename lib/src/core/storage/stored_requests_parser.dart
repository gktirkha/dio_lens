import '../../features/request_detail/domain/entities/request_detail_entity.dart';
import '../../features/request_home/domain/entities/request_list_item_entity.dart';

/// Request summaries read back from storage, newest first, plus the ids of rows
/// that no longer parse.
typedef ParsedSummaries = ({
  List<RequestListItemEntity> summaries,
  List<String> corrupt,
});

/// Parses stored summary [rows]. Pure, so it can run in an isolate.
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

/// Parses stored full request [rows], newest first; rows that no longer parse
/// are skipped.
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

/// Parses one stored full request; null when [json] is null or no longer
/// parses.
RequestDetailEntity? parseStoredRequest(Map<String, dynamic>? json) {
  if (json == null) return null;
  try {
    return RequestDetailEntity.fromJson(json);
  } catch (_) {
    return null;
  }
}

/// A storage that can read and parse its requests off the main isolate.
abstract interface class ParsingDioLensStorage {
  /// Same as `readSummaries`, parsed by [parseStoredSummaries].
  Future<ParsedSummaries> readParsedSummaries();

  /// Same as `readRequest`, parsed by [parseStoredRequest].
  Future<RequestDetailEntity?> readParsedRequest(String id);

  /// Same as `readRequests`, parsed by [parseStoredRequests].
  Future<List<RequestDetailEntity>> readParsedRequests();
}
