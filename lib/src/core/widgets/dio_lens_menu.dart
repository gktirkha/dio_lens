import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';
import '../enums/export_format.dart';
import 'dio_lens_icon_button.dart';

/// Popover style for Dio Lens [MenuAnchor]s. Anchored to the button's end
/// edge; the menu layout keeps it on screen in both LTR and RTL.
MenuStyle dioLensMenuStyle(DioLensTheme theme, {double minWidth = 198}) {
  return MenuStyle(
    backgroundColor: WidgetStatePropertyAll(theme.surface2),
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    elevation: const WidgetStatePropertyAll(8),
    shadowColor: WidgetStatePropertyAll(theme.shadow.color),
    padding: const WidgetStatePropertyAll(EdgeInsets.all(6)),
    alignment: AlignmentDirectional.bottomEnd,
    minimumSize: WidgetStatePropertyAll(Size(minWidth, 0)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radiusMedium),
        side: BorderSide(color: theme.border),
      ),
    ),
  );
}

/// Item style for menus built with [dioLensMenuStyle].
ButtonStyle dioLensMenuItemStyle(BuildContext context, {Color? foreground}) {
  final theme = DioLensTheme.of(context);
  // styleFrom replaces the whole text style, so start from the theme's
  // body style to keep its font family.
  final textStyle = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
  return MenuItemButton.styleFrom(
    foregroundColor: foreground ?? theme.text,
    iconColor: foreground ?? theme.textMuted,
    iconSize: 16,
    textStyle: textStyle.copyWith(fontSize: 13.5),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    minimumSize: const Size.fromHeight(38),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}

/// Thin separator between menu sections.
class DioLensMenuDivider extends StatelessWidget {
  const DioLensMenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Divider(height: 1, color: DioLensTheme.of(context).border),
    );
  }
}

/// The ⋮ menu shared by Dio Lens screens: settings, export, clear all and
/// minimize. Items whose callback is null are disabled.
class DioLensOverflowMenu extends StatelessWidget {
  const DioLensOverflowMenu({
    super.key,
    this.onOpenSettings,
    this.onExport,
    this.onClearAll,
    this.onMinimize,
  });

  final VoidCallback? onOpenSettings;
  final ValueChanged<ExportFormat>? onExport;
  final VoidCallback? onClearAll;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final itemStyle = dioLensMenuItemStyle(context);
    final onExport = this.onExport;

    return MenuAnchor(
      style: dioLensMenuStyle(theme, minWidth: 232),
      alignmentOffset: const Offset(0, 4),
      menuChildren: [
        MenuItemButton(
          style: itemStyle,
          leadingIcon: const Icon(Icons.settings_outlined),
          onPressed: onOpenSettings,
          child: const Text('Settings'),
        ),
        MenuItemButton(
          style: itemStyle,
          leadingIcon: const Icon(Icons.download_rounded),
          onPressed: onExport == null ? null : () => onExport(ExportFormat.har),
          child: const Text('Export as HAR'),
        ),
        MenuItemButton(
          style: itemStyle,
          leadingIcon: const Icon(Icons.download_rounded),
          onPressed: onExport == null
              ? null
              : () => onExport(ExportFormat.json),
          child: const Text('Export as JSON'),
        ),
        const DioLensMenuDivider(),
        MenuItemButton(
          style: dioLensMenuItemStyle(context, foreground: theme.danger),
          leadingIcon: const Icon(Icons.delete_outline_rounded),
          onPressed: onClearAll,
          child: const Text('Clear all requests'),
        ),
        const DioLensMenuDivider(),
        MenuItemButton(
          style: itemStyle,
          leadingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: onMinimize,
          child: const Text('Minimize Dio Lens'),
        ),
      ],
      builder: (context, controller, _) => DioLensIconButton(
        icon: Icons.more_vert_rounded,
        tooltip: 'More options',
        active: controller.isOpen,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
