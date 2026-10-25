/// File formats Dio Lens can export captured requests in.
enum DioLensExportFormat {
  /// HTTP Archive 1.2, readable by browser dev tools, Charles, Proxyman…
  har('har', 'application/json'),

  /// Dio Lens' own records, as stored.
  json('json', 'application/json');

  const DioLensExportFormat(this.extension, this.mimeType);

  /// File extension, without the dot.
  final String extension;
  final String mimeType;
}
