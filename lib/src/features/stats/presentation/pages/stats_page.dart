import 'package:flutter/material.dart';

import '../../../../core/enums/export_format.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/request_stats_entity.dart';
import '../controllers/stats_controller.dart';
import '../widgets/ranked_list.dart';
import '../widgets/stat_card.dart';
import '../widgets/stats_header.dart';
import '../widgets/stats_panel.dart';
import '../widgets/status_distribution.dart';

/// Analytics dashboard: summary cards, status mix and ranked
/// endpoints/hosts.
class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
    required this.controller,
    this.themeMode = ThemeMode.dark,
    this.onThemeModeChanged,
    this.onOpenSettings,
    this.onExport,
    this.onClearAll,
    this.onMinimize,
  });

  /// Owned by the caller, which also disposes it.
  final StatsController controller;

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;
  final VoidCallback? onOpenSettings;
  final ValueChanged<ExportFormat>? onExport;
  final VoidCallback? onClearAll;
  final VoidCallback? onMinimize;

  /// Average latency above this is highlighted in "Slowest endpoints".
  static const Duration slowThreshold = Duration(milliseconds: 400);

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
              themeMode: themeMode,
              onThemeModeChanged: onThemeModeChanged,
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
                  return stats.isEmpty
                      ? const _EmptyStats()
                      : _StatsBody(stats: stats);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.stats});

  final RequestStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final successRate = stats.successRate;

    return ListView(
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
        if (stats.slowestEndpoints.isNotEmpty) ...[
          const SizedBox(height: 16),
          StatsPanel(
            title: 'Slowest endpoints',
            child: RankedList(
              items: [
                for (final e in stats.slowestEndpoints)
                  (
                    label: e.path,
                    value: FormatUtils.duration(e.averageLatency),
                    score: e.averageLatency.inMilliseconds.toDouble(),
                    warn: e.averageLatency > StatsPage.slowThreshold,
                  ),
              ],
            ),
          ),
        ],
        if (stats.mostCalledEndpoints.isNotEmpty) ...[
          const SizedBox(height: 16),
          StatsPanel(
            title: 'Most-called endpoints',
            child: RankedList(
              items: [
                for (final e in stats.mostCalledEndpoints)
                  (
                    label: e.name,
                    value: '${e.count}×',
                    score: e.count.toDouble(),
                    warn: false,
                  ),
              ],
            ),
          ),
        ],
        if (stats.topHosts.isNotEmpty) ...[
          const SizedBox(height: 16),
          StatsPanel(
            title: 'Top hosts',
            child: RankedList(
              items: [
                for (final e in stats.topHosts)
                  (
                    label: e.name,
                    value: '${e.count}×',
                    score: e.count.toDouble(),
                    warn: false,
                  ),
              ],
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
      padding: const EdgeInsetsDirectional.fromSTEB(36, 70, 36, 40),
      child: Column(
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
