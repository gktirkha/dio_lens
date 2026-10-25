import 'dart:convert';
import 'dart:io';

import 'package:dio_lens/dio_lens.dart';

/// A [DioLensStorage] that keeps each request as two JSON files, a small
/// summary and the full record, plus one file for the settings:
///
/// ```text
/// <directory>/summaries/<id>.json
/// <directory>/requests/<id>.json
/// <directory>/settings.json
/// ```
class FileDioLensStorage extends DioLensStorage {
  /// Creates a storage that writes under [directory].
  FileDioLensStorage(this.directory);

  /// Folder holding every file this storage writes.
  final Directory directory;

  Directory get _summaries => Directory('${directory.path}/summaries');
  Directory get _requests => Directory('${directory.path}/requests');
  File get _settings => File('${directory.path}/settings.json');

  File _summaryFile(String id) => File('${_summaries.path}/$id.json');
  File _requestFile(String id) => File('${_requests.path}/$id.json');

  @override
  Future<List<Map<String, dynamic>>> readSummaries() => _readAll(_summaries);

  @override
  Future<Map<String, dynamic>?> readRequest(String id) =>
      _read(_requestFile(id));

  @override
  Future<List<Map<String, dynamic>>> readRequests() => _readAll(_requests);

  @override
  Future<void> writeRequest(
    String id, {
    required Map<String, dynamic> request,
    required Map<String, dynamic> summary,
  }) async {
    await _write(_requestFile(id), request);
    await _write(_summaryFile(id), summary);
  }

  @override
  Future<void> deleteRequests(List<String> ids) async {
    for (final id in ids) {
      await _delete(_requestFile(id));
      await _delete(_summaryFile(id));
    }
  }

  @override
  Future<void> clearRequests() async {
    for (final folder in [_requests, _summaries]) {
      if (await folder.exists()) await folder.delete(recursive: true);
    }
  }

  @override
  Future<Map<String, dynamic>?> readSettings() => _read(_settings);

  @override
  Future<void> writeSettings(Map<String, dynamic> json) =>
      _write(_settings, json);

  @override
  Future<void> clearSettings() => _delete(_settings);

  /// The JSON object in [file]; null when it is missing or unreadable.
  Future<Map<String, dynamic>?> _read(File file) async {
    if (!await file.exists()) return null;
    try {
      final json = jsonDecode(await file.readAsString());
      return json is Map<String, dynamic> ? json : null;
    } on FormatException {
      return null;
    }
  }

  /// Every readable JSON object in [folder], in any order.
  Future<List<Map<String, dynamic>>> _readAll(Directory folder) async {
    if (!await folder.exists()) return [];
    final rows = <Map<String, dynamic>>[];
    await for (final entity in folder.list()) {
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      if (await _read(entity) case final json?) rows.add(json);
    }
    return rows;
  }

  /// Writes [json] to a temporary file, then renames it into place, so a
  /// crash never leaves a half-written file.
  Future<void> _write(File file, Map<String, dynamic> json) async {
    await file.parent.create(recursive: true);
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(jsonEncode(json), flush: true);
    await temp.rename(file.path);
  }

  Future<void> _delete(File file) async {
    if (await file.exists()) await file.delete();
  }
}
