import 'package:flutter/material.dart';

import '../../../../core/navigation/dio_lens_navigator.dart';
import '../../../../core/widgets/dio_lens_bottom_nav.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../../di/dio_lens_dependencies.dart';
import '../../../../core/enums/export_format.dart';
import '../../../export/domain/entities/dio_lens_export_file.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../request_detail/presentation/pages/request_detail_page.dart';
import '../../../request_home/presentation/controllers/request_home_controller.dart';
import '../../../request_home/presentation/pages/request_home_page.dart';
import '../../../settings/presentation/pages/settings_sheet.dart';
import '../../../share/domain/entities/dio_lens_share_content.dart';
import '../../../stats/presentation/controllers/stats_controller.dart';
import '../../../stats/presentation/pages/stats_page.dart';

class DioLensHomePage extends StatefulWidget {
  const DioLensHomePage({
    super.key,
    required this.dependencies,
    this.onReplay,
    this.onExport,
    this.onShare,
  });

  final DioLensDependencies dependencies;

  final ValueChanged<RequestDetailEntity>? onReplay;

  final DioLensShareCallback? onShare;

  final Future<DioLensExportFile> Function(DioLensExportFormat format)?
  onExport;

  static const List<DioLensNavItem> tabs = [
    DioLensNavItem(icon: Icons.bolt_rounded, label: 'Requests'),
    DioLensNavItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
  ];

  @override
  State<DioLensHomePage> createState() => _DioLensHomePageState();
}

class _DioLensHomePageState extends State<DioLensHomePage> {
  late final RequestHomeController _homeController = widget.dependencies
      .createRequestHomeController();
  StatsController? _statsController;

  int _tab = 0;

  StatsController get _stats =>
      _statsController ??= widget.dependencies.createStatsController();

  @override
  void dispose() {
    _homeController.dispose();
    _statsController?.dispose();
    super.dispose();
  }

  void _minimize() => Navigator.of(context).maybePop();

  void _openSettings() => showDioLensSettings(
    context,
    createController: widget.dependencies.createSettingsController,
    onExport: widget.onExport == null ? null : _export,
  );

  Future<void> _export(DioLensExportFormat format) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final label = format.extension.toUpperCase();
    String message;
    try {
      final file = await widget.onExport!(format);
      final count = file.requestCount;
      message = 'Exported $count request${count == 1 ? '' : 's'} as $label';
    } catch (error, stack) {
      debugPrint('DioLens: export failed: $error\n$stack');
      message = 'Export failed';
    }
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1600),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DioLensTheme.of(context).background,
      body: IndexedStack(
        index: _tab,
        children: [
          RequestHomePage(
            controller: _homeController,
            onRequestTap: (item) => pushDioLensPage<void>(
              context,
              builder: (_) => RequestDetailPage(
                createController: () =>
                    widget.dependencies.createRequestDetailController(item.id),
                onReplay: widget.onReplay,
                onShare: widget.onShare,
              ),
            ),
            onOpenSettings: _openSettings,
            onExport: widget.onExport == null ? null : _export,
            onMinimize: _minimize,
          ),
          if (_tab == 1 || _statsController != null)
            StatsPage(
              controller: _stats,
              onClearAll: _homeController.clearAll,
              onOpenSettings: _openSettings,
              onExport: widget.onExport == null ? null : _export,
              onMinimize: _minimize,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: DioLensBottomNav(
        items: DioLensHomePage.tabs,
        selectedIndex: _tab,
        onSelected: (i) => setState(() => _tab = i),
      ),
    );
  }
}
