import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/enums/export_format.dart';

/// An export of captured requests, built in memory and handed to the
/// app's `onExport` callback. Dio Lens never writes it anywhere: save,
/// share or upload it as the app sees fit.
class DioLensExportFile {
  const DioLensExportFile({
    required this.format,
    required this.fileName,
    required this.bytes,
    required this.requestCount,
    required this.createdAt,
  });

  final DioLensExportFormat format;

  /// Suggested name, e.g. `dio_lens_20261025_165401.har`.
  final String fileName;

  /// UTF-8 encoded content.
  final Uint8List bytes;

  /// Requests in the file.
  final int requestCount;

  final DateTime createdAt;

  String get mimeType => format.mimeType;

  /// [bytes] as text.
  String get text => utf8.decode(bytes);
}
