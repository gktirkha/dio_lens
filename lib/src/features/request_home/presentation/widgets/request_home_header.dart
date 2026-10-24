import 'package:flutter/material.dart';

import '../../../../core/enums/export_format.dart';
import '../../../../core/widgets/dio_lens_icon_button.dart';
import '../../../../core/widgets/dio_lens_menu.dart';
import '../../../../core/widgets/method_chip.dart';
import '../../../../theme/dio_lens_theme.dart';

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
  final ValueChanged<ExportFormat>? onExport;
  final VoidCallback? onClearAll;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final onToggleTheme = this.onToggleTheme;

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
                  DioLensThemeToggleButton(onPressed: onToggleTheme),
                DioLensIconButton(
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
                DioLensOverflowMenu(
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
      style: dioLensMenuStyle(theme),
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
            style: dioLensMenuItemStyle(context),
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
          const DioLensMenuDivider(),
          MenuItemButton(
            style: dioLensMenuItemStyle(context),
            onPressed: onCleared,
            child: const Text('Clear method filter'),
          ),
        ],
      ],
      builder: (context, controller, _) => DioLensIconButton(
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
        DioLensIconButton(
          icon: Icons.close_rounded,
          tooltip: 'Close search',
          onPressed: onClose,
        ),
      ],
    );
  }
}
