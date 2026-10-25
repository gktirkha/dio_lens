/// Where Dio Lens persists captured requests and settings. Implement it to use
/// your own database and pass it to `DioLens.init`; by default Dio Lens uses
/// `shared_preferences`. Records are plain JSON-encodable maps. Each request
/// has a full record and a small summary (no headers or bodies) used for lists.
/// Dio Lens never calls two methods at once.
abstract class DioLensStorage {
  /// Creates a storage.
  const DioLensStorage();

  /// The summary of every stored request, in any order. Called once, on first
  /// use. Return full records instead if summaries are not stored separately.
  Future<List<Map<String, dynamic>>> readSummaries();

  /// The full record of the request with [id], or null when it is not stored.
  Future<Map<String, dynamic>?> readRequest(String id);

  /// The full record of every stored request, in any order. Used for export.
  Future<List<Map<String, dynamic>>> readRequests();

  /// Stores the full [request] record and its [summary] under [id], replacing
  /// any stored ones.
  Future<void> writeRequest(
    String id, {
    required Map<String, dynamic> request,
    required Map<String, dynamic> summary,
  });

  /// Removes the requests with [ids]; unknown ids are ignored.
  Future<void> deleteRequests(List<String> ids);

  /// Removes every stored request; settings are kept.
  Future<void> clearRequests();

  /// The stored settings, or null when none were saved yet.
  Future<Map<String, dynamic>?> readSettings();

  /// Stores the settings [json].
  Future<void> writeSettings(Map<String, dynamic> json);

  /// Removes the stored settings.
  Future<void> clearSettings();
}
