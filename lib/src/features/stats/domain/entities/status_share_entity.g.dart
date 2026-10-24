// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_share_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatusShareEntity _$StatusShareEntityFromJson(Map<String, dynamic> json) =>
    _StatusShareEntity(
      statusClass: $enumDecode(
        _$RequestStatusClassEnumMap,
        json['status_class'],
      ),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$StatusShareEntityToJson(_StatusShareEntity instance) =>
    <String, dynamic>{
      'status_class': _$RequestStatusClassEnumMap[instance.statusClass]!,
      'count': instance.count,
    };

const _$RequestStatusClassEnumMap = {
  RequestStatusClass.pending: 'pending',
  RequestStatusClass.informational: 'informational',
  RequestStatusClass.success: 'success',
  RequestStatusClass.redirect: 'redirect',
  RequestStatusClass.clientError: 'clientError',
  RequestStatusClass.serverError: 'serverError',
  RequestStatusClass.error: 'error',
};
