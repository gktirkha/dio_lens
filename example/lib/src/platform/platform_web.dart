import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:web/web.dart' as web;

/// The browser checks certificates itself, so nothing can be pinned; this Dio
/// calls a host with an expired certificate instead, which the browser
/// rejects.
Dio createPinnedDio(String baseUrl) =>
    Dio(BaseOptions(baseUrl: 'https://expired.badssl.com'));

/// Downloads [export] (HAR and JSON are both JSON) through the browser and returns its file name.
Future<String> saveExportFile(DioLensExportFile export) async {
  final blob = web.Blob(
    [export.bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);
  web.HTMLAnchorElement()
    ..href = url
    ..download = export.fileName
    ..click();
  web.URL.revokeObjectURL(url);
  return export.fileName;
}
