import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/request_detail_entity.dart';
import '../../domain/use_cases/watch_request_detail_use_case.dart';

/// State for one request's detail page.
///
/// Lazy: nothing is watched until the first listener attaches.
class RequestDetailController extends ChangeNotifier {
  RequestDetailController({
    required this.requestId,
    required this._watchRequestDetail,
  });

  final String requestId;
  final WatchRequestDetailUseCase _watchRequestDetail;

  StreamSubscription<RequestDetailEntity?>? _subscription;

  RequestDetailEntity? _request;

  /// Null while loading or once the request was deleted.
  RequestDetailEntity? get request => _request;

  bool _loading = true;

  /// True until the first result arrives.
  bool get isLoading => _loading;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _subscription ??= _watchRequestDetail(requestId).listen((request) {
      _request = request;
      _loading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
