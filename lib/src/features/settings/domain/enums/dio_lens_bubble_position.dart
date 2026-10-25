import 'package:freezed_annotation/freezed_annotation.dart';

/// Corner of the host app where the floating bubble starts. Start and end
/// follow the reading direction.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensBubblePosition {
  /// Top corner on the reading start side (left in LTR).
  topStart,

  /// Top corner on the reading end side (right in LTR).
  topEnd,

  /// Bottom corner on the reading start side (left in LTR).
  bottomStart,

  /// Bottom corner on the reading end side (right in LTR).
  bottomEnd,
}
