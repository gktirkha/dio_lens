import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/domain/unit.dart';
import '../../../../core/utils/debouncer.dart';
import '../../domain/entities/request_filter_params.dart';
import '../../domain/entities/request_list_item_entity.dart';
import '../../domain/entities/request_status_filter.dart';
import '../../domain/use_cases/clear_all_requests_use_case.dart';
import '../../domain/use_cases/delete_request_use_case.dart';
import '../../domain/use_cases/watch_requests_use_case.dart';

/// State for the request home page: the active filter and the requests that
/// match it.
///
/// Lazy: nothing is watched until the first listener attaches.
class RequestHomeController extends ChangeNotifier {
  RequestHomeController({
    required this._watchRequests,
    required this._deleteRequest,
    required this._clearAllRequests,
  });

  final WatchRequestsUseCase _watchRequests;
  final DeleteRequestUseCase _deleteRequest;
  final ClearAllRequestsUseCase _clearAllRequests;

  /// Delay after the last keystroke before search re-filters the list.
  static const Duration searchDebounce = Duration(milliseconds: 250);

  final Debouncer _searchDebouncer = Debouncer(searchDebounce);

  StreamSubscription<List<RequestListItemEntity>>? _subscription;
  bool _started = false;

  RequestFilterParams _params = RequestFilterParams.none;
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
      _subscribe();
    }
  }

  void setStatus(RequestStatusFilter status) =>
      _updateParams(_params.copyWith(status: status));

  void toggleMethod(String method) {
    final methods = {..._params.methods};
    if (!methods.remove(method)) methods.add(method);
    _updateParams(_params.copyWith(methods: methods));
  }

  void clearMethods() => _updateParams(_params.copyWith(methods: const {}));

  /// Applies [search] once typing pauses for [searchDebounce]; pass
  /// [immediate] to apply it right away (e.g. when search is cleared).
  void setSearch(String search, {bool immediate = false}) {
    void apply() => _updateParams(_params.copyWith(search: search));
    if (immediate) {
      _searchDebouncer.cancel();
      apply();
    } else {
      _searchDebouncer(apply);
    }
  }

  Future<void> deleteRequest(String id) async {
    // Drop it locally first so a swiped Dismissible leaves the tree at once.
    _requests = List.unmodifiable(_requests.where((r) => r.id != id));
    notifyListeners();
    await _deleteRequest(id);
  }

  Future<void> clearAll() async {
    await _clearAllRequests(unit);
  }

  void _updateParams(RequestFilterParams next) {
    if (next == _params) return;
    _params = next;
    notifyListeners();
    if (_started) _subscribe();
  }

  void _subscribe() {
    _subscription?.cancel();
    _subscription = _watchRequests(_params).listen((requests) {
      _requests = requests;
      _loading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    _subscription?.cancel();
    super.dispose();
  }
}
