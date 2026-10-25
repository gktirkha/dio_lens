import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../features/request_detail/domain/entities/request_detail_entity.dart';
import 'dio_lens_interceptor.dart';

/// Re-sends captured requests, through the app's own [Dio] when known, so
/// its interceptors (auth, refresh), adapter and base options apply. The
/// replay is captured as a new request.
class RequestReplayer {
  /// The Dio each request of this run went through (see
  /// `DioLensInterceptor(dio)`), oldest first.
  final LinkedHashMap<String, Dio> _clients = LinkedHashMap();

  /// Most recently registered Dio: replays requests from earlier runs.
  Dio? _lastClient;

  /// Used when the app never passed a Dio to the interceptor.
  late final Dio _fallback = () {
    final dio = Dio();
    // Passes itself, so it never triggers the missing-Dio warning.
    dio.interceptors.add(DioLensInterceptor(dio));
    return dio;
  }();

  /// Most remembered request → Dio links; the oldest are forgotten.
  static const int maxRemembered = 10000;

  /// Remembers that the request [requestId] went through [dio].
  void register(String requestId, Dio dio) {
    _clients[requestId] = dio;
    _lastClient = dio;
    if (_clients.length > maxRemembered) _clients.remove(_clients.keys.first);
  }

  /// Sends [request] again. Completes once it finished; any status or
  /// error is captured like a normal request, never thrown.
  Future<void> replay(RequestDetailEntity request) async {
    final dio = _clients[request.id] ?? _lastClient ?? _fallback;
    final contentType = (request.requestContentType ?? '').toLowerCase();
    final multipart = contentType.contains('multipart/form-data');
    final body = request.requestBody;
    final headers = {
      for (final e in request.requestHeaders.entries)
        // Dio recomputes the length, and a multipart boundary is new.
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
      // Already captured by the interceptor; nothing to report here.
      debugPrint('DioLens: replay of ${request.uri} failed: ${error.type}');
    }
  }
}
