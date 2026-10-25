/// File formats Dio Lens can export captured requests in.
enum DioLensExportFormat {
  /// HTTP Archive 1.2, readable by browser dev tools, Charles, Proxyman and
  /// similar tools.
  har('har', 'application/json'),

  /// Dio Lens' own request records, as stored.
  json('json', 'application/json');

  const DioLensExportFormat(this.extension, this.mimeType);

  /// File extension, without the dot.
  final String extension;

  /// MIME type of the exported file.
  final String mimeType;
}
