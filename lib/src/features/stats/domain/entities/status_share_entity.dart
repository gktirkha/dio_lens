import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/request_status_class.dart';

part 'status_share_entity.freezed.dart';
part 'status_share_entity.g.dart';

@freezed
abstract class StatusShareEntity with _$StatusShareEntity {
  const factory StatusShareEntity({
    @JsonKey(name: 'status_class') required RequestStatusClass statusClass,
    @JsonKey(name: 'count') required int count,
  }) = _StatusShareEntity;

  factory StatusShareEntity.fromJson(Map<String, dynamic> json) =>
      _$StatusShareEntityFromJson(json);
}
