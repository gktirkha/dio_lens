// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_bucket_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeBucketEntity _$TimeBucketEntityFromJson(Map<String, dynamic> json) =>
    _TimeBucketEntity(
      start: DateTime.parse(json['start'] as String),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$TimeBucketEntityToJson(_TimeBucketEntity instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'count': instance.count,
    };
