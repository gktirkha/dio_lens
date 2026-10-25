import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/request_status_filter.dart';

class StatusFilterBar extends StatelessWidget {
  const StatusFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RequestStatusFilter selected;
  final ValueChanged<RequestStatusFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 12),
      child: Row(
        children: [
          for (final filter in RequestStatusFilter.values) ...[
            if (filter != RequestStatusFilter.values.first)
              const SizedBox(width: 6),
            _FilterChip(
              label: filter.label,
              selected: filter == selected,
              onTap: () => onSelected(filter),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final fg = selected ? theme.onAccent : theme.textMuted;

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? theme.accent : theme.surface2,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? theme.accent : theme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
