import 'package:flutter/material.dart';

import '../../theme/dio_lens_theme.dart';

/// One destination of a [DioLensBottomNav].
class DioLensNavItem {
  /// Creates a destination.
  const DioLensNavItem({required this.icon, required this.label});

  /// Icon above the label.
  final IconData icon;

  /// Label under the icon.
  final String label;
}

/// The bottom tab bar of the Dio Lens home: icon over label, accent when
/// selected.
class DioLensBottomNav extends StatelessWidget {
  /// Creates the tab bar.
  const DioLensBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  /// The destinations, in order.
  final List<DioLensNavItem> items;

  /// Index of the selected destination in [items].
  final int selectedIndex;

  /// Called with the index of a tapped destination.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Material(
      color: theme.background.withValues(alpha: 0.92),
      shape: Border(top: BorderSide(color: theme.border)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 2),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: items[i],
                    selected: i == selectedIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DioLensNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final color = selected ? theme.accent : theme.textFaint;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 21, color: color),
              const SizedBox(height: 3),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
