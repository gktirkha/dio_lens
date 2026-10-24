import 'package:flutter/material.dart';

import '../../../../core/widgets/method_chip.dart';
import '../../../../theme/dio_lens_theme.dart';

/// Export formats offered in the overflow menu.
enum RequestExportFormat { har, json }

/// Top bar of the request home page: brand, quick actions, method filter,
/// overflow menu and the collapsible search field.
class RequestHomeHeader extends StatelessWidget {
  const RequestHomeHeader({
    super.key,
    required this.searchOpen,
    required this.searchController,
    required this.onSearchOpen,
    required this.onSearchClose,
    required this.selectedMethods,
    required this.onMethodToggled,
    required this.onMethodsCleared,
    this.onToggleTheme,
    this.onOpenSettings,
    this.onExport,
    this.onClearAll,
    this.onMinimize,
  });

  static const List<String> filterMethods = [
    'GET',
    'POST',
    'PUT',
    'PATCH',
    'DELETE',
  ];

  final bool searchOpen;
  final TextEditingController searchController;
  final VoidCallback onSearchOpen;
  final VoidCallback onSearchClose;

  final Set<String> selectedMethods;
  final ValueChanged<String> onMethodToggled;
  final VoidCallback onMethodsCleared;

  final VoidCallback? onToggleTheme;
  final VoidCallback? onOpenSettings;
  final ValueChanged<RequestExportFormat>? onExport;
  final VoidCallback? onClearAll;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border(bottom: BorderSide(color: theme.border)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const _BrandMark(),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Dio Lens',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.17,
                      color: theme.text,
                    ),
                  ),
                ),
                if (onToggleTheme != null)
                  _HeaderIconButton(
                    icon: isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    tooltip: 'Switch to ${isDark ? 'light' : 'dark'} theme',
                    onPressed: onToggleTheme,
                  ),
                _HeaderIconButton(
                  icon: Icons.search_rounded,
                  tooltip: 'Search requests',
                  onPressed: searchOpen ? onSearchClose : onSearchOpen,
                  active: searchOpen,
                ),
                _MethodFilterMenu(
                  selected: selectedMethods,
                  onToggled: onMethodToggled,
                  onCleared: onMethodsCleared,
                ),
                _OverflowMenu(
                  onOpenSettings: onOpenSettings,
                  onExport: onExport,
                  onClearAll: onClearAll,
                  onMinimize: onMinimize,
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: searchOpen
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(top: 8, end: 6),
                      child: _SearchField(
                        controller: searchController,
                        onClose: onSearchClose,
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [Color(0xFF3C6DFF), Color(0xFF203BB8)],
        ),
      ),
      child: const Icon(Icons.bolt_rounded, size: 17, color: Color(0xFFEEF2FF)),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.active = false,
    this.showDot = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool active;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        foregroundColor: active ? theme.accent : theme.textMuted,
        backgroundColor: active ? theme.surface3 : Colors.transparent,
      ),
      icon: Badge(
        isLabelVisible: showDot,
        smallSize: 7,
        backgroundColor: theme.accent,
        child: Icon(icon, size: 19),
      ),
    );
  }
}

MenuStyle _menuStyle(DioLensTheme theme, {double minWidth = 198}) {
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

ButtonStyle _menuItemStyle(BuildContext context, {Color? foreground}) {
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

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Divider(height: 1, color: DioLensTheme.of(context).border),
    );
  }
}

class _MethodFilterMenu extends StatelessWidget {
  const _MethodFilterMenu({
    required this.selected,
    required this.onToggled,
    required this.onCleared,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggled;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return MenuAnchor(
      style: _menuStyle(theme),
      alignmentOffset: const Offset(0, 4),
      menuChildren: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 4),
          child: Text(
            'METHOD',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.55,
              color: theme.textFaint,
            ),
          ),
        ),
        for (final method in RequestHomeHeader.filterMethods)
          MenuItemButton(
            closeOnActivate: false,
            style: _menuItemStyle(context),
            onPressed: () => onToggled(method),
            trailingIcon: selected.contains(method)
                ? Icon(Icons.check_rounded, size: 16, color: theme.accent)
                : const SizedBox(width: 16),
            child: SizedBox(
              width: 140,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: MethodChip(method: method),
              ),
            ),
          ),
        if (selected.isNotEmpty) ...[
          const _MenuDivider(),
          MenuItemButton(
            style: _menuItemStyle(context),
            onPressed: onCleared,
            child: const Text('Clear method filter'),
          ),
        ],
      ],
      builder: (context, controller, _) => _HeaderIconButton(
        icon: Icons.tune_rounded,
        tooltip: 'Filter by method',
        active: controller.isOpen,
        showDot: selected.isNotEmpty,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({
    this.onOpenSettings,
    this.onExport,
    this.onClearAll,
    this.onMinimize,
  });

  final VoidCallback? onOpenSettings;
  final ValueChanged<RequestExportFormat>? onExport;
  final VoidCallback? onClearAll;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final itemStyle = _menuItemStyle(context);

    return MenuAnchor(
      style: _menuStyle(theme, minWidth: 232),
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
              : () => onExport!(RequestExportFormat.har),
          child: const Text('Export as HAR'),
        ),
        MenuItemButton(
          style: itemStyle,
          leadingIcon: const Icon(Icons.download_rounded),
          onPressed: onExport == null
              ? null
              : () => onExport!(RequestExportFormat.json),
          child: const Text('Export as JSON'),
        ),
        const _MenuDivider(),
        MenuItemButton(
          style: _menuItemStyle(context, foreground: theme.danger),
          leadingIcon: const Icon(Icons.delete_outline_rounded),
          onPressed: onClearAll,
          child: const Text('Clear all requests'),
        ),
        const _MenuDivider(),
        MenuItemButton(
          style: itemStyle,
          leadingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: onMinimize,
          child: const Text('Minimize Dio Lens'),
        ),
      ],
      builder: (context, controller, _) => _HeaderIconButton(
        icon: Icons.more_vert_rounded,
        tooltip: 'More options',
        active: controller.isOpen,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onClose});

  final TextEditingController controller;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            style: TextStyle(fontSize: 14, color: theme.text),
            decoration: const InputDecoration(
              hintText: 'Search path, host…',
              prefixIcon: Icon(Icons.search_rounded, size: 17),
              prefixIconConstraints: BoxConstraints(
                minWidth: 38,
                minHeight: 38,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _HeaderIconButton(
          icon: Icons.close_rounded,
          tooltip: 'Close search',
          onPressed: onClose,
        ),
      ],
    );
  }
}
