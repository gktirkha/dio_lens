import 'package:freezed_annotation/freezed_annotation.dart';

/// How long captured requests are kept on the device.
@JsonEnum(fieldRename: FieldRename.snake)
enum DioLensRetention {
  /// Only this app run; stored requests are dropped on the next launch.
  session(null),

  /// One hour.
  oneHour(Duration(hours: 1)),

  /// One day.
  oneDay(Duration(days: 1)),

  /// Seven days.
  sevenDays(Duration(days: 7)),

  /// Never expire; only the max requests limit removes requests.
  always(null);

  const DioLensRetention(this.maxAge);

  /// Oldest age a request may reach; null for [session] and [always].
  final Duration? maxAge;
}
