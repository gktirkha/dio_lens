import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'dio_lens_storage.dart';

/// Default [DioLensStorage], backed by `shared_preferences`.
///
/// Each request is its own JSON string entry, plus one entry listing the
/// stored ids, so a write touches only the request that changed.
class SharedPreferencesDioLensStorage extends DioLensStorage {
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

  /// Stored ids, read once and then kept in sync with every write.
  List<String>? _ids;

  Future<List<String>> _loadIds() async =>
      _ids ??= await _preferences.getStringList(_idsKey) ?? [];

  @override
  Future<List<Map<String, dynamic>>> readRequests() async {
    final ids = await _loadIds();
    if (ids.isEmpty) return [];
    final values = await _preferences.getAll(
      allowList: {for (final id in ids) _requestKey(id)},
    );
    return [
      for (final id in ids)
        if (values[_requestKey(id)] case final String raw) ?_decode(raw),
    ];
  }

  @override
  Future<void> writeRequest(String id, Map<String, dynamic> json) async {
    final ids = await _loadIds();
    await _preferences.setString(_requestKey(id), jsonEncode(json));
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
      allowList: {for (final id in removed) _requestKey(id)},
    );
    stored.removeWhere(removed.contains);
    await _preferences.setStringList(_idsKey, stored);
  }

  @override
  Future<void> clearRequests() async {
    final ids = await _loadIds();
    await _preferences.clear(
      allowList: {_idsKey, for (final id in ids) _requestKey(id)},
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

  /// [raw] as a JSON object; null when it is corrupt.
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
