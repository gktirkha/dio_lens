import 'package:flutter/material.dart';

import '../../../../core/navigation/dio_lens_navigator.dart';
import '../../../../core/widgets/dio_lens_bottom_nav.dart';
import '../../../../di/dio_lens_dependencies.dart';
import '../../../request_detail/presentation/pages/request_detail_page.dart';
import '../../../request_home/presentation/controllers/request_home_controller.dart';
import '../../../request_home/presentation/pages/request_home_page.dart';
import '../../../stats/presentation/controllers/stats_controller.dart';
import '../../../stats/presentation/pages/stats_page.dart';

/// Dio Lens' home, pushed by `DioLens.open`: Requests and Stats tabs over
/// a bottom bar. A request tap opens its detail.
///
/// Tabs are lazy: Stats (and its controller) is built on first visit, then
/// kept alive so switching back keeps its scroll position.
class DioLensHomePage extends StatefulWidget {
  const DioLensHomePage({super.key, required this.dependencies});

  final DioLensDependencies dependencies;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: IndexedStack(
            index: _tab,
            children: [
              RequestHomePage(
                controller: _homeController,
                onRequestTap: (item) => pushDioLensPage<void>(
                  context,
                  builder: (_) => RequestDetailPage(
                    createController: () => widget.dependencies
                        .createRequestDetailController(item.id),
                  ),
                ),
                onMinimize: _minimize,
              ),
              if (_tab == 1 || _statsController != null)
                StatsPage(
                  controller: _stats,
                  onClearAll: _homeController.clearAll,
                  onMinimize: _minimize,
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
        DioLensBottomNav(
          items: DioLensHomePage.tabs,
          selectedIndex: _tab,
          onSelected: (i) => setState(() => _tab = i),
        ),
      ],
    );
  }
}
