import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../features/request_detail/domain/entities/request_detail_entity.dart';
import 'dio_lens_interceptor.dart';

/// Re-sends captured requests: the original request when it is from this run,
/// otherwise a rebuild from what was captured, through the right Dio.
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

  /// Most remembered request to Dio links; the oldest are forgotten.
  static const int maxRemembered = 10000;

  /// Most original requests kept for exact replays.
  static const int maxOriginals = 100;

  /// Remembers that the request went through a Dio, its original options and
  /// the Dio's name.
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

  /// Why the request can't be replayed faithfully, or null when it can.
  String? unavailableReason(RequestDetailEntity request) =>
      unavailableReasonFor(
        request.id,
        hasFileUpload: request.hasFileUpload,
        requestBodyIncomplete: request.requestBodyIncomplete,
      );

  /// Why the request [id] can't be replayed faithfully, from its capture
  /// flags; null when it can. Works from a list row, without the full request.
  String? unavailableReasonFor(
    String id, {
    required bool hasFileUpload,
    required bool requestBodyIncomplete,
  }) {
    if (_originals.containsKey(id)) return null;
    if (hasFileUpload) return "the file upload wasn't captured";
    if (requestBodyIncomplete) {
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

  /// Sends the request again; any status or error is captured like a normal
  /// request.
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
