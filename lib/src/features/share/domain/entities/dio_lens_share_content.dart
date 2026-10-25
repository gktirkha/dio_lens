import 'dart:async';

/// Receives a request to share; the app decides how (share sheet, chat,
/// ticket…). Without it, Dio Lens copies [DioLensShareContent.text].
typedef DioLensShareCallback = FutureOr<void> Function(
  DioLensShareContent content,
);

/// One captured request, ready to share. Handed to the app's `onShare`
/// callback; without one, [text] is copied to the clipboard.
///
/// Sensitive header and query values are masked as the redaction settings
/// say.
class DioLensShareContent {
  const DioLensShareContent({required this.subject, required this.text});

  /// One-line summary, e.g. `GET /v1/orders · 200`, for a share sheet's
  /// subject or a file name.
  final String subject;

  /// Readable report: overview, request, response, error and cURL.
  final String text;
}
