import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/models/console_logger_settings.dart';
import '../features/settings/domain/entities/dio_lens_settings.dart';
import '../features/settings/domain/utils/request_redactor.dart';

/// Console logger for Dio requests similar to pretty_dio_logger.
class DioLensConsoleLogger {
  /// Creates a console logger.
  DioLensConsoleLogger({
    ConsoleLoggerSettings? settings,
    void Function(Object)? logPrint,
  }) : _settings = settings ?? const ConsoleLoggerSettings(),
       logPrint = logPrint ?? ((Object o) => debugPrint(o.toString()));

  final ConsoleLoggerSettings _settings;

  /// Log printer function used to output logs.
  final void Function(Object object) logPrint;

  static const String _timeStampKey = '_dio_lens_timeStamp_';

  /// Initial tab count for pretty printing.
  static const int kInitialTab = 1;

  /// Tab step for indentation.
  static const String tabStep = '    ';

  /// Logs a request.
  void logRequest(RequestOptions options, DioLensSettings dioSettings) {
    if (!_settings.enabled || !_settings.request) return;

    final stateLabel = _settings.showStateInHeader ? '[REQUEST]' : '';
    _printBoxed(
      header: '$stateLabel ║ ${options.method} ',
      text: options.uri.toString(),
    );

    if (_settings.requestHeader) {
      final queryParams = <String, dynamic>{};
      options.queryParameters.forEach((key, value) {
        queryParams[key] = dioSettings.isQueryParamRedacted(key)
            ? RequestRedactor.mask
            : value;
      });
      if (queryParams.isNotEmpty) {
        _printMapAsTable(queryParams, header: '[REQUEST] ║ Query Parameters');
      }

      final reqHeaders = <String, dynamic>{};
      options.headers.forEach((key, value) {
        if (value == null) return;
        reqHeaders[key] = dioSettings.isHeaderRedacted(key)
            ? RequestRedactor.mask
            : value;
      });
      reqHeaders['responseType'] = options.responseType.toString();
      reqHeaders['followRedirects'] = options.followRedirects;
      if (options.connectTimeout != null) {
        reqHeaders['connectTimeout'] = options.connectTimeout?.toString();
      }
      if (options.receiveTimeout != null) {
        reqHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
      }

      _printMapAsTable(reqHeaders, header: '[REQUEST] ║ Headers');
      if (options.extra.isNotEmpty) {
        final extra = Map<String, dynamic>.from(options.extra)
          ..remove(_timeStampKey)
          ..remove('dio_lens_capture');
        if (extra.isNotEmpty) {
          _printMapAsTable(extra, header: 'Extras');
        }
      }
    }

    if (_settings.requestBody && options.data != null) {
      final dynamic data = options.data;
      if (data is Map) {
        final redacted = _redactMap(data, dioSettings);
        _printMapAsTable(redacted, header: 'Request Body');
      } else if (data is FormData) {
        final formDataMap = <String, dynamic>{
          ...Map.fromEntries(
            data.fields.map(
              (e) => MapEntry(
                e.key,
                dioSettings.isHeaderRedacted(e.key) ||
                        dioSettings.isQueryParamRedacted(e.key)
                    ? RequestRedactor.mask
                    : e.value,
              ),
            ),
          ),
          ...Map.fromEntries(
            data.files.map(
              (e) => MapEntry(
                e.key,
                '${e.value.filename ?? 'file'} (${e.value.length} bytes)',
              ),
            ),
          ),
        };
        _printMapAsTable(formDataMap, header: 'Form data | ${data.boundary}');
      } else {
        logPrint('╔ Unknown Form ');
        _printBlock(_redactString(data.toString(), dioSettings));
        _printLine('╚');
      }
    }
  }

  /// Logs a response.
  void logResponse(Response response, DioLensSettings dioSettings) {
    if (!_settings.enabled) return;
    if (!_settings.responseBody && !_settings.responseHeader) return;

    final stateLabel = _settings.showStateInHeader ? '[RESPONSE]' : '';
    _printBoxed(
      header:
          '$stateLabel ║ ${response.requestOptions.method} ║ Status: ${response.statusCode} ${response.statusMessage ?? ''}  ║ Time: ${_calculateTimeDifference(response.requestOptions.extra)} ms',
      text: response.requestOptions.uri.toString(),
    );

    if (_settings.responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers.map.forEach((k, v) {
        responseHeaders[k] = dioSettings.isHeaderRedacted(k)
            ? RequestRedactor.mask
            : v.toString();
      });
      if (responseHeaders.isNotEmpty) {
        _printMapAsTable(responseHeaders, header: '[RESPONSE] ║ Headers');
      }
    }

    if (_settings.responseBody) {
      logPrint('╔ [RESPONSE] ║ Body');
      logPrint('║');
      _printResponse(response, dioSettings);
      logPrint('║');
      _printLine('╚');
    }
  }

  /// Logs an error.
  void logError(DioException err, DioLensSettings dioSettings) {
    if (!_settings.enabled || !_settings.error) return;

    if (err.type == DioExceptionType.badResponse) {
      final response = err.response;
      final uri = response?.requestOptions.uri;
      final stateLabel = _settings.showStateInHeader ? '[ERROR]' : '';
      _printBoxed(
        header:
            '$stateLabel DioError ║ Status: ${response?.statusCode} ${response?.statusMessage ?? ''} ║ Time: ${_calculateTimeDifference(err.requestOptions.extra)} ms',
        text: uri.toString(),
      );

      if (response?.data != null && _settings.responseBody) {
        logPrint('╔ ${err.type.toString()}');
        _printResponse(response!, dioSettings);
        _printLine('╚');

        if (_settings.responseHeader && response.headers.map.isNotEmpty) {
          final responseHeaders = <String, String>{};
          response.headers.map.forEach((k, v) {
            responseHeaders[k] = dioSettings.isHeaderRedacted(k)
                ? RequestRedactor.mask
                : v.toString();
          });
          _printMapAsTable(responseHeaders, header: 'Response Headers');
        }
      } else {
        logPrint('╔ ${err.type.toString()}');
        if (err.message != null) {
          _printBlock(_redactString(err.message!, dioSettings));
        }
        _printLine('╚');
      }
    } else {
      final stateLabel = _settings.showStateInHeader ? '[ERROR]' : '';
      _printBoxed(
        header: '$stateLabel DioError ║ ${err.type}',
        text: err.message,
      );
      if (err.response?.data != null && _settings.responseBody) {
        logPrint('╔ Body');
        logPrint('║');
        _printResponse(err.response!, dioSettings);
        logPrint('║');
        _printLine('╚');
      }
    }
  }

  Map<String, dynamic> _redactMap(Map data, DioLensSettings settings) {
    final result = <String, dynamic>{};
    data.forEach((key, value) {
      if (value is Map) {
        result[key.toString()] = _redactMap(value, settings);
      } else if (value is List) {
        result[key.toString()] = _redactList(value, settings);
      } else if (settings.isHeaderRedacted(key.toString()) ||
          settings.isQueryParamRedacted(key.toString())) {
        result[key.toString()] = RequestRedactor.mask;
      } else {
        result[key.toString()] = value;
      }
    });
    return result;
  }

  List _redactList(List list, DioLensSettings settings) {
    final result = [];
    for (final item in list) {
      if (item is Map) {
        result.add(_redactMap(item, settings));
      } else if (item is List) {
        result.add(_redactList(item, settings));
      } else {
        result.add(item);
      }
    }
    return result;
  }

  String _redactString(String text, DioLensSettings settings) {
    var result = text;
    for (final key in settings.redactedHeaders) {
      final pattern = RegExp('"$key"\\s*:\\s*"([^"]+)"', caseSensitive: false);
      result = result.replaceAllMapped(
        pattern,
        (m) => '"$key": "${RequestRedactor.mask}"',
      );
    }
    for (final key in settings.redactedQueryParams) {
      final pattern = RegExp('"$key"\\s*:\\s*"([^"]+)"', caseSensitive: false);
      result = result.replaceAllMapped(
        pattern,
        (m) => '"$key": "${RequestRedactor.mask}"',
      );
    }
    return result;
  }

  int _calculateTimeDifference(Map<String, dynamic> extra) {
    final triggerTime = extra[_timeStampKey];
    if (triggerTime is int) {
      return DateTime.now().millisecondsSinceEpoch - triggerTime;
    }
    return 0;
  }

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    _printLine('╚');
  }

  void _printResponse(Response response, DioLensSettings settings) {
    final dynamic data = response.data;
    if (data == null) return;

    if (data is Map) {
      _printPrettyMap(_redactMap(data, settings));
    } else if (data is Uint8List) {
      logPrint('║${_indent()}[');
      logPrint('║${_indent()}[bytes: ${data.length}]');
      logPrint('║${_indent()}]');
    } else if (data is List) {
      logPrint('║${_indent()}[');
      _printList(_redactList(data, settings));
      logPrint('║${_indent()}]');
    } else {
      _printBlock(_redactString(data.toString(), settings));
    }
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * _settings.maxWidth}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > _settings.maxWidth) {
      logPrint(pre);
      _printBlock(msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;

    final Map cleanMap = Map.from(map)..remove(_timeStampKey);
    if (cleanMap.isEmpty) return;

    logPrint('╔ $header ');
    for (final entry in cleanMap.entries) {
      _printKV(entry.key.toString(), entry.value);
    }
    _printLine('╚');
  }

  void _printBlock(String msg) {
    final lines = (msg.length / _settings.maxWidth).ceil();
    if (lines == 0) return;
    for (var i = 0; i < lines; ++i) {
      final start = i * _settings.maxWidth;
      final end = math.min(start + _settings.maxWidth, msg.length);
      logPrint('║ ${msg.substring(start, end)}');
    }
  }

  String _indent([int tabCount = kInitialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int initialTab = kInitialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var tabs = initialTab;
    final isRoot = tabs == kInitialTab;
    final initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    final keys = data.keys.toList();
    for (var index = 0; index < keys.length; index++) {
      final isLastItem = index == keys.length - 1;
      final rawKey = keys[index];
      final key = '"$rawKey"';
      dynamic value = data[rawKey];

      if (value is String) {
        value = '"${value.replaceAll(RegExp(r'[\r\n]+'), " ")}"';
      }

      final suffix = isLastItem ? '' : ',';

      if (value is Map) {
        if (_settings.compact && _canFlattenMap(value)) {
          logPrint('║${_indent(tabs)} $key: $value$suffix');
        } else {
          logPrint('║${_indent(tabs)} $key: {');
          _printPrettyMap(value, initialTab: tabs);
          logPrint('║${_indent(tabs)} }$suffix');
        }
      } else if (value is List) {
        if (_settings.compact && _canFlattenList(value)) {
          logPrint('║${_indent(tabs)} $key: $value$suffix');
        } else {
          logPrint('║${_indent(tabs)} $key: [');
          _printList(value, tabs: tabs);
          logPrint('║${_indent(tabs)} ]$suffix');
        }
      } else {
        _printValue(key, value.toString().replaceAll('\n', ''), tabs, suffix);
      }
    }

    logPrint('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printValue(String key, String msg, int tabs, String suffix) {
    final indent = _indent(tabs);
    final linWidth = _settings.maxWidth - indent.length;
    if (msg.length + indent.length > linWidth && linWidth > 10) {
      final lines = (msg.length / linWidth).ceil();
      for (var i = 0; i < lines; ++i) {
        final multilineKey = i == 0 ? '$key:' : '';
        final start = i * linWidth;
        final end = math.min(start + linWidth, msg.length);
        logPrint('║$indent $multilineKey ${msg.substring(start, end)}');
      }
    } else {
      logPrint('║$indent $key: $msg$suffix');
    }
  }

  void _printList(List list, {int tabs = kInitialTab}) {
    for (var i = 0; i < list.length; i++) {
      final element = list[i];
      final isLast = i == list.length - 1;
      final suffix = isLast ? '' : ',';

      if (element is Map) {
        if (_settings.compact && _canFlattenMap(element)) {
          logPrint('║${_indent(tabs)}  $element$suffix');
        } else {
          _printPrettyMap(
            element,
            initialTab: tabs + 1,
            isListItem: true,
            isLast: isLast,
          );
        }
      } else if (element is List) {
        logPrint('║${_indent(tabs + 2)} [');
        _printList(element, tabs: tabs + 2);
        logPrint('║${_indent(tabs + 2)} ]$suffix');
      } else {
        logPrint('║${_indent(tabs + 2)} $element$suffix');
      }
    }
  }

  bool _canFlattenMap(Map map) {
    return !map.values.any((val) => val is Map || val is List) &&
        map.toString().length < _settings.maxWidth;
  }

  bool _canFlattenList(List list) {
    return list.length < 10 && list.toString().length < _settings.maxWidth;
  }
}
