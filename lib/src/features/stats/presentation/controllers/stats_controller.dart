import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/domain/unit.dart';
import '../../domain/entities/request_stats_entity.dart';
import '../../domain/use_cases/watch_stats_use_case.dart';

/// State for the stats page.
///
/// Lazy: nothing is watched until the first listener attaches.
class StatsController extends ChangeNotifier {
  StatsController({required this._watchStats});

  final WatchStatsUseCase _watchStats;

  StreamSubscription<RequestStatsEntity>? _subscription;

  RequestStatsEntity _stats = RequestStatsEntity.empty;
  RequestStatsEntity get stats => _stats;

  bool _loading = true;

  /// True until the first result arrives.
  bool get isLoading => _loading;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _subscription ??= _watchStats(unit).listen((stats) {
      _stats = stats;
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
