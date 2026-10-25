enum DioLensSizeUnit {
  bytes(1, 'B'),
  kilobytes(1024, 'KB'),
  megabytes(1024 * 1024, 'MB');

  const DioLensSizeUnit(this.factor, this.label);

  final int factor;

  final String label;

  int toBytes(num value) => (value * factor).round();

  double fromBytes(int bytes) => bytes / factor;
}
