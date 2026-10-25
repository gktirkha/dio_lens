import 'package:freezed_annotation/freezed_annotation.dart';

import 'request_list_item_entity.dart';
import 'request_status_filter.dart';

part 'request_filter_params.freezed.dart';

/// Filter of the home list: status, methods and search text.
@freezed
abstract class RequestFilterParams with _$RequestFilterParams {
  const RequestFilterParams._();

  /// Creates a filter.
  const factory RequestFilterParams({
    @Default(RequestStatusFilter.all) RequestStatusFilter status,

    @Default(<String>{}) Set<String> methods,

    @Default('') String search,
  }) = _RequestFilterParams;

  /// No filter: every request matches.
  static const RequestFilterParams none = RequestFilterParams();

  /// Whether nothing is filtered.
  bool get isEmpty =>
      status == RequestStatusFilter.all && methods.isEmpty && search.isEmpty;

  /// Whether [request] passes this filter.
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
