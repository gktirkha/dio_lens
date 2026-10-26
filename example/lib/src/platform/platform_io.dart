import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_lens/dio_lens.dart';

/// A Dio that pins a certificate no server has, so every TLS handshake is
/// rejected.
Dio createPinnedDio(String baseUrl) => Dio(BaseOptions(baseUrl: baseUrl))
  ..httpClientAdapter = IOHttpClientAdapter(
    validateCertificate: (_, _, _) => false,
  );

/// Saves [export] in the temp folder and returns where.
Future<String> saveExportFile(DioLensExportFile export) async {
  final file = File('${Directory.systemTemp.path}/${export.fileName}');
  await file.writeAsBytes(export.bytes);
  return file.path;
}
