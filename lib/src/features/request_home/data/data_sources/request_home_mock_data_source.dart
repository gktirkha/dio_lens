import 'dart:async';

import '../../../../core/enums/request_state.dart';
import '../../domain/entities/request_list_item_entity.dart';
import 'request_home_data_source.dart';

/// In-memory [RequestHomeDataSource] seeded with sample traffic.
///
/// Stand-in until the Dio interceptor feeds a real store.
///
/// Lazy: the seed list and the change stream are only created on first use.
class RequestHomeMockDataSource implements RequestHomeDataSource {
  RequestHomeMockDataSource({List<RequestListItemEntity> Function()? seed})
    : _seed = seed ?? sampleRequests;

  final List<RequestListItemEntity> Function() _seed;

  /// Newest first.
  late final List<RequestListItemEntity> _requests = List.of(_seed());

  StreamController<List<RequestListItemEntity>>? _changesController;
  StreamController<List<RequestListItemEntity>> get _changes =>
      _changesController ??= StreamController.broadcast();

  List<RequestListItemEntity> get _snapshot => List.unmodifiable(_requests);

  void _notify() => _changes.add(_snapshot);

  @override
  Stream<List<RequestListItemEntity>> watchRequests() async* {
    yield _snapshot;
    yield* _changes.stream;
  }

  @override
  Future<List<RequestListItemEntity>> getRequests() async => _snapshot;

  @override
  Future<void> deleteRequest(String id) async {
    final before = _requests.length;
    _requests.removeWhere((r) => r.id == id);
    if (_requests.length != before) _notify();
  }

  @override
  Future<void> clearAll() async {
    if (_requests.isEmpty) return;
    _requests.clear();
    _notify();
  }

  /// Closes the change stream; the data source can't be used afterwards.
  Future<void> dispose() async => _changesController?.close();

  /// Realistic mix of methods, status classes, a pending request and
  /// failures, newest first.
  static List<RequestListItemEntity> sampleRequests({DateTime? now}) {
    final at = now ?? DateTime.now();
    var n = 0;
    RequestListItemEntity item(
      String method,
      String url,
      RequestState state, {
      int? code,
      int? ms,
      int? size,
      String? error,
      String? reqCt,
      String? resCt,
      Duration ago = Duration.zero,
    }) {
      n++;
      return RequestListItemEntity(
        id: 'mock-$n',
        method: method,
        uri: Uri.parse(url),
        startedAt: at.subtract(ago),
        state: state,
        statusCode: code,
        duration: ms == null ? null : Duration(milliseconds: ms),
        responseSize: size,
        errorType: error,
        requestContentType: reqCt,
        responseContentType:
            resCt ??
            (state == RequestState.completed && (size ?? 0) > 0
                ? (url.endsWith('.jpg') ? 'image/jpeg' : 'application/json')
                : null),
      );
    }

    return [
      item(
        'GET',
        'https://api.example.com/v1/notifications',
        RequestState.pending,
      ),
      item(
        'GET',
        'https://api.example.com/v1/users',
        RequestState.completed,
        code: 200,
        ms: 182,
        size: 2140,
        ago: const Duration(seconds: 5),
      ),
      item(
        'POST',
        'https://api.example.com/v1/auth/login',
        RequestState.completed,
        reqCt: 'application/x-www-form-urlencoded',
        code: 200,
        ms: 341,
        size: 612,
        ago: const Duration(seconds: 20),
      ),
      item(
        'GET',
        'https://api.example.com/v1/orders?page=2&limit=20',
        RequestState.completed,
        code: 200,
        ms: 96,
        size: 1860,
        ago: const Duration(seconds: 40),
      ),
      item(
        'QUERY',
        'https://api.example.com/v1/orders/search',
        RequestState.completed,
        code: 200,
        ms: 134,
        size: 248,
        reqCt: 'application/json',
        ago: const Duration(seconds: 50),
      ),
      item(
        'GET',
        'https://cdn.example.com/images/avatar-42.jpg',
        RequestState.completed,
        code: 200,
        ms: 64,
        size: 18400,
        ago: const Duration(minutes: 2),
      ),
      item(
        'GET',
        'https://api.example.com/v1/payments/intent',
        RequestState.completed,
        code: 500,
        ms: 812,
        size: 188,
        ago: const Duration(minutes: 3),
      ),
      item(
        'GET',
        'https://api.example.com/v1/sync',
        RequestState.failed,
        ms: 30000,
        error: 'connectionTimeout',
        ago: const Duration(minutes: 6),
      ),
      item(
        'PUT',
        'https://api.example.com/v1/profile',
        RequestState.completed,
        reqCt: 'application/json',
        code: 200,
        ms: 228,
        size: 540,
        ago: const Duration(minutes: 12),
      ),
      item(
        'DELETE',
        'https://api.example.com/v1/cart/items/88',
        RequestState.completed,
        code: 204,
        ms: 143,
        size: 0,
        ago: const Duration(minutes: 25),
      ),
      item(
        'GET',
        'https://api.example.com/v1/search?q=sneakers&page=1',
        RequestState.completed,
        code: 301,
        ms: 51,
        size: 0,
        ago: const Duration(hours: 1),
      ),
      item(
        'PATCH',
        'https://api.example.com/v1/settings',
        RequestState.completed,
        reqCt: 'application/json',
        code: 403,
        ms: 77,
        size: 92,
        ago: const Duration(hours: 3),
      ),
      item(
        'GET',
        'https://api.example.com/v1/status',
        RequestState.completed,
        code: 200,
        ms: 22,
        size: 2,
        resCt: 'text/plain; charset=utf-8',
        ago: const Duration(hours: 4),
      ),
    ];
  }
}
