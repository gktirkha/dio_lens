import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/runtime/dio_lens_runtime.dart';
import 'request_capture.dart';

/// Records every request made through the [Dio] it is added to, stores it
/// and shows the request-finished banner.
///
/// Add it last, so the recorded request carries the headers and body that
/// earlier interceptors added:
///
/// ```dart
/// dio.interceptors.add(DioLensInterceptor());
/// ```
///
/// Does nothing until `DioLens.init` is called, or when Dio Lens is
/// disabled. Never changes or delays a request, and a capture failure never
/// reaches the app.
class DioLensInterceptor extends Interceptor {
  DioLensInterceptor();

  static const String _idKey = 'dio_lens_id';
  static const String _startedAtKey = 'dio_lens_started_at';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _guard(() {
      final runtime = DioLensRuntime.current;
      if (runtime == null || !runtime.enabled) return;
      final id = runtime.nextRequestId();
      final startedAt = DateTime.now();
      options.extra[_idKey] = id;
      options.extra[_startedAtKey] = startedAt;
      runtime.store.add(
        RequestCapture.pending(id: id, startedAt: startedAt, options: options),
      );
    });
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _guard(() => _finish(response.requestOptions, response: response));
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _guard(
      () => _finish(err.requestOptions, response: err.response, error: err),
    );
    handler.next(err);
  }

  /// Completes the capture started in [onRequest]: a response (even an
  /// error status) completes it; an error without one fails it.
  void _finish(
    RequestOptions options, {
    Response<dynamic>? response,
    DioException? error,
  }) {
    final runtime = DioLensRuntime.current;
    if (runtime == null || !runtime.enabled) return;
    final id = options.extra[_idKey];
    final startedAt = options.extra[_startedAtKey];
    if (id is! String || startedAt is! DateTime) return;

    final request = RequestCapture.pending(
      id: id,
      startedAt: startedAt,
      options: options,
    );
    final finished = response != null
        ? RequestCapture.completed(request, response)
        : RequestCapture.failed(request, error!);
    runtime.store.update(finished);

    final settings = runtime.store.settings.value;
    if (settings.showNotification) {
      runtime.banner.show(finished, duration: settings.notificationDuration);
    }
  }

  static void _guard(VoidCallback capture) {
    try {
      capture();
    } catch (error, stack) {
      debugPrint('DioLens: could not capture request: $error\n$stack');
    }
  }
}
