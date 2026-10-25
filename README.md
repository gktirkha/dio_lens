# Dio Lens

An in-app network inspector for [Dio](https://pub.dev/packages/dio). See every
request your app makes, from inside the app: headers, bodies, timing, errors
and stats. Replay requests, export them as HAR or JSON, and share them, with
sensitive values masked.

<p align="center">
  <img src="screenshots/demo.gif" width="300" alt="Dragging the Dio Lens bubble, making a request, and opening it from the request-finished banner">
</p>

## Screenshots

| Requests | Request detail | Stats |
| :---: | :---: | :---: |
| <img src="screenshots/requests.png" width="240" alt="Request list"> | <img src="screenshots/detail_request.png" width="240" alt="Request tab with a redacted Authorization header and a JSON body"> | <img src="screenshots/stats.png" width="240" alt="Stats"> |
| **Settings** | **Request-finished banner** | **Light theme** |
| <img src="screenshots/settings.png" width="240" alt="Settings sheet"> | <img src="screenshots/banner.png" width="240" alt="Banner over the host app"> | <img src="screenshots/requests_light.png" width="240" alt="Request list in the light theme"> |

## Features

- **Request list** with search, method and status filters, grouping by time,
  swipe to delete and pull to refresh.
- **Request detail** with Overview, Request and Response tabs: collapsible
  JSON tree, raw view, form and text bodies, image previews, error details
  with stack trace, copyable fields and a cURL command.
- **Stats**: totals, success rate, average and p95 latency, status
  distribution, and the slowest, largest and most-called endpoints and top
  hosts.
- **Replay** a request through your own Dio, so your interceptors (auth,
  refresh) apply.
- **Export** every request as HAR 1.2 or JSON, and **share** one as a
  readable text report.
- **Redaction** of sensitive headers and query parameters in the UI,
  exports and shares.
- **Floating bubble** to open Dio Lens, and a **banner** when a request
  finishes.
- **Settings sheet** for limits, retention, body size, notifications,
  the bubble, redaction and theme. Settings persist.
- **Light, dark and system themes**, applied to Dio Lens only, never to your
  app. Right-to-left layouts supported.
- **Lightweight**: capture never blocks requests, body processing and JSON
  work run in background isolates, and only request summaries are kept in
  memory.

## Getting started

Add the package:

```sh
flutter pub add dio_lens
```

Set it up before `runApp`, give the same navigator key to your
`MaterialApp`, and add the interceptor to your Dio:

```dart
import 'package:dio/dio.dart';
import 'package:dio_lens/dio_lens.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final dio = Dio();

void main() {
  DioLens.init(navigatorKey: navigatorKey);

  // Add Dio Lens last, so it records what earlier interceptors added.
  dio.interceptors.add(DioLensInterceptor(dio: dio));

  runApp(MaterialApp(navigatorKey: navigatorKey, home: const HomePage()));
}
```

That's it. Requests made through `dio` appear in Dio Lens. Open it with the
floating bubble, the **View** button of the request-finished banner, or from
code:

```dart
DioLens.open();
```

See the [example](example/lib/main.dart) for a complete app.

## Build modes

Dio Lens shows captured headers and bodies, tokens included, so by default it
only runs in debug builds. Choose the build modes with `mode`:

```dart
DioLens.init(navigatorKey: navigatorKey, mode: DioLensMode.debugProfile);
```

| Mode | Debug | Profile | Release |
| --- | :---: | :---: | :---: |
| `hide` | | | |
| `debug` (default) | ✓ | | |
| `profile` | | ✓ | |
| `release` | | | ✓ |
| `debugProfile` | ✓ | ✓ | |
| `debugRelease` | ✓ | | ✓ |
| `profileRelease` | | ✓ | ✓ |
| `debugProfileRelease`, `show` | ✓ | ✓ | ✓ |

Outside the chosen modes the interceptor does nothing.

## Settings

Pass starting settings to `DioLens.init`. Users can change them in the
settings sheet, and the stored values then take precedence.

```dart
DioLens.init(
  navigatorKey: navigatorKey,
  settings: const DioLensSettings(
    maxRequests: 200,
    retention: DioLensRetention.sevenDays,
    maxBodyBytes: 512 * 1024,
    notificationPosition: DioLensNotificationPosition.bottom,
  ),
);
```

| Setting | Default | Description |
| --- | --- | --- |
| `maxRequests` | `500` | Most requests kept (10 to 10,000); the oldest are removed. |
| `retention` | `oneDay` | How long requests are kept: `session`, `oneHour`, `oneDay`, `sevenDays` or `always`. |
| `maxBodyBytes` | 1 MB | Largest body kept; bigger bodies are stored truncated. `null` keeps every body whole. |
| `showNotification` | `true` | Show a banner when a request finishes. |
| `notificationPosition` | `top` | Banner position: `top`, `center` or `bottom`. |
| `notificationDuration` | 4 s | How long the banner stays (2 to 15 seconds). |
| `showBubble` | `true` | Show the floating bubble. |
| `bubblePosition` | `bottomEnd` | Corner the bubble starts in; follows the reading direction. |
| `redactHeaders` | `true` | Mask the headers in `redactedHeaders`. |
| `redactedHeaders` | `authorization`, `cookie`, `set-cookie`, `x-api-key` | Header names to mask, case-insensitive. |
| `redactQuery` | `true` | Mask the query parameters in `redactedQueryParams`. |
| `redactedQueryParams` | `token`, `apikey`, `password` | Query parameter names to mask, case-insensitive. |
| `themeMode` | `dark` | Dio Lens theme: light, dark or system. |

Read and change settings from code:

```dart
final current = DioLens.settings.value;
await DioLens.updateSettings(current.copyWith(showBubble: false));
await DioLens.resetSettings(); // Back to the values passed to init.
```

## Export and share

Dio Lens builds export files and share reports in memory and hands them to
your app. It never saves anything itself, so you decide whether to save,
share or upload.

```dart
DioLens.init(
  navigatorKey: navigatorKey,
  onExport: (DioLensExportFile file) async {
    // file.fileName, file.bytes, file.mimeType, file.requestCount
  },
  onShare: (DioLensShareContent content) async {
    // content.subject, content.text
  },
);
```

- Without `onExport`, the export buttons are disabled. You can also build an
  export from code with `DioLens.export(DioLensExportFormat.har)`.
- Without `onShare`, sharing copies the report to the clipboard.

Exports and shares mask values as the redaction settings say.

## Replay

Replay sends a request again from its detail page. Pass your Dio to the
interceptor so the replay goes through it, with your interceptors, base
options and adapter:

```dart
dio.interceptors.add(DioLensInterceptor(dio: dio));
```

If your app has several Dio instances with the same base URL, give each a
`name` so requests from earlier app runs replay through the right one:

```dart
uploadDio.interceptors.add(DioLensInterceptor(dio: uploadDio, name: 'upload'));
```

- Requests from the current run are re-sent exactly as originally sent,
  file uploads included.
- Requests from earlier runs are rebuilt from what was captured. Ones whose
  file uploads or bodies weren't fully captured can't be replayed, and Dio
  Lens says so instead of sending something different.
- Without a Dio, replays go through a plain Dio, and Dio Lens prints a
  one-time hint in the console.

## Custom storage

Requests and settings persist with `shared_preferences` by default. To use
your own database, extend `DioLensStorage` and pass it to `DioLens.init`:

```dart
class MyStorage extends DioLensStorage {
  @override
  Future<List<Map<String, dynamic>>> readSummaries() async { /* … */ }

  @override
  Future<Map<String, dynamic>?> readRequest(String id) async { /* … */ }

  @override
  Future<List<Map<String, dynamic>>> readRequests() async { /* … */ }

  @override
  Future<void> writeRequest(
    String id, {
    required Map<String, dynamic> request,
    required Map<String, dynamic> summary,
  }) async { /* … */ }

  // deleteRequests, clearRequests, readSettings, writeSettings,
  // clearSettings…
}

DioLens.init(navigatorKey: navigatorKey, storage: MyStorage());
```

- Records are plain JSON-encodable maps, so storage needs no Dio Lens types.
- Each request has a full record and a small summary used for lists. Store
  them separately so startup reads only summaries. If you don't, return the
  full records from `readSummaries`.
- Dio Lens applies the request limit and retention itself, and never calls
  two storage methods at once.

## API

| Member | Description |
| --- | --- |
| `DioLens.init(...)` | Sets Dio Lens up. Call once, before the first request. |
| `DioLens.open()` | Opens the Dio Lens home. |
| `DioLens.openRequest(id)` | Opens the detail page of one request. |
| `DioLens.settings` | Current settings, as a `ValueListenable`. |
| `DioLens.updateSettings(settings)` | Applies and stores settings. |
| `DioLens.resetSettings()` | Goes back to the settings passed to `init`. |
| `DioLens.export(format)` | Builds an export of every request. |
| `DioLens.clear()` | Removes every captured request. |
| `DioLens.isInitialized`, `DioLens.isEnabled` | Whether `init` was called, and whether requests are recorded in this build. |

## Platform support

Android, iOS, macOS, Windows and Linux. Web isn't supported, because Dio Lens
processes request bodies in background isolates.

## License

See [LICENSE](LICENSE).
