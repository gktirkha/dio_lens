/// Unit for size settings such as `DioLensSettings.maxBodyBytes`.
enum DioLensSizeUnit {
  bytes(1, 'B'),
  kilobytes(1024, 'KB'),
  megabytes(1024 * 1024, 'MB');

  const DioLensSizeUnit(this.factor, this.label);

  /// Bytes in one of this unit.
  final int factor;

  /// Short label, e.g. `KB`.
  final String label;

  /// [value] of this unit in bytes, e.g. `kilobytes.toBytes(512)`.
  int toBytes(num value) => (value * factor).round();

  /// [bytes] in this unit, e.g. `kilobytes.fromBytes(2048) == 2`.
  double fromBytes(int bytes) => bytes / factor;
}
