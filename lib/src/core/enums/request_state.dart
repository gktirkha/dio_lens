/// Lifecycle of a captured request: [pending] until it ends, then [completed]
/// when a response arrived (any status code) or [failed] when none did
/// (timeout, connection error, cancel…).
enum RequestState {
  /// Sent, no response or error yet.
  pending,

  /// A response arrived, with any status code.
  completed,

  /// No usable response: timeout, connection error, cancel…
  failed,
}
