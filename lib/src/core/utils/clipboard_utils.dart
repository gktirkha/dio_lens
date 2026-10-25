import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copies [text] and confirms with a short snackbar, e.g. "Host copied".
Future<void> copyToClipboard(
  BuildContext context,
  String text, {
  required String label,
}) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  await Clipboard.setData(ClipboardData(text: text));
  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(milliseconds: 1400),
      ),
    );
}
