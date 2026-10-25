import 'dart:async';

typedef DioLensShareCallback = FutureOr<void> Function(
  DioLensShareContent content,
);

class DioLensShareContent {
  const DioLensShareContent({required this.subject, required this.text});

  final String subject;

  final String text;
}
