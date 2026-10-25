/// Where Dio Lens persists captured requests and settings.
///
/// Implement this to use your own database (Hive, sqflite, Isar, …) and
/// pass it to `DioLens.init`; by default Dio Lens uses its own storage
/// built on `shared_preferences`.
///
/// Records are plain JSON-encodable maps, so an implementation needs no
/// Dio Lens types. Dio Lens keeps its own in-memory copy and applies the
/// max requests limit and retention itself; an implementation only stores
/// what it is told to.
///
/// Dio Lens never calls two methods at once: each call completes before
/// the next starts.
abstract class DioLensStorage {
  const DioLensStorage();

  /// Every stored request, in any order. Called once, on first use.
  Future<List<Map<String, dynamic>>> readRequests();

  /// Inserts the request [json] under [id], or replaces the stored one.
  Future<void> writeRequest(String id, Map<String, dynamic> json);

  /// Removes the requests with [ids]; unknown ids are ignored.
  Future<void> deleteRequests(List<String> ids);

  /// Removes every stored request (settings are kept).
  Future<void> clearRequests();

  /// The stored settings, or null when none were saved yet.
  Future<Map<String, dynamic>?> readSettings();

  Future<void> writeSettings(Map<String, dynamic> json);
}
