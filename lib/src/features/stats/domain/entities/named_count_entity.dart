import 'package:freezed_annotation/freezed_annotation.dart';

part 'named_count_entity.freezed.dart';
part 'named_count_entity.g.dart';

/// A label (endpoint path, host, …) and how often it occurred.
@freezed
abstract class NamedCountEntity with _$NamedCountEntity {
  const factory NamedCountEntity({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'count') required int count,
  }) = _NamedCountEntity;

  factory NamedCountEntity.fromJson(Map<String, dynamic> json) =>
      _$NamedCountEntityFromJson(json);
}
