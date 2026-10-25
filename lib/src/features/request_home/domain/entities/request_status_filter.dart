import '../../../../core/enums/request_status_class.dart';

/// Status filter chips of the home list.
enum RequestStatusFilter {
  /// Every request.
  all('All'),

  /// 2xx responses.
  success('2xx'),

  /// 3xx responses.
  redirect('3xx'),

  /// 4xx responses.
  clientError('4xx'),

  /// 5xx responses.
  serverError('5xx'),

  /// 5xx responses and requests that failed without a response.
  errors('Errors');

  const RequestStatusFilter(this.label);

  /// Chip label.
  final String label;

  /// Whether a request of [statusClass] passes this filter.
  bool matches(RequestStatusClass statusClass) {
    switch (this) {
      case RequestStatusFilter.all:
        return true;
      case RequestStatusFilter.success:
        return statusClass == RequestStatusClass.success;
      case RequestStatusFilter.redirect:
        return statusClass == RequestStatusClass.redirect;
      case RequestStatusFilter.clientError:
        return statusClass == RequestStatusClass.clientError;
      case RequestStatusFilter.serverError:
        return statusClass == RequestStatusClass.serverError;
      case RequestStatusFilter.errors:
        return statusClass == RequestStatusClass.serverError ||
            statusClass == RequestStatusClass.error;
    }
  }
}
