import 'package:dio/dio.dart' show DioExceptionType;
import 'package:dio_lens/src/core/enums/request_state.dart';
import 'package:dio_lens/src/features/request_detail/domain/entities/request_detail_entity.dart';

/// A captured request with sensible defaults.
RequestDetailEntity request(
  String id, {
  String method = 'GET',
  String url = 'https://api.example.com/v1/orders',
  DateTime? startedAt,
  Duration ago = Duration.zero,
  RequestState state = RequestState.completed,
  int? statusCode = 200,
  Duration? duration = const Duration(milliseconds: 96),
  Map<String, String> requestHeaders = const {},
  Map<String, String> responseHeaders = const {},
  Object? requestBody,
  Object? responseBody,
  String? requestContentType,
  String? responseContentType,
  int? responseSize,
  DioExceptionType? errorType,
  String? errorMessage,
  String? stackTrace,
}) => RequestDetailEntity(
  id: id,
  method: method,
  uri: Uri.parse(url),
  startedAt: startedAt ?? DateTime.now().subtract(ago),
  state: state,
  statusCode: state == RequestState.completed ? statusCode : null,
  duration: state == RequestState.pending ? null : duration,
  requestHeaders: requestHeaders,
  responseHeaders: responseHeaders,
  requestBody: requestBody,
  responseBody: responseBody,
  requestContentType: requestContentType,
  responseContentType: responseContentType,
  responseSize: responseSize,
  errorType: errorType,
  errorMessage: errorMessage,
  stackTrace: stackTrace,
);
