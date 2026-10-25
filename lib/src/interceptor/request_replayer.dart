import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../features/request_detail/domain/entities/request_detail_entity.dart';
import 'dio_lens_interceptor.dart';

class RequestReplayer {
  final LinkedHashMap<String, Dio> _clients = LinkedHashMap();

  final LinkedHashMap<String, RequestOptions> _originals = LinkedHashMap();

  final Map<String, Dio> _named = {};

  final LinkedHashSet<Dio> _knownClients = LinkedHashSet.identity();

  late final Dio _fallback = () {
    final dio = Dio();
    dio.interceptors.add(DioLensInterceptor(dio: dio));
    return dio;
  }();

  static const int maxRemembered = 10000;

  static const int maxOriginals = 100;

  void register(
    String requestId,
    Dio dio, {
    RequestOptions? options,
    String? name,
  }) {
    _clients[requestId] = dio;
    if (name != null) _named[name] = dio;
    if (options != null) _originals[requestId] = options;
    _knownClients
      ..remove(dio)
      ..add(dio);
    if (_clients.length > maxRemembered) _clients.remove(_clients.keys.first);
    if (_originals.length > maxOriginals) {
      _originals.remove(_originals.keys.first);
    }
  }

  String? unavailableReason(RequestDetailEntity request) {
    if (_originals.containsKey(request.id)) return null;
    if (request.hasFileUpload) return "the file upload wasn't captured";
    if (request.requestBodyIncomplete) {
      return "the request body wasn't fully captured";
    }
    return null;
  }

  Dio _clientFor(RequestDetailEntity request) {
    if (_clients[request.id] case final dio?) return dio;
    if (_named[request.clientName] case final dio?) return dio;
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

  static RequestOptions _copyOf(RequestOptions original) => original.copyWith(
    data: switch (original.data) {
      final FormData form => form.clone(),
      final data => data,
    },
    headers: Map.of(original.headers),
    extra: Map.of(original.extra),
    cancelToken: CancelToken(),
    onSendProgress: (_, _) {},
    onReceiveProgress: (_, _) {},
  );

  Future<void> replay(RequestDetailEntity request) async {
    if (unavailableReason(request) case final reason?) {
      debugPrint("DioLens: can't replay ${request.uri}: $reason");
      return;
    }
    final dio = _clientFor(request);
    if (_originals[request.id] case final original?) {
      try {
        await dio.fetch<dynamic>(_copyOf(original));
      } on DioException catch (error) {
        debugPrint('DioLens: replay of ${request.uri} failed: ${error.type}');
      }
      return;
    }
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
