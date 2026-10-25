import 'package:flutter/material.dart';

import '../../../../core/enums/export_format.dart';
import '../../../../core/widgets/dio_lens_icon_button.dart';
import '../../../../core/widgets/dio_lens_menu.dart';
import '../../../../theme/dio_lens_theme.dart';

/// Top bar of the stats page: title, theme toggle and overflow menu.
class StatsHeader extends StatelessWidget {
  const StatsHeader({
    super.key,
    this.onOpenSettings,
    this.onExport,
    this.onClearAll,
    this.onMinimize,
  });

  final VoidCallback? onOpenSettings;
  final ValueChanged<DioLensExportFormat>? onExport;
  final VoidCallback? onClearAll;
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border(bottom: BorderSide(color: theme.border)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 10, 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Stats',
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
            const DioLensThemeToggleButton(),
            DioLensOverflowMenu(
              onOpenSettings: onOpenSettings,
              onExport: onExport,
              onClearAll: onClearAll,
              onMinimize: onMinimize,
            ),
          ],
        ),
      ),
    );
  }
}
