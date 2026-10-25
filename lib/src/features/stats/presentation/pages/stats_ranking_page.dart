import 'package:flutter/material.dart';

import '../../../../core/widgets/dio_lens_icon_button.dart';
import '../../../../core/widgets/dio_lens_refresh_indicator.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../controllers/stats_controller.dart';
import '../models/stats_ranking.dart';
import '../widgets/ranked_list.dart';
import '../widgets/stats_panel.dart';

class StatsRankingPage extends StatelessWidget {
  const StatsRankingPage({
    super.key,
    required this.controller,
    required this.ranking,
  });

  final StatsController controller;
  final StatsRanking ranking;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RankingHeader(title: ranking.title),
            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final items = ranking.items(controller.stats);
                  return DioLensRefreshIndicator(
                    onRefresh: controller.refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        16,
                        12,
                        16,
                        18,
                      ),
                      children: [
                        if (items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Text(
                              'Nothing to rank yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: theme.textMuted,
                              ),
                            ),
                          )
                        else
                          StatsPanel(child: RankedList(items: items)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingHeader extends StatelessWidget {
  const _RankingHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border(bottom: BorderSide(color: theme.border)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(6, 10, 10, 10),
        child: Row(
          children: [
            DioLensIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
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
          ],
        ),
      ),
    );
  }
}
