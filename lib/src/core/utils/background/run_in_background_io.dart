import 'dart:async';
import 'dart:isolate';

/// Runs [computation] in a background isolate and returns its result.
Future<R> runInBackground<R>(FutureOr<R> Function() computation) =>
    Isolate.run(computation);
