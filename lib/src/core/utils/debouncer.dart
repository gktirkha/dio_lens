import 'dart:async';

import 'package:flutter/foundation.dart';

/// Runs an action only after calls stop for [duration].
class Debouncer {
  /// Creates a debouncer waiting [duration].
  Debouncer(this.duration);

  /// How long calls must stop before the action runs.
  final Duration duration;
  Timer? _timer;

  /// Schedules [action], cancelling any action still waiting.
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Whether an action is waiting to run.
  bool get isPending => _timer?.isActive ?? false;

  /// Drops the waiting action, if any.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Same as [cancel]; call from the owner's `dispose`.
  void dispose() => cancel();
}
