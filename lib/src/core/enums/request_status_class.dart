import 'request_state.dart';

/// Visual category of a request, used for badges, filters and stats.
enum RequestStatusClass {
  /// Sent, no response yet.
  pending,

  /// 1xx response.
  informational,

  /// 2xx response.
  success,

  /// 3xx response.
  redirect,

  /// 4xx response.
  clientError,

  /// 5xx response.
  serverError,

  /// No response at all (timeout, connection error, cancel…).
  error;

  /// The category of a request in [state] with [statusCode].
  static RequestStatusClass resolve(RequestState state, int? statusCode) {
    switch (state) {
      case RequestState.pending:
        return RequestStatusClass.pending;
      case RequestState.failed:
        return RequestStatusClass.error;
      case RequestState.completed:
        final code = statusCode;
        if (code == null) return RequestStatusClass.error;
        if (code >= 500) return RequestStatusClass.serverError;
        if (code >= 400) return RequestStatusClass.clientError;
        if (code >= 300) return RequestStatusClass.redirect;
        if (code >= 200) return RequestStatusClass.success;
        return RequestStatusClass.informational;
    }
  }
}
