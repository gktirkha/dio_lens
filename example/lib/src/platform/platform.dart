/// What differs between native platforms and the web: certificate pinning
/// and saving an export.
library;

export 'platform_io.dart' if (dart.library.js_interop) 'platform_web.dart';
