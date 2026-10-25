import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';
import '../enums/export_format.dart';
import 'dio_lens_icon_button.dart';

/// Style of Dio Lens popup menus, at least [minWidth] wide.
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

/// Style of a Dio Lens menu item, optionally tinted [foreground].
ButtonStyle dioLensMenuItemStyle(BuildContext context, {Color? foreground}) {
  final theme = DioLensTheme.of(context);
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

/// Thin line between groups of menu items.
class DioLensMenuDivider extends StatelessWidget {
  /// Creates a menu divider.
  const DioLensMenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Divider(height: 1, color: DioLensTheme.of(context).border),
    );
  }
}

/// The "More options" menu of the Dio Lens headers: settings, export, clear and
/// minimize.
class DioLensOverflowMenu extends StatelessWidget {
  /// Creates the overflow menu.
  const DioLensOverflowMenu({
    super.key,
    this.onOpenSettings,
    this.onExport,
    this.onClearAll,
    this.onMinimize,
  });

  /// Opens the settings sheet; null disables the item.
  final VoidCallback? onOpenSettings;

  /// Exports in the chosen format; null disables the export items.
  final ValueChanged<DioLensExportFormat>? onExport;

  /// Removes every captured request; null disables the item.
  final VoidCallback? onClearAll;

  /// Closes Dio Lens; null disables the item.
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
          onPressed: onExport == null
              ? null
              : () => onExport(DioLensExportFormat.har),
          child: const Text('Export as HAR'),
        ),
        MenuItemButton(
          style: itemStyle,
          leadingIcon: const Icon(Icons.download_rounded),
          onPressed: onExport == null
              ? null
              : () => onExport(DioLensExportFormat.json),
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
