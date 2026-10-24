import 'request_state.dart';

/// Status bucket used for the list filters and badge colors.
enum RequestStatusClass {
  pending,
  informational,
  success,
  redirect,
  clientError,
  serverError,
  error;

  /// Buckets a request by its [state] and HTTP [statusCode].
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
