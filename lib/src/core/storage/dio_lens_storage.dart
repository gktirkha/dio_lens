abstract class DioLensStorage {
  const DioLensStorage();

  Future<List<Map<String, dynamic>>> readRequests();

  Future<void> writeRequest(String id, Map<String, dynamic> json);

  Future<void> deleteRequests(List<String> ids);

  Future<void> clearRequests();

  Future<Map<String, dynamic>?> readSettings();

  Future<void> writeSettings(Map<String, dynamic> json);

  Future<void> clearSettings();
}
