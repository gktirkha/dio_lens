import 'package:freezed_annotation/freezed_annotation.dart';

/// How long captured requests are kept on the device.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensRetention {
  /// Only this app run; stored requests are dropped on the next launch.
  session(null),
  oneHour(Duration(hours: 1)),
  oneDay(Duration(days: 1)),
  sevenDays(Duration(days: 7)),
  always(null);

  const DioLensRetention(this.maxAge);

  /// Oldest age a request may reach; null for [session] and [always].
  final Duration? maxAge;
}
