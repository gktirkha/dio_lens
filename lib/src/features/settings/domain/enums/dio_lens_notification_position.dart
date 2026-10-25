import 'package:freezed_annotation/freezed_annotation.dart';

/// Edge of the screen where the request-finished banner appears.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensNotificationPosition { top, center, bottom }
