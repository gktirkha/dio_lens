import 'package:flutter/material.dart';

import '../../../../core/navigation/dio_lens_navigator.dart';
import '../../../../core/widgets/dio_lens_bottom_nav.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../../di/dio_lens_dependencies.dart';
import '../../../../core/domain/unit.dart';
import '../../../../core/enums/export_format.dart';
import '../../../../core/utils/clipboard_utils.dart';
import '../../../export/domain/entities/dio_lens_export_file.dart';
import '../../../request_detail/domain/entities/request_detail_entity.dart';
import '../../../request_detail/presentation/pages/request_detail_page.dart';
import '../../../request_home/domain/entities/request_list_item_entity.dart';
import '../../../request_home/presentation/controllers/request_home_controller.dart';
import '../../../request_home/presentation/pages/request_home_page.dart';
import '../../../settings/domain/enums/dio_lens_redaction_mode.dart';
import '../../../settings/domain/utils/request_redactor.dart';
import '../../../settings/presentation/pages/settings_sheet.dart';
import '../../../share/domain/entities/dio_lens_share_content.dart';
import '../../../stats/presentation/controllers/stats_controller.dart';
import '../../../stats/presentation/pages/stats_page.dart';

/// The Dio Lens home: Requests and Stats tabs over a bottom bar. Stats is built
/// on first visit, then kept alive.
class DioLensHomePage extends StatefulWidget {
  /// Creates the home page.
  const DioLensHomePage({
    super.key,
    required this.dependencies,
    this.onReplay,
    this.replayUnavailableReason,
    this.canReplayItem,
    this.onExport,
    this.onShare,
  });

  /// Creates the controllers of the tabs and pages.
  final DioLensDependencies dependencies;

  /// Re-sends a request from its detail page.
  final ValueChanged<RequestDetailEntity>? onReplay;

  /// Why a request can't be replayed, or null when it can.
  final String? Function(RequestDetailEntity request)? replayUnavailableReason;

  /// Whether a list row's request can be replayed; hides Replay otherwise.
  final bool Function(RequestListItemEntity item)? canReplayItem;

  /// Receives requests shared from detail pages.
  final DioLensShareCallback? onShare;

  /// Builds an export and hands it to the app; null disables export.
  final Future<DioLensExportFile> Function(DioLensExportFormat format)?
  onExport;

  /// The bottom bar destinations.
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

  /// The full request of a list row; null once it is gone.
  Future<RequestDetailEntity?> _load(RequestListItemEntity item) =>
      widget.dependencies.watchRequestDetailUseCase(item.id).first;

  void _snack(String message) => ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1400),
      ),
    );

  Future<void> _shareItem(RequestListItemEntity item) async {
    final request = await _load(item);
    if (request == null || !mounted) return;
    final settings = await widget.dependencies.watchSettingsUseCase(unit).first;
    final content = await widget.dependencies.buildShareContentUseCase((
      request: request,
      settings: settings,
    ));
    if (!mounted) return;
    if (widget.onShare case final onShare?) {
      await onShare(content);
    } else {
      await copyToClipboard(context, content.text, label: 'Request');
    }
  }

  Future<void> _copyCurlItem(RequestListItemEntity item) async {
    final request = await _load(item);
    if (request == null || !mounted) return;
    final settings = await widget.dependencies.watchSettingsUseCase(unit).first;
    if (!mounted) return;
    final curl = RequestRedactor.redact(
      request,
      settings,
      target: DioLensRedactionTarget.clipboard,
    ).curl;
    await copyToClipboard(context, curl, label: 'cURL');
  }

  Future<void> _replayItem(RequestListItemEntity item) async {
    final request = await _load(item);
    if (request == null || !mounted) return;
    if (widget.replayUnavailableReason?.call(request) case final reason?) {
      _snack("Can't replay: $reason");
      return;
    }
    widget.onReplay?.call(request);
    _snack('Request replayed');
  }

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
                replayUnavailableReason: widget.replayUnavailableReason,
                onShare: widget.onShare,
              ),
            ),
            onRequestShare: _shareItem,
            onRequestCopyCurl: _copyCurlItem,
            onRequestReplay: widget.onReplay == null ? null : _replayItem,
            canReplay: widget.canReplayItem,
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
