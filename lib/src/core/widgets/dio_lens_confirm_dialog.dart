import 'package:material_ui/material_ui.dart';

import '../../theme/dio_lens_theme.dart';
import '../../theme/dio_lens_theme_scope.dart';
import '../utils/host_app.dart';

/// Asks before a destructive action, in the Dio Lens theme. Completes with
/// true once the user confirms with [action]; false when they cancel or
/// dismiss the dialog.
Future<bool> showDioLensConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String action,
}) async {
  final themeController = DioLensThemeScope.controllerOf(context);
  final mode = DioLensThemeScope.modeOf(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => withMaterialLocalizations(
      context,
      DioLensThemeScope(
        controller: themeController,
        mode: mode,
        child: _ConfirmDialog(title: title, message: message, action: action),
      ),
    ),
  );
  return confirmed ?? false;
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.action,
  });

  final String title;
  final String message;
  final String action;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return AlertDialog(
      title: Text(title),
      content: Text(
        message,
        style: TextStyle(color: theme.textMuted, fontSize: 13.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: theme.textMuted),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: theme.danger,
            foregroundColor: Colors.white,
          ),
          child: Text(action),
        ),
      ],
    );
  }
}
