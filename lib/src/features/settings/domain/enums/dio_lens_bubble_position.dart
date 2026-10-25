import 'package:freezed_annotation/freezed_annotation.dart';

/// Corner of the host app where the floating bubble sits. Start and end
/// follow the reading direction, so `topStart` is top-right in RTL.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensBubblePosition { topStart, topEnd, bottomStart, bottomEnd }
