import 'dart:convert';

import 'package:dio/dio.dart' show DioExceptionType;

import '../../../../core/enums/request_state.dart';
import '../../../request_home/data/data_sources/request_home_data_source.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import '../../domain/entities/request_detail_entity.dart';
import 'request_detail_data_source.dart';

class RequestDetailMockDataSource implements RequestDetailDataSource {
  const RequestDetailMockDataSource(this._requests);

  final RequestHomeDataSource _requests;

  @override
  Stream<RequestDetailEntity?> watchRequest(String id) =>
      _requests.watchRequests().map((all) {
        for (final r in all) {
          if (r.id == id) return detailFor(r);
        }
        return null;
      }).distinct();

  static RequestDetailEntity detailFor(RequestListItemEntity r) {
    final requestBody = _requestBody(r);
    final responseBody = r.state == RequestState.completed
        ? _responseBody(r)
        : null;
    final failed = r.state == RequestState.failed;

    return RequestDetailEntity(
      id: r.id,
      method: r.method,
      uri: r.uri,
      startedAt: r.startedAt,
      state: r.state,
      statusCode: r.statusCode,
      duration: r.duration,
      protocol: 'HTTP/2',
      requestSize: requestBody == null ? 0 : _encode(requestBody, r).length,
      responseSize: r.responseSize,
      requestContentType: r.requestContentType,
      responseContentType: r.responseContentType,
      requestHeaders: {
        if (r.requestContentType != null) 'Content-Type': r.requestContentType!,
        'Accept': 'application/json',
        if (r.host.startsWith('api.'))
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0MiJ9.sig',
        'User-Agent': 'Dio/5.11.1 (Flutter)',
      },
      responseHeaders: r.state == RequestState.completed
          ? {
              if (r.responseContentType != null)
                'Content-Type': r.responseContentType!,
              'X-Request-Id': 'req_${r.id.hashCode.toRadixString(16)}',
              'Cache-Control': 'no-store',
            }
          : const {},
      requestBody: requestBody,
      responseBody: responseBody,
      errorType: r.errorType,
      errorMessage: failed ? _errorMessage(r) : null,
      stackTrace: failed
          ? 'DioException [${r.errorType?.name}]: ${_errorMessage(r)}\n'
                '#0      DioMixin.fetch (package:dio/src/dio_mixin.dart:509)\n'
                '#1      ApiClient.${_camel(r.path)} (package:app/api_client.dart:88)\n'
                '#2      SyncService.run (package:app/sync_service.dart:41)'
          : null,
    );
  }

  static Object? _requestBody(RequestListItemEntity r) {
    final type = r.requestContentType ?? '';
    if (type.contains('x-www-form-urlencoded')) {
      return const {
        'username': 'ava',
        'password': '••••••••',
        'grant_type': 'password',
      };
    }
    if (!type.contains('json')) return null;
    return switch (r.method) {
      'QUERY' => const {
        'filter': {
          'status': ['shipped', 'processing'],
          'minTotal': 50,
        },
        'sort': '-createdAt',
        'limit': 20,
      },
      'PATCH' => const {'theme': 'dark', 'notifications': false},
      _ => const {'name': 'Ava Patel', 'bio': 'Mobile engineer'},
    };
  }

  static Object? _responseBody(RequestListItemEntity r) {
    final type = r.responseContentType ?? '';
    if (type.startsWith('text/')) return 'OK';
    if (!type.contains('json')) return null;
    final code = r.statusCode ?? 200;
    if (code >= 400) {
      return {
        'error': code >= 500 ? 'internal_error' : 'forbidden',
        'message': code >= 500
            ? 'Upstream service unavailable'
            : 'You do not have access to this resource',
      };
    }
    if (r.path.contains('/auth/')) {
      return const {
        'access_token': 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0MiJ9.sig',
        'token_type': 'Bearer',
        'expires_in': 3600,
      };
    }
    if (r.path.contains('/orders')) {
      return const {
        'data': [
          {'id': 5031, 'status': 'shipped', 'total': 212.4},
          {'id': 5030, 'status': 'processing', 'total': 76.0},
        ],
        'meta': {'page': 2, 'limit': 20},
      };
    }
    return const {
      'data': [
        {'id': 1, 'name': 'Ava Patel', 'email': 'ava@example.com'},
        {'id': 2, 'name': 'Liam Chen', 'email': 'liam@example.com'},
      ],
      'meta': {'total': 2},
    };
  }

  static String _encode(Object body, RequestListItemEntity r) {
    if (body is String) return body;
    if ((r.requestContentType ?? '').contains('x-www-form-urlencoded') &&
        body is Map) {
      return body.entries.map((e) => '${e.key}=${e.value}').join('&');
    }
    return jsonEncode(body);
  }

  static String _errorMessage(RequestListItemEntity r) => switch (r.errorType) {
    DioExceptionType.connectionTimeout =>
      'The request connection took longer than 0:00:30.000000 and it '
          'was aborted.',
    DioExceptionType.receiveTimeout =>
      'The request took longer than 0:01:00.000000 to receive data.',
    DioExceptionType.connectionError =>
      'The connection errored: Connection refused.',
    _ => 'The request failed.',
  };

  static String _camel(String path) {
    final words = path
        .split(RegExp(r'[/\-_.]'))
        .where((w) => w.isNotEmpty && !RegExp(r'^v\d+$').hasMatch(w))
        .toList();
    if (words.isEmpty) return 'request';
    return words.first +
        words.skip(1).map((w) => w[0].toUpperCase() + w.substring(1)).join();
  }
}
