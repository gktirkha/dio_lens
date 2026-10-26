/// Runs heavy work off the UI isolate where the platform allows it: in a
/// background isolate on native platforms, in the current isolate on the web,
/// which has no isolates.
library;

export 'run_in_background_io.dart'
    if (dart.library.js_interop) 'run_in_background_web.dart';
