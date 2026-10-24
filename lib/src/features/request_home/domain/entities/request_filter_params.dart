import 'package:freezed_annotation/freezed_annotation.dart';

import 'request_list_item_entity.dart';
import 'request_status_filter.dart';

part 'request_filter_params.freezed.dart';

/// What the request list should show: status chip, method filter and search.
@freezed
abstract class RequestFilterParams with _$RequestFilterParams {
  const RequestFilterParams._();

  const factory RequestFilterParams({
    @Default(RequestStatusFilter.all) RequestStatusFilter status,

    /// Upper-case methods to keep; empty keeps every method.
    @Default(<String>{}) Set<String> methods,

    /// Case-insensitive match against method, host, path and query.
    @Default('') String search,
  }) = _RequestFilterParams;

  /// No filtering: every request matches.
  static const RequestFilterParams none = RequestFilterParams();

  bool get isEmpty =>
      status == RequestStatusFilter.all && methods.isEmpty && search.isEmpty;

  bool matches(RequestListItemEntity request) {
    if (!status.matches(request.statusClass)) return false;
    if (methods.isNotEmpty && !methods.contains(request.method.toUpperCase())) {
      return false;
    }
    final query = search.trim().toLowerCase();
    if (query.isEmpty) return true;
    final haystack =
        '${request.method} ${request.host} ${request.path} '
                '${request.query ?? ''}'
            .toLowerCase();
    return haystack.contains(query);
  }
}
