import 'package:freezed_annotation/freezed_annotation.dart';

part 'named_count_entity.freezed.dart';
part 'named_count_entity.g.dart';

/// A label (endpoint path, host…) and how often it occurred.
@freezed
abstract class NamedCountEntity with _$NamedCountEntity {
  /// Creates an entry.
  const factory NamedCountEntity({
    /// The label, e.g. an endpoint path or a host.
    @JsonKey(name: 'name') required String name,

    /// How often it occurred.
    @JsonKey(name: 'count') required int count,
  }) = _NamedCountEntity;

  /// Reads an entry stored by `toJson`.
  factory NamedCountEntity.fromJson(Map<String, dynamic> json) =>
      _$NamedCountEntityFromJson(json);
}
