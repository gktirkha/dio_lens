import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../features/request_detail/domain/entities/request_detail_entity.dart';
import 'dio_lens_interceptor.dart';

class RequestReplayer {
  final LinkedHashMap<String, Dio> _clients = LinkedHashMap();

  final LinkedHashSet<Dio> _knownClients = LinkedHashSet.identity();

  late final Dio _fallback = () {
    final dio = Dio();
    dio.interceptors.add(DioLensInterceptor(dio));
    return dio;
  }();

  static const int maxRemembered = 10000;

  void register(String requestId, Dio dio) {
    _clients[requestId] = dio;
    _knownClients
      ..remove(dio)
      ..add(dio);
    if (_clients.length > maxRemembered) _clients.remove(_clients.keys.first);
  }

  Dio _clientFor(RequestDetailEntity request) {
    if (_clients[request.id] case final dio?) return dio;
    final uri = request.uri;
    for (final dio in _knownClients.toList().reversed) {
      final base = Uri.tryParse(dio.options.baseUrl);
      if (base == null || base.host.isEmpty) continue;
      if (base.host.toLowerCase() == uri.host.toLowerCase() &&
          base.scheme == uri.scheme) {
        return dio;
      }
    }
    return _fallback;
  }

  Future<void> replay(RequestDetailEntity request) async {
    final dio = _clientFor(request);
    final contentType = (request.requestContentType ?? '').toLowerCase();
    final multipart = contentType.contains('multipart/form-data');
    final body = request.requestBody;
    final headers = {
      for (final e in request.requestHeaders.entries)
        if (e.key.toLowerCase() != Headers.contentLengthHeader &&
            !(multipart && e.key.toLowerCase() == Headers.contentTypeHeader))
          e.key: e.value,
    };
    try {
      await dio.requestUri<dynamic>(
        request.uri,
        data: multipart && body is Map
            ? FormData.fromMap(Map<String, dynamic>.from(body))
            : body,
        options: Options(
          method: request.method,
          headers: headers,
          contentType: multipart ? null : request.requestContentType,
          responseType:
              (request.responseContentType ?? '').toLowerCase().startsWith(
                'image/',
              )
              ? ResponseType.bytes
              : null,
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (error) {
      debugPrint('DioLens: replay of ${request.uri} failed: ${error.type}');
    }
  }
}
