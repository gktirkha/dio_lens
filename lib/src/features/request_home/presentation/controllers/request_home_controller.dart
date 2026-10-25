import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/domain/unit.dart';
import '../../../../core/utils/debouncer.dart';
import '../../domain/entities/request_filter_params.dart';
import '../../domain/entities/request_list_item_entity.dart';
import '../../domain/entities/request_status_filter.dart';
import '../../domain/use_cases/clear_all_requests_use_case.dart';
import '../../domain/use_cases/delete_request_use_case.dart';
import '../../domain/use_cases/remove_expired_requests_use_case.dart';
import '../../domain/use_cases/watch_requests_use_case.dart';

/// State of the request home page: the active filter and the requests that
/// match it. Lazy: nothing is watched until the first listener attaches.
class RequestHomeController extends ChangeNotifier {
  /// Creates the controller.
  RequestHomeController({
    required this._watchRequests,
    required this._deleteRequest,
    required this._clearAllRequests,
    required this._removeExpiredRequests,
  });

  final WatchRequestsUseCase _watchRequests;
  final DeleteRequestUseCase _deleteRequest;
  final ClearAllRequestsUseCase _clearAllRequests;
  final RemoveExpiredRequestsUseCase _removeExpiredRequests;

  /// Delay after the last keystroke before search re-filters the list.
  static const Duration searchDebounce = Duration(milliseconds: 250);

  final Debouncer _searchDebouncer = Debouncer(searchDebounce);

  StreamSubscription<List<RequestListItemEntity>>? _subscription;
  bool _started = false;

  RequestFilterParams _params = RequestFilterParams.none;

  /// The active filter.
  RequestFilterParams get params => _params;

  List<RequestListItemEntity> _requests = const [];

  /// Requests matching [params], newest first.
  List<RequestListItemEntity> get requests => _requests;

  bool _loading = true;

  /// True until the first result arrives.
  bool get isLoading => _loading;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (!_started) {
      _started = true;
      _removeExpiredRequests(unit);
      _subscribe();
    }
  }

  /// Shows only requests of [status].
  void setStatus(RequestStatusFilter status) =>
      _updateParams(_params.copyWith(status: status));

  /// Adds [method] to the method filter, or removes it.
  void toggleMethod(String method) {
    final methods = {..._params.methods};
    if (!methods.remove(method)) methods.add(method);
    _updateParams(_params.copyWith(methods: methods));
  }

  /// Shows every method again.
  void clearMethods() => _updateParams(_params.copyWith(methods: const {}));

  /// Applies [search] once typing pauses for [searchDebounce]; [immediate]
  /// applies it right away.
  void setSearch(String search, {bool immediate = false}) {
    void apply() => _updateParams(_params.copyWith(search: search));
    if (immediate) {
      _searchDebouncer.cancel();
      apply();
    } else {
      _searchDebouncer(apply);
    }
  }

  /// Removes the request with [id], dropping it from the list at once.
  Future<void> deleteRequest(String id) async {
    _requests = List.unmodifiable(_requests.where((r) => r.id != id));
    notifyListeners();
    await _deleteRequest(id);
  }

  /// Removes expired requests and re-reads the list; completes once fresh data
  /// arrived.
  Future<void> refresh() async {
    _started = true;
    await _removeExpiredRequests(unit);
    await _subscribe();
  }

  /// Removes every request.
  Future<void> clearAll() async {
    await _clearAllRequests(unit);
  }

  void _updateParams(RequestFilterParams next) {
    if (next == _params) return;
    _params = next;
    notifyListeners();
    if (_started) _subscribe();
  }

  Future<void> _subscribe() {
    _subscription?.cancel();
    final firstResult = Completer<void>();
    _subscription = _watchRequests(_params).listen(
      (requests) {
        _requests = requests;
        _loading = false;
        notifyListeners();
        if (!firstResult.isCompleted) firstResult.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!firstResult.isCompleted) {
          firstResult.completeError(error, stackTrace);
        }
      },
    );
    return firstResult.future;
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    _subscription?.cancel();
    super.dispose();
  }
}
