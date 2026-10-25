import 'package:freezed_annotation/freezed_annotation.dart';

import 'request_list_item_entity.dart';
import 'request_status_filter.dart';

part 'request_filter_params.freezed.dart';

@freezed
abstract class RequestFilterParams with _$RequestFilterParams {
  const RequestFilterParams._();

  const factory RequestFilterParams({
    @Default(RequestStatusFilter.all) RequestStatusFilter status,

    @Default(<String>{}) Set<String> methods,

    @Default('') String search,
  }) = _RequestFilterParams;

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
