import 'package:flutter/material.dart';

import '../../../../core/enums/export_format.dart';
import '../../../../core/navigation/dio_lens_navigator.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/dio_lens_refresh_indicator.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/request_stats_entity.dart';
import '../controllers/stats_controller.dart';
import '../models/stats_ranking.dart';
import 'stats_ranking_page.dart';
import '../widgets/ranked_list.dart';
import '../widgets/stat_card.dart';
import '../widgets/stats_header.dart';
import '../widgets/stats_panel.dart';
import '../widgets/status_distribution.dart';

/// Stats of the captured requests: summary cards, status distribution and
/// ranked lists.
class StatsPage extends StatelessWidget {
  /// Creates the page.
  const StatsPage({
    super.key,
    required this.controller,
    this.onOpenSettings,
    this.onExport,
    this.onClearAll,
    this.onMinimize,
  });

  /// Owned by the caller, which also disposes it.
  final StatsController controller;

  /// Opens the settings sheet.
  final VoidCallback? onOpenSettings;

  /// Exports in the chosen format; null disables export.
  final ValueChanged<DioLensExportFormat>? onExport;

  /// Removes every request.
  final VoidCallback? onClearAll;

  /// Closes Dio Lens.
  final VoidCallback? onMinimize;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Material(
      color: theme.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatsHeader(
              onOpenSettings: onOpenSettings,
              onExport: onExport,
              onClearAll: onClearAll,
              onMinimize: onMinimize,
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  if (controller.isLoading) return const SizedBox.shrink();
                  final stats = controller.stats;
                  return DioLensRefreshIndicator(
                    onRefresh: controller.refresh,
                    child: stats.isEmpty
                        ? const _EmptyStats()
                        : _StatsBody(
                            stats: stats,
                            onOpenRanking: (ranking) =>
                                _openRanking(context, ranking),
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

  void _openRanking(BuildContext context, StatsRanking ranking) {
    pushDioLensPage<void>(
      context,
      builder: (_) =>
          StatsRankingPage(controller: controller, ranking: ranking),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.stats, required this.onOpenRanking});

  final RequestStatsEntity stats;
  final ValueChanged<StatsRanking> onOpenRanking;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final successRate = stats.successRate;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 18),
      children: [
        StatCardGrid(
          cards: [
            StatCard(label: 'Total requests', value: '${stats.totalRequests}'),
            StatCard(
              label: 'Success rate',
              value: successRate == null
                  ? '—'
                  : '${(successRate * 100).toStringAsFixed(1)}%',
              valueColor: theme.success,
            ),
            StatCard(
              label: 'Avg latency',
              value: FormatUtils.duration(stats.averageLatency),
            ),
            StatCard(
              label: 'p95 latency',
              value: FormatUtils.duration(stats.p95Latency),
            ),
            StatCard(
              label: 'Data transferred',
              value: FormatUtils.bytes(stats.totalBytes),
            ),
            StatCard(
              label: 'Error count',
              value: '${stats.errorCount}',
              valueColor: theme.danger,
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatsPanel(
          title: 'Status code distribution',
          child: StatusDistribution(
            shares: stats.statusDistribution,
            total: stats.totalRequests,
          ),
        ),
        for (final ranking in StatsRanking.values)
          if (ranking.items(stats) case final items when items.isNotEmpty) ...[
            const SizedBox(height: 16),
            StatsPanel(
              title: ranking.title,
              onTap: () => onOpenRanking(ranking),
              child: RankedList(
                items: items.take(StatsRanking.previewCount).toList(),
              ),
            ),
          ],
      ],
    );
  }
}

class _EmptyStats extends StatelessWidget {
  const _EmptyStats();

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(36, 70, 36, 40),
      child: Column(
        // Full width, so the icon and centered text sit in the middle.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.bar_chart_rounded, size: 40, color: theme.textFaint),
          const SizedBox(height: 10),
          Text(
            'No stats yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.text,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Stats appear once Dio Lens has captured some requests.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: theme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
