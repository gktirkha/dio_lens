import 'dart:convert';

import 'package:dio_lens/dio_lens.dart';

/// In-memory [DioLensStorage] that copies every record through JSON, so
/// tests catch anything that is not JSON-encodable.
class MemoryStorage extends DioLensStorage {
  final Map<String, Map<String, dynamic>> requests = {};
  final Map<String, Map<String, dynamic>> summaries = {};
  Map<String, dynamic>? settings;
  final List<String> deleted = [];
  int clears = 0;

  static Map<String, dynamic> _copy(Map<String, dynamic> json) =>
      jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

  @override
  Future<List<Map<String, dynamic>>> readSummaries() async => [
    for (final id in requests.keys) _copy(summaries[id] ?? requests[id]!),
  ];

  @override
  Future<Map<String, dynamic>?> readRequest(String id) async {
    final json = requests[id];
    return json == null ? null : _copy(json);
  }

  @override
  Future<List<Map<String, dynamic>>> readRequests() async => [
    for (final json in requests.values) _copy(json),
  ];

  @override
  Future<void> writeRequest(
    String id, {
    required Map<String, dynamic> request,
    required Map<String, dynamic> summary,
  }) async {
    requests[id] = _copy(request);
    summaries[id] = _copy(summary);
  }

  @override
  Future<void> deleteRequests(List<String> ids) async {
    deleted.addAll(ids);
    for (final id in ids) {
      requests.remove(id);
      summaries.remove(id);
    }
  }

  @override
  Future<void> clearRequests() async {
    clears++;
    requests.clear();
    summaries.clear();
  }

  @override
  Future<Map<String, dynamic>?> readSettings() async => settings;

  @override
  Future<void> writeSettings(Map<String, dynamic> json) async =>
      settings = _copy(json);

  @override
  Future<void> clearSettings() async => settings = null;
}
