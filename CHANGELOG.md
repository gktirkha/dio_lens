## 0.0.1

Initial release.

### Capture
- `DioLensInterceptor` records every request made through a Dio: method,
  URL, headers, bodies, status, timing, sizes, and errors with stack traces.
- Captures never change or delay requests, and capture failures never reach
  the app.
- Body processing (JSON, text, form data, images) runs in background
  isolates.
- `uiMode` and `consoleMode` pick the build modes for recording and the UI,
  and for console logs (both debug only by default).

### Console logging
- `DioLensInterceptor` prints every request, response and error to the
  console, with `[REQUEST]`, `[RESPONSE]` or `[ERROR]` in each header.
- `DioLensConsoleSettings` chooses what is printed; `logPrint` where.
- `consoleMode` sets the build modes console logs print in, separately from
  `uiMode`, which covers recording and the UI.

### Inspector
- Request list with search, method and status filters, grouping by time,
  Share, cURL and Replay
  buttons on each row, swipe to delete and pull to refresh.
- Stats: totals, success rate, average and p95 latency, status distribution,
  and slowest, largest, most-called endpoints and top hosts.
- Request detail with Overview, Request and Response tabs: JSON tree,
  Pretty/Raw views, form and text bodies, image previews, error card and
  stack trace, copyable fields and cURL.
- Floating bubble to open Dio Lens; drag it anywhere and it settles at the
  nearest side edge.
- Request-finished banner at the top, center or bottom of the screen.
- Light, dark and system themes, applied to Dio Lens only.
- Right-to-left layouts supported.

### Actions
- Replay re-sends a request through the app's Dio, exactly as originally
  sent for requests from the current run.
- Export every request as HAR 1.2 or JSON; the app receives the file
  through `onExport`.
- Share a request as a text report through `onShare`, or copy it to the
  clipboard.

### Settings
- Settings sheet: max stored requests, retention, max body size,
  notification and bubble options, header and query redaction, export and
  reset.
- Settings persist; values passed to `DioLens.init` are the starting point.
- Sensitive headers and query parameters are masked as the redaction mode
  says: any combination of the UI (what is shown), the clipboard (what is
  copied) and console logs.

### Storage
- Requests and settings persist with `shared_preferences` by default, or
  with a custom `DioLensStorage`.
- Only request summaries are kept in memory; full requests load on demand.
- Oldest requests are removed past the limit or the retention period.
