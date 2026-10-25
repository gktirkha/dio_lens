import 'dart:convert';
import 'dart:typed_data';

import '../../../../core/enums/export_format.dart';

class DioLensExportFile {
  const DioLensExportFile({
    required this.format,
    required this.fileName,
    required this.bytes,
    required this.requestCount,
    required this.createdAt,
  });

  final DioLensExportFormat format;

  final String fileName;

  final Uint8List bytes;

  final int requestCount;

  final DateTime createdAt;

  String get mimeType => format.mimeType;

  String get text => utf8.decode(bytes);
}
