import 'dart:async';

/// Runs [computation] in the current isolate, in a later event-loop turn; the
/// web has no isolates.
Future<R> runInBackground<R>(FutureOr<R> Function() computation) =>
    Future<R>(computation);
