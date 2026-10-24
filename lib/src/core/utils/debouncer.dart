import 'dart:async';

import 'package:flutter/foundation.dart';

/// Runs an action only after calls stop for [duration].
///
/// ```dart
/// final _debouncer = Debouncer(const Duration(milliseconds: 250));
///
/// void onChanged(String text) => _debouncer(() => search(text));
///
/// @override
/// void dispose() {
///   _debouncer.dispose();
///   super.dispose();
/// }
/// ```
class Debouncer {
  Debouncer(this.duration);

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
