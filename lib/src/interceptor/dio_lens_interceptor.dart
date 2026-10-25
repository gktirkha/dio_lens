import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/runtime/dio_lens_runtime.dart';
import '../features/request_detail/domain/entities/request_detail_entity.dart';
import 'request_capture.dart';

/// Records every request made through the [Dio] it is added to, stores it
/// and shows the request-finished banner.
///
/// Add it last, so the recorded request carries the headers and body that
/// earlier interceptors added:
///
/// ```dart
/// dio.interceptors.add(DioLensInterceptor(dio));
/// ```
///
/// Passing the [Dio] lets Replay re-send requests through it, so the app's
/// own interceptors (auth, refresh) and adapter apply; without it, replays
/// go through a plain Dio.
///
/// Does nothing until `DioLens.init` is called, or when Dio Lens is
/// disabled. Never changes or delays a request, and a capture failure never
/// reaches the app.
class DioLensInterceptor extends Interceptor {
  DioLensInterceptor([this._dio]);

  final Dio? _dio;

  /// The pending capture, once it is in the store.
  static const String _captureKey = 'dio_lens_capture';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _guard(() {
      final runtime = DioLensRuntime.current;
      if (runtime == null || !runtime.enabled) return;
      final store = runtime.store;
      final id = runtime.nextRequestId();
      if (_dio case final dio?) runtime.replayer.register(id, dio);
      final capture =
          RequestCapture.pending(
            id: id,
            startedAt: DateTime.now(),
            options: options,
            maxBodyBytes: store.settings.value.maxBodyBytes,
          ).then((request) async {
            await store.add(request);
            return request;
          });
      options.extra[_captureKey] = capture;
      capture.then<void>((_) {}, onError: _log);
    });
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final finishedAt = DateTime.now();
    _guard(
      () => _finish(
        response.requestOptions,
        finishedAt: finishedAt,
        response: response,
      ),
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final finishedAt = DateTime.now();
    _guard(
      () => _finish(
        err.requestOptions,
        finishedAt: finishedAt,
        response: err.response,
        error: err,
      ),
    );
    handler.next(err);
  }

  /// Completes the capture started in [onRequest], in the background: a
  /// response (even an error status) completes it; an error without one
  /// fails it.
  void _finish(
    RequestOptions options, {
    required DateTime finishedAt,
    Response<dynamic>? response,
    DioException? error,
  }) {
    final runtime = DioLensRuntime.current;
    if (runtime == null || !runtime.enabled) return;
    final capture = options.extra[_captureKey];
    if (capture is! Future<RequestDetailEntity>) return;

    Future<void> finish() async {
      final request = await capture;
      final store = runtime.store;
      final finished = response != null
          ? await RequestCapture.completed(
              request,
              response,
              finishedAt: finishedAt,
              maxBodyBytes: store.settings.value.maxBodyBytes,
            )
          : RequestCapture.failed(request, error!, finishedAt: finishedAt);
      await store.update(finished);

      final settings = store.settings.value;
      if (settings.showNotification) {
        runtime.banner.show(
          finished,
          duration: settings.notificationDuration,
          position: settings.notificationPosition,
        );
      }
    }

    finish().catchError(_log);
  }

  static void _guard(VoidCallback capture) {
    try {
      capture();
    } catch (error, stack) {
      _log(error, stack);
    }
  }

  static void _log(Object error, StackTrace stack) =>
      debugPrint('DioLens: could not capture request: $error\n$stack');
}
