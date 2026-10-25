import 'dart:async';

/// Receives a request to share; the app decides how. Without it, Dio Lens
/// copies the report to the clipboard.
typedef DioLensShareCallback = FutureOr<void> Function(
  DioLensShareContent content,
);

/// One captured request as a text report, handed to the app's `onShare`
/// callback. Sensitive values are masked as the redaction settings say.
class DioLensShareContent {
  /// Creates share content.
  const DioLensShareContent({required this.subject, required this.text});

  /// One-line summary, e.g. `GET /v1/orders · 200`.
  final String subject;

  /// Readable report: overview, request, response or error, and cURL.
  final String text;
}
