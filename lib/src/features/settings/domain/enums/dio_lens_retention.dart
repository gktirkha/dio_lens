import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensRetention {
  session(null),
  oneHour(Duration(hours: 1)),
  oneDay(Duration(days: 1)),
  sevenDays(Duration(days: 7)),
  always(null);

  const DioLensRetention(this.maxAge);

  final Duration? maxAge;
}
