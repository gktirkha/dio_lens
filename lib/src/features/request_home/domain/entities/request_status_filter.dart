import '../../../../core/enums/request_status_class.dart';

enum RequestStatusFilter {
  all('All'),
  success('2xx'),
  redirect('3xx'),
  clientError('4xx'),
  serverError('5xx'),
  errors('Errors');

  const RequestStatusFilter(this.label);

  final String label;

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
