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

  /// File extension for a MIME type: `.json`, `.jpg`, `.png`, `.txt`,
  /// `.html`, `.pdf`, `.bin`…; `form` for form data (no extension); `—`
  /// when unknown.
  static String shortContentType(String? mime) {
    if (mime == null || mime.trim().isEmpty) return '—';
    final type = mime.split(';').first.trim().toLowerCase();
    final known = _contentTypeLabels[type];
    if (known != null) return known;

    final slash = type.indexOf('/');
    var subtype = slash >= 0 ? type.substring(slash + 1) : type;
    // Structured suffixes: application/problem+json → .json, …+xml → .xml.
    final plus = subtype.lastIndexOf('+');
    if (plus >= 0) subtype = subtype.substring(plus + 1);
    subtype = subtype.replaceFirst(RegExp(r'^(x-|vnd\.)'), '');
    return subtype.isEmpty ? mime : '.$subtype';
  }

  /// MIME types whose extension differs from their subtype.
  static const Map<String, String> _contentTypeLabels = {
    'application/x-www-form-urlencoded': 'form',
    'multipart/form-data': 'form',
    'application/octet-stream': '.bin',
    'application/javascript': '.js',
    'text/javascript': '.js',
    'text/plain': '.txt',
    'text/markdown': '.md',
    'image/jpeg': '.jpg',
    'image/jpg': '.jpg',
    'image/pjpeg': '.jpg',
    'image/svg+xml': '.svg',
    'image/x-icon': '.ico',
    'image/vnd.microsoft.icon': '.ico',
    'application/gzip': '.gz',
    'audio/mpeg': '.mp3',
    'video/quicktime': '.mov',
  };

  /// Wall-clock time with milliseconds: `14:32:07.182`.
  static String clockTime(DateTime time) {
    String two(int n) => n.toString().padLeft(2, '0');
    final ms = time.millisecond.toString().padLeft(3, '0');
    return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}.$ms';
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
