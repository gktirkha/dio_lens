/// Display formatting shared across Dio Lens screens.
abstract final class FormatUtils {
  /// `182 ms`, `1.25 s`, or `—` when unknown.
  static String duration(Duration? value) {
    if (value == null) return '—';
    final ms = value.inMilliseconds;
    if (ms >= 1000) return '${(ms / 1000).toStringAsFixed(2)} s';
    return '$ms ms';
  }

  /// `612 B`, `2.1 KB`, `4.9 MB`, or `—` when unknown.
  static String bytes(int? value) {
    if (value == null) return '—';
    if (value < 1024) return '$value B';
    if (value < 1024 * 1024) return '${(value / 1024).toStringAsFixed(1)} KB';
    return '${(value / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// `Just now`, `5m ago`, `3h ago`, then `HH:mm` / `dd/MM HH:mm`.
  static String relativeTime(DateTime time, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final diff = current.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 12) return '${diff.inHours}h ago';

    String two(int n) => n.toString().padLeft(2, '0');
    final clock = '${two(time.hour)}:${two(time.minute)}';
    final sameDay =
        time.year == current.year &&
        time.month == current.month &&
        time.day == current.day;
    return sameDay ? clock : '${two(time.day)}/${two(time.month)} $clock';
  }
}
