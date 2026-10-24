import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_bucket_entity.freezed.dart';
part 'time_bucket_entity.g.dart';

/// Number of requests started within one time slot (e.g. one hour).
@freezed
abstract class TimeBucketEntity with _$TimeBucketEntity {
  const factory TimeBucketEntity({
    @JsonKey(name: 'start') required DateTime start,
    @JsonKey(name: 'count') required int count,
  }) = _TimeBucketEntity;

  factory TimeBucketEntity.fromJson(Map<String, dynamic> json) =>
      _$TimeBucketEntityFromJson(json);
}
