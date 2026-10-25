enum DioLensExportFormat {
  har('har', 'application/json'),

  json('json', 'application/json');

  const DioLensExportFormat(this.extension, this.mimeType);

  final String extension;
  final String mimeType;
}
