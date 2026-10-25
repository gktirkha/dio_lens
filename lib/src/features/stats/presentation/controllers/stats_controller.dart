import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/domain/unit.dart';
import '../../domain/entities/request_stats_entity.dart';
import '../../domain/use_cases/watch_stats_use_case.dart';

class StatsController extends ChangeNotifier {
  StatsController({required this._watchStats});

  final WatchStatsUseCase _watchStats;

  StreamSubscription<RequestStatsEntity>? _subscription;

  RequestStatsEntity _stats = RequestStatsEntity.empty;
  RequestStatsEntity get stats => _stats;

  bool _loading = true;

  bool get isLoading => _loading;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (_subscription == null) _subscribe();
  }

  Future<void> refresh() => _subscribe();

  Future<void> _subscribe() {
    _subscription?.cancel();
    final firstResult = Completer<void>();
    _subscription = _watchStats(unit).listen(
      (stats) {
        _stats = stats;
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
    _subscription?.cancel();
    super.dispose();
  }
}
