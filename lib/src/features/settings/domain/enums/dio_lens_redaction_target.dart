/// Where a value can end up. `DioLensSettings.redactionTargets` lists the
/// ones where redacted headers and query parameters are masked.
enum DioLensRedactionTarget {
  /// On screen: the request list and every detail tab.
  ui,

  /// What is copied: fields, "Copy all" and cURL commands.
  clipboard,

  /// Console logs.
  console,

  /// What leaves the app: exports and reports handed to `onShare`.
  external,
}
