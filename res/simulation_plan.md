# API simulation: plan

Let testers and developers fake what an API returns without touching the
backend: a delay, an HTTP error, a network failure, a malformed body or a
full mock response. Rules are made from a captured request's detail page,
kept on the device, and applied to matching requests until turned off.

## 1. How it works (engine)

### Where the fake happens

Wrap the app's `HttpClientAdapter`, not `onRequest`. `DioLensInterceptor`
already receives the `Dio`, so it can install `DioLensSimulationAdapter`
around `dio.httpClientAdapter` once. A simulated request then goes through
Dio's real pipeline:

- the app's own interceptors run in their normal order (auth refresh on 401,
  retry interceptors and so on all see it);
- the transformer parses the body, so a malformed JSON body fails exactly
  as a real one would;
- `validateStatus` decides success or failure, as it does for real calls;
- timeouts and connection errors are thrown as the same `DioException` types
  Dio throws.

Without a `Dio` given to the interceptor, simulation is unavailable for that
client (same as Replay today), and the editor says why.

### Gating (code only, like `allowDelete`)

- `allowSimulation: DioLensMode`, default `debug`. Outside its build modes no
  rule applies, the adapter passes through, and the UI hides every
  simulation entry point. Never stored.
- A master switch, "Simulation on/off", lets a user pause every rule at once
  without losing them.

### Rule model (`DioLensSimulationRule`, freezed + JSON)

| Field | Meaning |
| --- | --- |
| `id`, `name` | Name defaults to `GET /v1/users`. |
| `enabled` | Per-rule switch. |
| `match` | See "Matching". |
| `request` | Optional request rewrite; see "Request rewriting". |
| `behavior` | See "Behaviors"; exactly one per rule. |
| `delay` | Optional fixed delay, or a min–max range (jitter). Applies to every behavior. |
| `limit` | Always, the next N matching requests, or a percentage of them (flaky network). |
| `hits` | How many times it has fired; shown in the list. |
| `createdAt`, `sourceRequestId` | Where it came from. |

### Matching

Presets in the editor, each pre-filled from the captured request:

1. **This request**: method + host + path + query.
2. **This endpoint**: method + host + path (any query). The default.
3. **This path, any method**: host + path.
4. **Whole host**: every request to the host.

Advanced (collapsed): edit method (any/specific), host, path pattern with
`*` per segment (`/v1/users/*`), and "Treat IDs as wildcards", which turns
numeric and UUID segments into `*`. An optional client name matches
`DioLensInterceptor(name:)`.

When several rules match, the most specific one wins: exact query, then
path, then path pattern, then host. Ties go to the newest. The editor warns
when a new rule hides or overlaps another.

### Behaviors

**Status code is independent of the body.** Every behavior that produces a
response lets you pick any status (100–599), so combinations like "400 with
an HTML page", "200 with invalid JSON" or "503 with a JSON error body" are
all one rule. The only exception is Network failure: no response reaches
the app, so there is no status to set.

All behaviors share one **status picker**:

- chips grouped by class:
  - 2xx: 200, 201, 202, 204
  - 3xx: 301, 302, 304
  - 4xx: 400, 401, 403, 404, 409, 422, 429
  - 5xx: 500, 502, 503, 504
- **Custom**: any code from 100 to 599;
- **Keep real**: the status the server sent. This one is only offered
  where the request still goes to the network (Real response, and Malformed
  body in "corrupt the real body" mode).

| Behavior | Status | Options | What Dio sees |
| --- | --- | --- | --- |
| **Real response** | Keep real (default), or any code | Calls the server for real; optional delay, status and header changes on top. With a status override the real body is kept. A rule must change something: a delay, the status, a header or the request (see "Request rewriting"). | The real response, possibly late, with the changes applied. |
| **HTTP error** | Any code; defaults to 500, with the 4xx/5xx chips first | Body: None, JSON, Text or **HTML** (e.g. a proxy's error page). | A response with that status and body. `validateStatus` decides success or `badResponse`, as for a real call. |
| **Network failure** | None (no response) | Connection timeout, send timeout, receive timeout, connection error (offline/DNS), bad certificate, cancelled. Timeouts can wait for the request's own timeout or fail at once. | The matching `DioExceptionType`. |
| **Malformed body** | Any code; defaults to 200. Keep real when corrupting the real body. | Invalid JSON, truncated, empty, HTML instead of JSON, wrong `Content-Type`. Source: a made-up body, or the real response corrupted. | A transformer error, or data of the wrong type, under the chosen status. Dio's error path for 4xx/5xx and its parse path for 2xx both get exercised. |
| **Mock response** | Any code; defaults to 200, with the 2xx chips first | `Content-Type` (JSON, Text, HTML, URL-encoded form, Multipart form, File), a body editor with validation and pretty-print, or a Postman-style field editor for forms (see "Form bodies and files"). "Start from captured response" copies the real one in. | A normal response; no network call is made. |

HTTP error and Mock response overlap on purpose: they are the same engine
(a status plus a body) with different defaults and chip order, so the
common intent ("make it fail" vs "make it return this") takes one tap.

### Request rewriting

A rule can also **change the request before it is sent**, like Charles's
Map Remote and Rewrite tools. Rewrites only matter when the server is
really called: with Real response, and with Malformed body when it
corrupts the real response. For made-up responses (HTTP error, Network
failure, a made-up Malformed body, Mock response) nothing is sent, and the
editor says so.

| Rewrite | Options | Example |
| --- | --- | --- |
| **Redirect** | Scheme, host and port; keeps path and query unless the path is rewritten too. | `api.example.com` → `staging.example.com`, or `http://10.0.2.2:8080` for a local server. |
| **Path** | Replace a prefix, or the whole path. Wildcards captured by the match can be reused: `$1`. | `/v1/*` → `/v2/$1` |
| **Query parameters** | Set / Add / Remove rows, the same model as header edits. | Set `page=999`; Remove `locale` |
| **Request headers** | Set / Add / Remove rows (`DioLensHeaderEdit`, shared with response headers). | Remove `Authorization` to get a real 401; Set `Accept-Language: ar` |
| **Body** | Replace it with JSON, Text, URL-encoded form, Multipart form or File, using the same editors as mock bodies (S2b–S2d), files via `onPickFile`. "Start from captured request" copies the original in. | Send an invalid email to test server-side validation. |
| **Method** | Optional; rarely needed. | `PUT` → `PATCH` |

- **Where it happens:** in the simulation adapter, after every app
  interceptor ran. So app-added headers (auth tokens, app version) can be
  removed or changed too.
  - The adapter builds new `RequestOptions` for the call and re-encodes a
    replaced body.
  - `Content-Type` and `Content-Length` follow the new body, unless they
    are overridden in the header edits.
- **What is captured:** the request as the app made it stays the main
  record, plus a `sentAs` copy of what actually went out (URL, headers,
  body). The detail page shows the difference (see S5). cURL and Replay use
  the **original** request; Replay then goes through the rule again while
  it is on.
- **Redaction:** follows `redactionTargets` for the original and the
  rewritten values alike.
- **Safety:** redirecting to another host shows the target in the rule's
  chip ("→ staging.example.com"), in the Overview box and in the console
  prefix (`[simulated: Use staging → staging.example.com]`). TLS is not
  relaxed: a host with a bad certificate still fails, which is what the
  Bad certificate failure is for.
- **Model:** `DioLensRequestRewrite { Uri? baseUrl; DioLensPathRewrite?
  path; String? method; List<DioLensHeaderEdit> query; List<DioLensHeaderEdit>
  headers; DioLensSimulatedBody? body; }`. Every part is optional; an empty
  rewrite does nothing.

### Response headers

Like the status, **response headers can be simulated in every behavior that
produces a response**, which is all of them except Network failure. Each
rule has a list of header edits, applied in order:

| Operation | Effect |
| --- | --- |
| **Set** | Adds the header, or replaces every value it already has. |
| **Add** | Adds one more value, keeping the others (a second `Set-Cookie`). |
| **Remove** | Drops the header. Only meaningful on top of a real response. |

- **Base headers:**
  - **Real response** (Real response; Malformed body corrupting the real
    response): edits apply on top of the headers the server sent, so you
    can remove `Cache-Control` or change `Content-Type` without touching
    anything else.
  - **Made-up response** (HTTP error, Malformed body with a made-up body,
    Mock response): starts empty. Dio Lens then fills `Content-Type` from
    the body type, and `Content-Length` from the body.
- **Automatic headers:**
  - `Content-Type` and `Content-Length` are shown as read-only "auto" rows.
  - Setting `Content-Type` yourself overrides the auto one. A mismatch with
    the body is allowed, since that is a useful test (HTML labelled as
    JSON), and the editor shows a warning.
  - `Content-Length` can be overridden too, to test a wrong length, also
    with a warning.
- **Headers that matter to Dio and the app**, offered as suggestions in the
  key field (autocomplete). Suggestions tied to the chosen status come
  first:

  | Status | Suggested header |
  | --- | --- |
  | 401 | `WWW-Authenticate` |
  | 429 and 503 | `Retry-After` (seconds or an HTTP date) |
  | 3xx | `Location` |
  | 304 | `ETag`, `Last-Modified` |

  Always suggested: `Set-Cookie`, `Cache-Control`, `Content-Type`,
  `Content-Encoding`, `X-Request-Id`, `X-RateLimit-Remaining`.
- **Header names** are case-insensitive, as in Dio. They are shown as typed.
- **Redaction still applies:** a simulated `Set-Cookie` is masked on screen,
  in the clipboard, in console logs and in exports, exactly like a real
  one, following `redactionTargets`.
- **Captured requests** show the final headers, and the Overview tab's
  "Simulation" box lists what the rule changed (`+ Retry-After: 30`,
  `− Cache-Control`).
- **Model:** `DioLensHeaderEdit { bool enabled; String name;
  DioLensHeaderOp op; String? value; }` on every rule; the list is empty by
  default.

### Form bodies and files

Form bodies are edited as a field list, not raw text, like Postman's
form-data and x-www-form-urlencoded tabs. They apply to the body of a Mock
response or an HTTP error.

- **Body types:**
  - **URL-encoded form** (`application/x-www-form-urlencoded`): text fields
    only.
  - **Multipart form** (`multipart/form-data`): text and file fields. The
    boundary is generated when the rule fires.
  - **File** (raw binary body: an image, a PDF, a zip): a single file. Its
    `Content-Type` comes from the file and can be overridden.
- **Field row** (`DioLensFormField`):
  - `enabled`, `key`, `type` (text or file);
  - `value` for text;
  - for files: `files`, a list of `DioLensFormFile` (`fileName`,
    `contentType`, `bytes`). **One key can hold several files**
    (`photos[]` with three images); each is sent as its own part under the
    same name, in list order, the way Dio's `FormData.files` and browsers
    send `<input multiple>`;
  - an optional `description`, shown only in the editor.
  
  Keys can repeat (`tags[]` twice), and order is kept. A key with several
  files and a repeated key with one file each produce the same parts; the
  first is just easier to edit. Disabled rows stay in the rule but aren't
  sent.
- **Bulk edit:** a toggle switches the list to raw `key: value` lines, as in
  Postman. Text fields only; file rows are kept and shown as locked lines,
  one line per file.
- **"Start from captured response"** turns a captured form body back into
  rows. Parts sharing a key come back as one row with several files.
  Captured files come back as file rows when their bytes were kept
  (within `maxBodyBytes`), and as an empty file row with their name
  otherwise.

#### Files come from the host app

Dio Lens doesn't pick files itself: it would need a plugin and permissions
on every platform. The host passes a callback to `init`, and shows whatever
picker it likes (`file_picker`, `image_picker`, its own gallery, or a fixed
asset in tests):

```dart
typedef DioLensFilePicker =
    Future<List<DioLensPickedFile>> Function(DioLensFilePickRequest request);

/// What Dio Lens asks for: hints only, the host decides.
class DioLensFilePickRequest {
  final String? fieldKey;            // e.g. "photos[]"
  final List<String> contentTypes;   // e.g. ["image/*"]; empty = anything
  final int? maxBytes;               // the per-file size limit
  final bool allowMultiple;          // true on multipart file rows
}

/// One file the host returns. An empty list means the user cancelled.
class DioLensPickedFile {
  const DioLensPickedFile({
    required this.name,
    required this.bytes,
    this.contentType,   // guessed from the name when null
  });
  final String name;
  final Uint8List bytes;
  final String? contentType;
}

DioLens.init(
  navigatorKey: navigatorKey,
  onPickFile: (request) async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      allowMultiple: request.allowMultiple,
    );
    return [
      for (final file in result?.files ?? const <PlatformFile>[])
        DioLensPickedFile(name: file.name, bytes: file.bytes!),
    ];
  },
);
```

- **Without `onPickFile`:**
  - the File body type and the file field type are hidden, the same pattern
    as Share without `onShare`;
  - file rows that already exist (from `init` seeds or a captured response)
    still work, but can't be replaced.
- **Picker failures:** if the callback throws, the editor shows "Couldn't
  add the file" and keeps the row; it never crashes the sheet.
- **Size limits:**
  - A returned file larger than the limit is refused, with its size and the
    limit.
  - When several are returned, the valid ones are added and the refused
    ones listed ("2 added · 1 too large: video.mp4, 48 MB").
  - The host may ignore `allowMultiple`; Dio Lens accepts whatever comes
    back. Where only one file fits (a raw File body), it keeps the first.
- **Code seeds:** rules passed to `init` can carry file fields built from
  bytes, e.g. `DioLensFormField.file('avatar', bytes, fileName:
  'a.png')` or `DioLensFormField.files('photos[]', [file1, file2])`. Tests and demos then need no picker.
- **Storage:**
  - file bytes are stored with the rule (base64 in JSON storage);
  - a per-file limit, `maxSimulationFileBytes` (default 5 MB), keeps
    storage sane;
  - the Simulations tab shows each rule's total size when it holds files;
  - exports of rules (phase 4) include files only when the user ticks
    "Include files".

### Storage

Rules live apart from settings, so resetting settings keeps them. Add
`readSimulations` / `writeSimulations` to `DioLensStorage` with default
implementations that keep rules in memory. Existing custom storages keep
compiling, and the shared-preferences storage persists them.

### Captured requests

A simulated request is still captured, with `simulation: {ruleId, ruleName,
behavior}`:

- a "Simulated" tag on its row and in its detail header;
- a "Simulated" status filter chip;
- Stats can exclude simulated requests (toggle, default on), so fake
  failures don't skew the success rate;
- console logs prefix the line with `[simulated: <rule name>]`;
- for rewritten requests, a `sentAs` copy of what actually went out.

Replay of a simulated request goes through the same rules, so it simulates
again while the rule is on.

### Code API

```dart
DioLens.init(
  navigatorKey: navigatorKey,
  settings: const DioLensSettings(allowSimulation: DioLensMode.debugProfile),
  simulations: [
    DioLensSimulationRule.httpError(
      match: DioLensMatch.endpoint('GET', 'api.example.com', '/v1/users/*'),
      statusCode: 503,
    ),
  ],
);

DioLens.simulations;            // ValueListenable<List<DioLensSimulationRule>>
DioLens.addSimulation(rule);
DioLens.setSimulationEnabled(id, false);
DioLens.pauseSimulations(true);

// Host-provided file picker for form and file bodies (optional).
DioLens.init(..., onPickFile: (request) async => /* host UI */ null);
```

Rules passed to `init` are seeds: added once (by id), then managed like any
other rule.

## 2. Phases

1. **Engine:** model, matcher, adapter, gating, storage, capture tag. Unit
   tests for every behavior, using a fake adapter and real Dio, the way
   tests work today.
2. **Detail page entry and editor:** the "Simulate" action and the rule
   editor sheet.
3. **Manager and indicators:** the Simulations list, the master switch,
   tags, the filter chip, the bubble and banner indicators, the Stats
   toggle.
4. **Extras:** limits (N times, percentage), conflict warnings, export and
   import of rules as JSON, and `init` seeds.
5. **Request rewriting:** redirect, path, query, request headers, body and
   method rewrites; `sentAs` capture; the Original/Sent views.

Each phase is one minor version: new API only, nothing breaking.

## 3. Open decisions (recommendation first)

- **Manager location (decided):** a third bottom tab, "Simulations", next
  to Requests and Stats.
- **Default `allowSimulation`:** `debug`, the same as `uiMode`. Profile
  builds for testers opt in.
- **Persist across launches:** yes, with the master switch and a clear
  "Simulation on" indicator, so nobody forgets a rule is active.

---

# Design brief: API simulation (for the design agent)

This section is self-contained: hand it to the design agent as is.

## 0. Context

Dio Lens is an in-app network inspector for Flutter apps. A floating bubble
opens it over the host app. It has these tabs:

- **Requests:** a grouped list with search, method and status filters, and
  row buttons (Delete, Share, cURL, Replay).
- **Stats.**

Each request opens a **detail page**: a header with the method, host, path,
status, time and size; Overview, Request and Response tabs; and actions for
Share, cURL, Replay and Delete. Settings live in a bottom sheet.

**New feature: API simulation.** Testers make a request fail, slow down or
return made-up data, or change the request before it goes out (another
host, a removed header, a different body), without changing the backend. They start from a
captured request, choose what should match it and what should happen, and
the rule applies to every matching request until they turn it off.

Users are app developers and QA testers on a phone, often one-handed,
switching between the app and Dio Lens. The UI must be fast to set up (two
taps for a common case like "make this endpoint return 500") and impossible
to forget (an active mock must always be visible).

## 1. Source of truth and constraints

- Extend **`res/design.html`**. Reuse its tokens, components and phone
  frame; don't restyle what exists.
- **Phone frame:** 390 × 844, safe areas as defined (`--phone-*`). Also
  check 320 px wide.
- **Themes:** dark (the default) and light. Every new screen in both. Only
  use `--dl-*` tokens; no hard-coded colors except the one new token below.
- **Fonts:** `--dl-font-sans` (Inter) for UI and `--dl-font-mono` (JetBrains
  Mono) for hosts, paths, status codes, headers and bodies.
- **Radii:** `--dl-r-sm` 8, `--dl-r-md` 12, `--dl-r-lg` 20.
- **RTL:** layouts mirror. Hosts, paths, JSON and code stay LTR.
- **Hit targets:** at least 40 px. Row buttons follow the existing
  `dl-row-qbtn` size.
- **Motion:** sheets and popovers already animate. Use the same motion, and
  nothing new beyond a subtle pulse on the "simulation on" badge.

### New token

The simulation color, distinct from every method and status color (PATCH
is already purple and QUERY is teal):

| Token | Dark | Light |
| --- | --- | --- |
| `--dl-sim` | `#e879f9` | `#a21caf` |
| `--dl-sim-bg` | `rgba(232,121,249,.15)` | `rgba(162,28,175,.10)` |

Use it only for simulation: tags, the active Simulate action, the bubble
badge and the master switch "on" state. Propose a better pair if this one
fails contrast (WCAG AA for text on `--dl-surface`).

### Existing components to reuse

| Need | Component |
| --- | --- |
| Top bars | `dl-topbar`, `dl-detail-header` (`dl-dh-*`), `dl-btn-icon` |
| Bottom nav (add a 3rd tab) | `dl-nav-btn` |
| Sheets | `dl-sheet-panel`, `dl-sheet-head`, `dl-sheet-grabber`, `dl-sheet-body`, `dl-scrim` |
| Sections and rows | `dl-set-section`, `dl-set-row`, `dl-section-head` |
| Toggles | `dl-switch`; option grids like `dl-target-group` / `dl-pos-grid` / `dl-theme-opt` |
| Segmented control | `dl-segmented`, `dl-seg-btn` |
| Chips | `dl-chip`, `dl-preset-chip`, `dl-preset-rail` |
| Fields | `dl-set-field`, `dl-set-input`, `dl-select`, `dl-stepper`, `dl-mini-stepper` |
| Status and method colors | `dl-badge`, `--m-*` |
| Code and body views | `dl-body-toolbar`, `dl-json-raw`, `dl-curl-pre` |
| List rows | `dl-row-*`, `dl-row-qbtn` (Delete is leftmost and red) |
| Menus | `dl-popover`, `dl-pop-item` |
| Empty states | `dl-empty` |
| Confirm dialog | `dl-confirm-box` |
| Banner | `dl-notif-*` |
| Bubble | `dl-bubble` |

## 2. Screens to design

### S1. Detail header: Simulate action

- Add **Simulate** to the detail header's action buttons, beside cURL and
  Replay, with the same style. Icon: a flask (`science_outlined`) or tune,
  not play.
- **States:**
  - *Inactive:* tapping opens S2 pre-filled.
  - *Active:* a rule matches this request. The button is tinted
    `--dl-sim`/`--dl-sim-bg` with a dot, labeled "Simulating"; tapping
    opens that rule.
  - *Unavailable:* hidden.
- If this request itself was simulated, the header shows a **Simulated** tag
  next to the status badge (see S5).

### S2. Rule editor (bottom sheet, tall, scrolls)

Opened from S1 (new or existing rule) or S3 (edit). Order top to bottom:

1. **Sheet head:**
   - title "Simulate" (new) or the rule name (edit);
   - an enable `dl-switch` on the right;
   - a close button.
   
   Below the title, the rule name as an editable field, defaulting to
   `GET /v1/users/42`.
2. **Match:** "Which requests". Four options, one selected, each with a
   label and a mono preview line:
   - This request: `GET api.example.com/v1/users/42?page=2`
   - **This endpoint** (default): `GET api.example.com/v1/users/42`
   - This path, any method: `* api.example.com/v1/users/42`
   - Whole host: `* api.example.com/*`
   
   Then an **Advanced** disclosure, collapsed by default, containing:
   - a method `dl-select` (Any, GET, POST…);
   - host and path-pattern fields;
   - a "Treat IDs as wildcards" switch. Turning it on rewrites the
     previews to `/v1/users/*`.
   
   Show the live count under it: "Matches 14 captured requests".
3. **Change the request** (optional, collapsed by default; see S2f): a
   summary line when it has rewrites ("Redirect → staging.example.com · 1
   header removed"), "Add a change" when it has none.
4. **What happens:** five options as a 2-column grid of options with icon
   and label (the last one full width), or a scrollable segmented control.
   Pick whichever reads better at 320 px.
   - Real response
   - HTTP error
   - Network failure
   - Malformed body
   - Mock response
   
   Under the options, **every behavior except Network failure shows the
   same Status picker first**, then the behavior's own options. Changing
   the behavior keeps the chosen status when it still makes sense.

   **Status picker** (shared component, `dl-sim-status`):
   - chips grouped by class:
     - 2xx: 200, 201, 202, 204
     - 3xx: 301, 302, 304
     - 4xx: 400, 401, 403, 404, 409, 422, 429
     - 5xx: 500, 502, 503, 504
   - colors match the status badges (2xx success, 3xx redirect, 4xx warn,
     5xx danger); groups wrap, or scroll horizontally on one rail per class
     (pick whichever fits better at 320 px);
   - the group of the behavior's default comes first: 4xx/5xx for HTTP
     error, 2xx for Mock response and Malformed body;
   - a **Custom** chip reveals a 3-digit numeric field with the reason
     phrase under it ("418 I'm a teapot"). Its error state reads "Use a
     code from 100 to 599";
   - a **Keep real** chip comes first where offered (Real response; Malformed
     body when corrupting the real response). Its caption: "Whatever the
     server returns".
   - The selected status shows with its reason under the picker: "400 Bad
     Request".

   Under the status, **every behavior except Network failure also shows the
   Response headers editor** (shared component `dl-sim-headers`, see S2e),
   collapsed to a summary line ("2 headers changed") when it has edits, and
   "Add header" when it has none. Behavior-specific options follow.

   Then the behavior's panel:
   - **Real response:**
     - status (Keep real by default). Overriding shows the note "The real
       body is kept; only the status changes".
     - If nothing is changed (no delay, status, header or request change),
       Save is disabled with the hint "Change the request, the status, a
       header or add a delay".
   - **HTTP error:**
     - status (default 500);
     - "Response body": a segmented control None / JSON / Text / HTML.
       Choosing one opens the body editor (S2b) with a starter template.
       The HTML template is a minimal error page, e.g.
       `<html><body><h1>400 Bad Request</h1></body></html>`;
   - **Network failure:** no status picker. Instead, a muted line: "No
     response reaches the app, so there is no status code". Then a list of
     radio rows, each with an icon, a title and one muted line:
     - Connection timeout: "Server didn't accept the connection in time"
     - Send timeout: "Upload took too long"
     - Receive timeout: "Server was too slow to answer"
     - No connection: "Offline or DNS failure"
     - Bad certificate: "TLS certificate rejected"
     - Cancelled: "Request was cancelled"
     
     The timeout rows get a sub-choice: "Wait for the app's timeout" or
     "Fail immediately".
   - **Malformed body:**
     - source, as a segmented control: "Made-up body" or "Corrupt the real
       response";
     - status (default 200; Keep real is offered when corrupting);
     - four radio rows, each with a tiny mono preview:
       - Invalid JSON `{"id": 42, "name": `
       - Truncated
       - Empty body
       - HTML instead of JSON `<html>502 Bad Gateway`
   - **Mock response:**
     - status (default 200);
     - a Body type `dl-segmented`/`dl-select`: JSON, Text, HTML,
       URL-encoded form, Multipart form, File. Form types open the field
       editor (S2c) instead of the text editor; File opens the file slot
       (S2d);
     - the body editor (S2b).
5. **Delay:** a `dl-switch` row "Delay response". When on, show:
   - a slider from 0 to 30 s;
   - a number field with "s";
   - a "Random range" switch that turns the slider into a min–max range,
     e.g. "1.5 – 4 s".
6. **Apply:** a segmented control:
   - Always
   - Next N: a stepper, "Next 3 requests"
   - Sometimes: a percentage slider, "30% of requests"
7. **Conflict notice** (conditional), an inline warn box: "Also matched by
   *Users down* (GET api.example.com/v1/users/*). This rule is more specific
   and wins."
8. **Footer** (sticky):
   - **Save** (primary, accent);
   - in edit mode, **Delete** (red, leftmost) and **Duplicate**.
   
   Saving closes the sheet and shows a snackbar: "Simulating GET
   /v1/users/42".

#### S2b. Body editor (inside S2, or a full-height sheet when expanded)

- A mono editor with line numbers. The toolbar (`dl-body-toolbar`) has
  Format, Validate, "Use captured response" and Expand.
- **Validation:** a green "Valid JSON" or a red inline error, "Unexpected
  end of input at line 3, column 14", with that line highlighted.
- **Empty state hint:** "Paste JSON or tap *Use captured response*".

#### S2e. Response headers editor

The same row style as the form editor (S2c), so the two read as one family.

- **Section head:** "Response headers", with a caption that depends on the
  base:
  - real response: "Changes on top of what the server sends";
  - made-up response: "Sent with the made-up response".
  
  A Bulk edit toggle sits on the right.
- **Row:**
  - an enable checkbox;
  - an **operation** pill (Set / Add / Remove), a compact `dl-select` or
    tap-to-cycle chip, colored neutral, accent and danger;
  - **Name** (mono) with autocomplete;
  - **Value** (mono), hidden for Remove;
  - Delete, leftmost and red.
  - Remove rows render the name struck through in `--dl-danger`.
- **Auto rows** at the top, read-only and muted, each with an "auto" tag:
  - `Content-Type: application/json` (from the body type);
  - `Content-Length: 184`.
  
  Tapping one turns it into an editable Set row ("Override").
- **Real-response preview:** when the base is the real response and the
  request was captured, an "Original headers" disclosure lists the captured
  headers, each with a quick "Remove" or "Edit" that creates the matching
  row.
- **Ghost row** at the end adds a header as you type, as in S2c.
- **Autocomplete popover** (`dl-popover`): the suggested names for the
  current status first (e.g. on 429, `Retry-After` with the hint "Seconds
  until the client may retry"), then the common ones. Selecting a header
  with a known format pre-fills a sample value (`Retry-After: 30`).
- **Warnings** (inline, warn colour, under the row):
  - "Content-Type says JSON but the body is HTML. Fine for testing parse
    errors."
  - "Content-Length doesn't match the body (184 bytes)."
  - "Location without a 3xx status is ignored by most clients."
- **Bulk edit:** one header per line, as `Name: value`, `+Name: value` for
  Add, `-Name` for Remove, and `//` to disable a line.
- **Redaction:** values of redacted headers (`Set-Cookie`,
  `Authorization`…) show masked in the editor when the UI target is
  redacted, with a reveal eye on press-and-hold. That's the same rule as
  the detail tabs.

#### S2f. Change the request

A collapsible section in the editor, between Match and What happens. Each
part is its own row; tapping a row expands it. Only the parts in use show a
value.

- **Redirect to:**
  - a scheme `dl-select` (https, http), a host field and an optional port;
  - suggestion chips under it: the other hosts seen in captured requests,
    plus `localhost:8080` and `10.0.2.2:8080` (the Android emulator's
    host);
  - a live preview line: `https://staging.example.com/v1/users/42?page=2`.
- **Path:**
  - "Replace prefix" or "Replace whole path";
  - two mono fields, "From" `/v1/` and "To" `/v2/`;
  - a hint when the match has wildcards: "Use $1, $2… for the parts
    matched by *".
- **Query parameters:** the S2e row style, with the Set/Add/Remove pill.
  The original parameters are listed under an "Original" disclosure with
  quick Remove and Edit.
- **Request headers:** the same S2e component, captioned "Changes on top
  of what the app sends, including headers added by its interceptors". The
  "Original headers" disclosure shows the captured request headers, with
  redacted values masked.
- **Body:** a Replace body switch. When on, it shows the body type select
  and the matching editor (S2b, S2c or S2d), plus "Start from captured
  request".
- **Method:** a small `dl-select`, under an "More" disclosure.
- **Not sent state:** when the chosen behavior makes a made-up response,
  the whole section is dimmed with the note "Not sent: this rule answers
  without calling the server". The rows stay editable, so switching back
  to Real response keeps them.
- **Diff preview** at the bottom of the section: two mono lines, "Original"
  and "Sent as", with the changed parts highlighted (removed parts struck
  through in danger, added parts in accent).

#### S2c. Form field editor (Postman-style)

Shown for URL-encoded form and Multipart form bodies, in place of the text
editor (S2b).

- **Toolbar:** the body type, a field count ("4 fields"), and a **Bulk
  edit** toggle.
- **Table-like rows**, each one line on phone width, wrapping to two below
  360 px:
  - an enable checkbox (unchecked rows are dimmed and not sent);
  - **Key** (mono);
  - a **Type** toggle, Text or File, shown only for Multipart, and only
    File when `onPickFile` exists;
  - **Value:**
    - *Text:* a mono field.
    - *File:* one **file pill per file**, stacked under the key, each
      showing:
      - the file icon by type (image thumbnail, PDF, generic);
      - the name, the size and the Content-Type;
      - Replace and Remove.
      
      Under the last pill, a small **"+ Add files"** text button calls the
      host picker with `allowMultiple: true`. New files are appended.
      - A row with no file yet shows a single dashed "Choose files" slot.
      - A row with several files shows a summary in the row's value column
        when collapsed: "3 files · 1.2 MB". Tap to expand the pills.
      - Pills can be reordered by dragging within the row (part order is
        send order). They can't be dragged to another row.
  - a drag handle to reorder;
  - Delete, leftmost and red, as on request rows.
  - An optional description shows under the row in muted text when set,
    added from the row's overflow menu.
- **Add field:** a ghost row at the end, with "Key" and "Value"
  placeholders. Typing in it creates a new row, as in Postman.
- **Duplicate keys:** allowed. Show a subtle "×2" marker on repeated keys,
  not an error. When two file rows share a key, offer a quiet "Merge into
  one row" link.
- **Bulk edit mode:** a mono text area with one `key: value` per line and
  `//` to disable a line. File rows appear as locked, non-editable lines,
  one per file, e.g. `photos[]: 📎 beach.jpg (640 KB)`.
- **Picking states for a file row:**
  - *idle:* "Choose file";
  - *waiting:* the host picker is open; show a spinner on the slot or the
    "+ Add files" button, and "Waiting for files…";
  - *picked:* the pills;
  - *partly refused:* the added pills, plus an inline warn line: "2 added ·
    1 too large: video.mp4 (48 MB, limit 5 MB)";
  - *cancelled:* back to idle with no message;
  - *error:* the pill turns danger, "Couldn't add the file", with a Retry;
  - *too large:* danger, "4.2 MB · limit is 5 MB";
  - *removing the last file:* the row goes back to the dashed "Choose
    files" slot; it isn't deleted.
- **No picker** (`onPickFile` missing): no Type toggle; existing file rows
  show their pill without Replace, with the muted caption "Files are added
  by the app".

#### S2d. File body slot

Shown for the File body type: one large dashed drop-style card, "Choose a
file to return as the response body". Once picked, it shows:

- an image preview (reuse `dl-image-preview`) or a type icon;
- the name, the size and an editable Content-Type;
- Replace and Remove.

It has the same picking states as S2c.

### S3. Simulations tab (third bottom tab: Requests · Stats · **Simulations**)

The one place to see every rule, turn rules on and off, and delete them.

- **Bottom nav:** a third `dl-nav-btn`, labelled "Simulations", with the
  flask icon. While any rule is active and simulation isn't paused, the
  icon carries a small `--dl-sim` dot. The tab is hidden when simulation
  isn't allowed in the build.
- **Top bar** (same structure as Requests): title "Simulations", a search
  button (filters by name, host or path) and the overflow menu. The menu
  holds:
  - **New simulation**: opens the S2 editor with an empty match, for rules
    not started from a captured request;
  - **Turn all off**;
  - **Delete all**: red, with a confirmation dialog when Clear all
    confirmation is on;
  - the usual Settings and Minimize.
- **Master switch card**, full width under the top bar:
  - *On:* a `--dl-sim` tint, "Simulation on · 6 rules active".
  - *Paused:* neutral, "Paused · rules are kept but not applied".
  
  It toggles every rule's effect at once, without changing each rule's own
  switch.
- **Filter chips:** All · Active · Off · Fired today.
- **Rule rows** (mirror request rows, `dl-row-*`):
  - **Line 1:**
    - the rule's **enable switch**: one tap turns a single rule on or off.
      Off rows dim to 60% but stay readable;
    - the rule name;
    - a behavior chip ("500", "400 · HTML", "Timeout", "Mock 200",
      "Bad JSON", "+2 s", "→ staging", "− Authorization"), with more than
      one chip when a rule does several things, e.g. "503 · +2 s";
  - **Line 2:** the mono match preview, with a method color dot, e.g.
    `GET api.example.com/v1/users/*`.
  - **Line 3, muted:** "Fired 12× · last 2 min ago · next 3 only", or
    "Never fired". A rule holding files adds its total, e.g. "· 1.3 MB".
  - **Row buttons** (`dl-row-qbtn`, same order rules as request rows):
    - **Delete**: leftmost, red. It asks first only when single-delete
      confirmation is on (same `deleteConfirmation` setting as requests);
    - **Edit**: opens S2;
    - **Duplicate**;
    - **Show requests**: opens the Requests tab filtered to this rule's
      simulated calls.
  - **Tap on a row:** opens S2 for editing.
- **Grouping:** "Active" first, then "Off", each with a count in the group
  header (`dl-group-label`).
- **Empty state** (`dl-empty`):
  - icon and title "No simulations yet";
  - body: "Open a request and tap *Simulate* to fake an error, a delay, a
    response, or change what is sent.";
  - a secondary "New simulation" button.
- **Search with no results:** "No simulations match *users*".
- **Client note:** a row-level note for a client without simulation
  support: "This client can't be simulated: pass `dio` to
  DioLensInterceptor".

### S4. Bubble and banner

- **Bubble:** a small `--dl-sim` badge with a count of active rules at its
  top-end corner, with a subtle pulse. No badge while paused.
- **Request-finished banner:** a simulated request shows a **Simulated**
  tag next to its status.

### S5. Marking simulated requests

- **Request list indicator:** the key one, so a fake call is never
  mistaken for a real one at a glance. Every simulated row gets:
  - a **3 px `--dl-sim` stripe** on the row's start edge, full height;
  - a **"SIM" tag** (`--dl-sim`/`--dl-sim-bg`, `dl-badge` shape) right
    after the status badge;
  - in the meta line, what the rule did, in `--dl-sim`: "· Users down ·
    503", "· +4 s", "· → staging", "· Timeout". A failed simulated call
    (network failure) shows its error and the tag, never a blank status.
  
  The stripe and tag must stay legible next to the method colors and the
  4xx and 5xx status colors in both themes; check PATCH (purple) and DELETE
  (red) rows next to simulated ones. Long-pressing the tag shows a tooltip
  with the rule name.
- **Same tag elsewhere:** "Simulated" (or "SIM" where space is tight) in
  `--dl-sim`/`--dl-sim-bg` also appears in:
  - the detail header, where tapping it opens the rule;
  - the banner.
- **Status filter bar:** a new **Simulated** chip.
- **Request tab:** for rewritten requests, an "Original / Sent" segmented
  control at the top switches between what the app made and what went out.
- **Overview tab:** a "Simulation" box (like the other `dl-ov-box`es):
  - rule name (tap to open it), behavior, delay, and match;
  - when the request was rewritten, a "Sent as" block: the final URL and
    the list of changes (`→ staging.example.com`, `− Authorization`,
    `+ page=999`, "Body replaced"), with "Show sent request" opening the
    rewritten headers and body in the Request tab's style;
  - a button: "Turn off this rule".
- **Stats:** an "Include simulated" switch at the top (default off), and a
  note in the empty or filtered state: "12 simulated requests hidden".

## 3. Sample data (use it so the screens look real)

Host `api.example.com`. Rules:

| Name | Match | Behavior | Delay | Apply | State |
| --- | --- | --- | --- | --- | --- |
| Users down | GET api.example.com/v1/users/* | HTTP error 503 | — | Always | On, fired 12× |
| Slow checkout | POST api.example.com/v1/orders | Real response | 4 s | Always | On, fired 3× |
| Flaky feed | GET api.example.com/v1/feed | Network failure · Receive timeout | — | 30% | On, fired 5× |
| Empty profile | GET api.example.com/v1/me | Mock response 200 (JSON below) | 0.5 s | Next 2 | Off |
| Broken search | GET api.example.com/v1/search | Malformed body · Invalid JSON · 200 | — | Always | Off |
| Proxy error page | POST api.example.com/v1/login | HTTP error 400 · HTML body | — | Next 1 | On, fired 0× |
| Slow and stale | GET api.example.com/v1/config | Real response · status 304 | 2 s | Always | Off |
| Use staging | * api.example.com/* | Real response · Redirect → `https://staging.example.com` | — | Always | Off |
| No auth | GET api.example.com/v1/me | Real response · Remove request header `Authorization` | — | Next 1 | On, fired 1× |
| Page past the end | GET api.example.com/v1/feed | Real response · Query Set `page=999` | — | Always | Off |
| Avatar upload echo | POST api.example.com/v1/avatar | Mock response 201 · Multipart form (below) | 1 s | Always | On, fired 2× |

Mock body for *Empty profile*:

```json
{ "id": 42, "name": "", "email": null, "plan": "free", "flags": [] }
```

Header edits on the sample rules:

| Rule | Edits |
| --- | --- |
| Users down (503) | Set `Retry-After: 30`; Set `X-Request-Id: sim-7f3a` |
| Slow and stale (Real response, 304) | Remove `Cache-Control`; Set `ETag: "v42"`; auto rows show the real `Content-Type` |
| Proxy error page (400, HTML) | Set `Content-Type: application/json` (with the mismatch warning); Add `Set-Cookie: session=expired` |
| Avatar upload echo (201) | Set `Location: /v1/avatar/42` (with the "Location without 3xx" warning) |

Multipart fields for *Avatar upload echo*:

| On | Key | Type | Value |
| --- | --- | --- | --- |
| ✓ | `user_id` | Text | `42` |
| ✓ | `tags[]` | Text | `profile` |
| ✓ | `tags[]` | Text | `public` |
| ✓ | `avatar` | File | `avatar.png` · 182 KB · image/png |
| ✓ | `photos[]` | File (3) | `beach.jpg` · 640 KB, `team.png` · 410 KB, `menu.pdf` · 96 KB |
|   | `debug` | Text | `true` (disabled) |

## 4. Copy rules

- Sentence case. Short labels. No exclamation marks.
- Say what happens, not how: "Server was too slow to answer", not
  "DioExceptionType.receiveTimeout".
- Status codes always come with their reason in the editor ("503 Service
  Unavailable"), and as a number alone in chips and tags.

## 5. States checklist (draw each)

1. S2c form editor with six rows (text, a one-file row, a three-file
   `photos[]` row expanded and collapsed, a disabled row, a repeated key,
   the ghost "add" row), bulk edit mode, and every file picking state,
   including partly refused;
   S2d file body, empty and picked (with an image preview);
   S2c with no picker.
2. S2f Change the request: collapsed summary, expanded with a redirect
   (host suggestions, live preview), a removed request header, a query
   edit and the diff preview; and the dimmed "Not sent" state.
3. S2e headers editor on a made-up response (auto rows, Set and Add rows, a
   mismatch warning, the autocomplete popover on 429) and on a real
   response (Original headers disclosure, a Remove row, Bulk edit).
4. S2 new rule, each of the 5 behaviors, with the status picker on each
   (and its absence explained on Network failure).
5. S2 custom status, valid and invalid; "Keep real" selected on Real
   response; HTTP error 400 with an HTML body.
6. S2b valid JSON and invalid JSON.
7. S2 with the conflict notice.
8. S2 edit mode (footer with Delete).
9. S3 with all the sample rules, simulation on: switches on and off, row
   buttons, the "Active"/"Off" groups, filter chips, and the overflow menu
   open.
10. S3 paused.
11. S3 empty, and search with no results.
12. S1 inactive, active and on a simulated request.
13. S4 bubble badge and banner.
14. S5 request list mixing real and simulated rows (a 503, a +4 s, a
    timeout and a redirected row, next to PATCH and DELETE rows), with the
    filter chip; the Overview "Sent as" block; the Request
    tab Original/Sent toggle on the *Use staging* rule.
15. S5 Overview box.
16. S5 Stats toggle.
17. Light theme for 1, 2, 3, 4, 9, 12 and 14.
18. RTL for 1, 2, 3, 4 and 9.
19. 320 px for 1, 2, 3, 4 and 9.

## 6. Deliverables

- New screens added to `res/design.html` in the existing style, wired to the
  existing interaction scaffolding (`data-action` handlers, the theme
  toggle), with the sample data above.
- Every new CSS class prefixed `dl-sim-` or reusing existing classes. A
  short list of new classes and tokens at the top of the added CSS.
- No new fonts, icon sets or libraries. Icons are Material Symbols names,
  so they map one-to-one to Flutter `Icons.*`.

## 7. Out of scope

Recording mode (saving real responses as mocks automatically), syncing rules
across devices, and GraphQL-aware matching.
