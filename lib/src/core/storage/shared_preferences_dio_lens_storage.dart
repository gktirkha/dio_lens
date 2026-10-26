import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/request_detail/domain/entities/request_detail_entity.dart';
import 'dio_lens_storage.dart';
import 'stored_requests_parser.dart';
import '../utils/background/run_in_background.dart';

/// Default [DioLensStorage], backed by `shared_preferences`. Each request is
/// stored as a full record and a summary entry, plus one entry listing the ids.
/// JSON encoding, decoding and parsing run in the background (see
/// [runInBackground]).
class SharedPreferencesDioLensStorage extends DioLensStorage
    implements ParsingDioLensStorage {
  /// Creates the storage, optionally over [preferences] and with a custom
  /// [keyPrefix].
  SharedPreferencesDioLensStorage({
    SharedPreferencesAsync? preferences,
    this.keyPrefix = 'dio_lens',
  }) : _injectedPreferences = preferences;

  /// Prefix of every key written, so entries never clash with the app's.
  final String keyPrefix;

  final SharedPreferencesAsync? _injectedPreferences;

  late final SharedPreferencesAsync _preferences =
      _injectedPreferences ?? SharedPreferencesAsync();

  String get _idsKey => '$keyPrefix.request_ids';
  String get _settingsKey => '$keyPrefix.settings';
  String _requestKey(String id) => '$keyPrefix.request.$id';
  String _summaryKey(String id) => '$keyPrefix.summary.$id';

  List<String>? _ids;

  Future<List<String>> _loadIds() async =>
      _ids ??= await _preferences.getStringList(_idsKey) ?? [];

  @override
  Future<List<Map<String, dynamic>>> readSummaries() async =>
      _decodeAllInBackground(await _readRawSummaries());

  @override
  Future<ParsedSummaries> readParsedSummaries() async =>
      _parseSummariesInBackground(await _readRawSummaries());

  @override
  Future<Map<String, dynamic>?> readRequest(String id) async {
    final raw = await _preferences.getString(_requestKey(id));
    return raw == null ? null : _decodeOneInBackground(raw);
  }

  @override
  Future<RequestDetailEntity?> readParsedRequest(String id) async {
    final raw = await _preferences.getString(_requestKey(id));
    return raw == null ? null : _parseOneInBackground(raw);
  }

  @override
  Future<List<Map<String, dynamic>>> readRequests() async =>
      _decodeAllInBackground(await _readRawRequests());

  @override
  Future<List<RequestDetailEntity>> readParsedRequests() async =>
      _parseRequestsInBackground(await _readRawRequests());

  Future<List<String>> _readRawSummaries() async {
    final ids = await _loadIds();
    if (ids.isEmpty) return [];
    final values = await _preferences.getAll(
      allowList: {for (final id in ids) _summaryKey(id)},
    );
    final missing = [
      for (final id in ids)
        if (values[_summaryKey(id)] is! String) id,
    ];
    final legacy = missing.isEmpty
        ? const <String, Object?>{}
        : await _preferences.getAll(
            allowList: {for (final id in missing) _requestKey(id)},
          );
    return [
      for (final id in ids)
        if (values[_summaryKey(id)] ?? legacy[_requestKey(id)]
            case final String raw)
          raw,
    ];
  }

  Future<List<String>> _readRawRequests() async {
    final ids = await _loadIds();
    if (ids.isEmpty) return [];
    final values = await _preferences.getAll(
      allowList: {for (final id in ids) _requestKey(id)},
    );
    return [
      for (final id in ids)
        if (values[_requestKey(id)] case final String raw) raw,
    ];
  }

  static Future<List<Map<String, dynamic>>> _decodeAllInBackground(
    List<String> raw,
  ) async => raw.isEmpty ? [] : runInBackground(() => _decodeAll(raw));

  static Future<ParsedSummaries> _parseSummariesInBackground(
    List<String> raw,
  ) => raw.isEmpty
      ? Future.value(parseStoredSummaries(const []))
      : runInBackground(() => parseStoredSummaries(_decodeAll(raw)));

  static Future<List<RequestDetailEntity>> _parseRequestsInBackground(
    List<String> raw,
  ) async => raw.isEmpty
      ? []
      : runInBackground(() => parseStoredRequests(_decodeAll(raw)));

  static Future<Map<String, dynamic>?> _decodeOneInBackground(String raw) =>
      runInBackground(() => _decode(raw));

  static Future<RequestDetailEntity?> _parseOneInBackground(String raw) =>
      runInBackground(() => parseStoredRequest(_decode(raw)));

  static Future<(String, String)> _encodeInBackground(
    Map<String, dynamic> request,
    Map<String, dynamic> summary,
  ) => runInBackground(() => (jsonEncode(request), jsonEncode(summary)));

  static List<Map<String, dynamic>> _decodeAll(List<String> raw) => [
    for (final r in raw) ?_decode(r),
  ];

  @override
  Future<void> writeRequest(
    String id, {
    required Map<String, dynamic> request,
    required Map<String, dynamic> summary,
  }) async {
    final ids = await _loadIds();
    final (requestJson, summaryJson) = await _encodeInBackground(
      request,
      summary,
    );
    await _preferences.setString(_requestKey(id), requestJson);
    await _preferences.setString(_summaryKey(id), summaryJson);
    if (!ids.contains(id)) {
      ids.add(id);
      await _preferences.setStringList(_idsKey, ids);
    }
  }

  @override
  Future<void> deleteRequests(List<String> ids) async {
    if (ids.isEmpty) return;
    final stored = await _loadIds();
    final removed = ids.toSet();
    await _preferences.clear(
      allowList: {
        for (final id in removed) ...[_requestKey(id), _summaryKey(id)],
      },
    );
    stored.removeWhere(removed.contains);
    await _preferences.setStringList(_idsKey, stored);
  }

  @override
  Future<void> clearRequests() async {
    final ids = await _loadIds();
    await _preferences.clear(
      allowList: {
        _idsKey,
        for (final id in ids) ...[_requestKey(id), _summaryKey(id)],
      },
    );
    ids.clear();
  }

  @override
  Future<Map<String, dynamic>?> readSettings() async {
    final raw = await _preferences.getString(_settingsKey);
    return raw == null ? null : _decode(raw);
  }

  @override
  Future<void> writeSettings(Map<String, dynamic> json) =>
      _preferences.setString(_settingsKey, jsonEncode(json));

  @override
  Future<void> clearSettings() => _preferences.remove(_settingsKey);

  static Map<String, dynamic>? _decode(String raw) {
    try {
      return switch (jsonDecode(raw)) {
        final Map<String, dynamic> json => json,
        _ => null,
      };
    } on FormatException {
      return null;
    }
  }
}
