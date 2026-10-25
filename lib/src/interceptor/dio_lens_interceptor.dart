import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/models/console_logger_settings.dart';
import '../core/runtime/dio_lens_runtime.dart';
import '../features/request_detail/domain/entities/request_detail_entity.dart';
import '../features/settings/domain/entities/dio_lens_settings.dart';
import 'dio_lens_console_logger.dart';
import 'request_capture.dart';

/// Records every request made through the Dio it is added to, stores it and
/// shows the request-finished banner. Add it last; pass the Dio so Replay can
/// re-send through it, and a name to tell Dios with the same base URL apart.
///
/// Also provides console logging when enabled.
class DioLensInterceptor extends Interceptor {
  /// Creates the interceptor for an optional Dio and name.
  DioLensInterceptor({
    this._dio,
    this._name,
    ConsoleLoggerSettings? consoleLoggerSettings,
    void Function(Object)? logPrint,
  }) : _consoleLogger = DioLensConsoleLogger(
         settings: consoleLoggerSettings ?? const ConsoleLoggerSettings(),
         logPrint:
             logPrint ?? ((Object o) => log(o.toString(), name: 'dio_lens')),
       );

  final Dio? _dio;

  final String? _name;

  static const String _captureKey = 'dio_lens_capture';
  static const String _timeStampKey = '_dio_lens_timeStamp_';

  final DioLensConsoleLogger _consoleLogger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_timeStampKey] = DateTime.now().millisecondsSinceEpoch;

    final runtime = DioLensRuntime.current;
    final settings = runtime?.store.settings.value ?? const DioLensSettings();
    _consoleLogger.logRequest(options, settings);

    _guard(() {
      if (runtime == null || !runtime.enabled) return;
      final store = runtime.store;
      final id = runtime.nextRequestId();
      if (_dio case final dio?) {
        runtime.replayer.register(id, dio, options: options, name: _name);
      } else {
        _warnMissingDio();
      }
      final capture =
          RequestCapture.pending(
            id: id,
            startedAt: DateTime.now(),
            options: options,
            maxBodyBytes: store.settings.value.maxBodyBytes,
            clientName: _name,
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
    final runtime = DioLensRuntime.current;
    final settings = runtime?.store.settings.value ?? const DioLensSettings();
    _consoleLogger.logResponse(response, settings);
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
    final runtime = DioLensRuntime.current;
    final settings = runtime?.store.settings.value ?? const DioLensSettings();
    _consoleLogger.logError(err, settings);
    handler.next(err);
  }

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

  static bool _warnedMissingDio = false;

  static void _warnMissingDio() {
    if (_warnedMissingDio) return;
    _warnedMissingDio = true;
    debugPrint(
      'DioLens: DioLensInterceptor was added without its Dio, so Replay '
      'falls back to a plain Dio (your interceptors, base options and '
      'adapter will not apply). Pass the Dio to the interceptor:\n'
      '  dio.interceptors.add(DioLensInterceptor(dio: dio));',
    );
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
