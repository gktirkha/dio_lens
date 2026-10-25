abstract class DioLensStorage {
  const DioLensStorage();

  Future<List<Map<String, dynamic>>> readSummaries();

  Future<Map<String, dynamic>?> readRequest(String id);

  Future<List<Map<String, dynamic>>> readRequests();

  Future<void> writeRequest(
    String id, {
    required Map<String, dynamic> request,
    required Map<String, dynamic> summary,
  });

  Future<void> deleteRequests(List<String> ids);

  Future<void> clearRequests();

  Future<Map<String, dynamic>?> readSettings();

  Future<void> writeSettings(Map<String, dynamic> json);

  Future<void> clearSettings();
}
