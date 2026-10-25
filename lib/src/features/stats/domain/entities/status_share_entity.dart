import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/request_status_class.dart';

part 'status_share_entity.freezed.dart';
part 'status_share_entity.g.dart';

/// How many requests fall in one status class.
@freezed
abstract class StatusShareEntity with _$StatusShareEntity {
  /// Creates an entry.
  const factory StatusShareEntity({
    @JsonKey(name: 'status_class') required RequestStatusClass statusClass,
    @JsonKey(name: 'count') required int count,
  }) = _StatusShareEntity;

  /// Reads an entry stored by `toJson`.
  factory StatusShareEntity.fromJson(Map<String, dynamic> json) =>
      _$StatusShareEntityFromJson(json);
}
