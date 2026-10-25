import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensBubblePosition { topStart, topEnd, bottomStart, bottomEnd }
