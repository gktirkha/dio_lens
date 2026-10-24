/// Lifecycle of a captured request.
enum RequestState {
  /// Sent, no response or error yet.
  pending,

  /// A response arrived (any status code).
  completed,

  /// No usable response: timeout, connection error, cancel, etc.
  failed,
}
