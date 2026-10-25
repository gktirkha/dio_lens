import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/request_list_item_entity.dart';
import '../../../../core/enums/export_format.dart';
import '../../../../core/widgets/dio_lens_refresh_indicator.dart';
import '../controllers/request_home_controller.dart';
import '../widgets/request_empty_state.dart';
import '../widgets/request_group_header.dart';
import '../widgets/request_home_header.dart';
import '../widgets/request_list_tile.dart';
import '../widgets/status_filter_bar.dart';

/// The inspector's home screen: every captured request, newest first, with
/// status/method filters and search.
///
/// Data, filters and delete/clear go through [controller]; navigation-style
/// actions are reported through the callbacks.
class RequestHomePage extends StatefulWidget {
  const RequestHomePage({
    super.key,
    required this.controller,
    this.onRequestTap,
    this.onOpenSettings,
    this.onExport,
    this.onMinimize,
  });

  /// Owned by the caller, which also disposes it.
  final RequestHomeController controller;

  final ValueChanged<RequestListItemEntity>? onRequestTap;
  final VoidCallback? onOpenSettings;
  final ValueChanged<ExportFormat>? onExport;
  final VoidCallback? onMinimize;

  /// Requests started within this window are grouped under "Just now".
  static const Duration recentWindow = Duration(minutes: 5);

  @override
  State<RequestHomePage> createState() => _RequestHomePageState();
}

class _RequestHomePageState extends State<RequestHomePage> {
  late final _searchController = TextEditingController(
    text: widget.controller.params.search,
  )..addListener(_onSearchChanged);
  bool _searchOpen = false;

  RequestHomeController get _controller => widget.controller;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => _controller.setSearch(_searchController.text);

  void _closeSearch() {
    _searchController.clear();
    _controller.setSearch('', immediate: true);
    setState(() => _searchOpen = false);
  }

  Future<void> _confirmClearAll() async {
    final theme = DioLensTheme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all requests?'),
        content: Text(
          'Clear all captured requests? This cannot be undone.',
          style: TextStyle(color: theme.textMuted, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: theme.textMuted),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await _controller.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final params = _controller.params;
    final visible = _controller.requests;

    final now = DateTime.now();
    final recent = <RequestListItemEntity>[];
    final earlier = <RequestListItemEntity>[];
    for (final r in visible) {
      (now.difference(r.startedAt) < RequestHomePage.recentWindow
              ? recent
              : earlier)
          .add(r);
    }

    return Material(
      color: theme.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RequestHomeHeader(
              searchOpen: _searchOpen,
              searchController: _searchController,
              onSearchOpen: () => setState(() => _searchOpen = true),
              onSearchClose: _closeSearch,
              selectedMethods: params.methods,
              onMethodToggled: _controller.toggleMethod,
              onMethodsCleared: _controller.clearMethods,
              onOpenSettings: widget.onOpenSettings,
              onExport: widget.onExport,
              onClearAll: visible.isEmpty && params.isEmpty
                  ? null
                  : _confirmClearAll,
              onMinimize: widget.onMinimize,
            ),
            StatusFilterBar(
              selected: params.status,
              onSelected: _controller.setStatus,
            ),
            Expanded(
              child: _controller.isLoading
                  ? const SizedBox.shrink()
                  : DioLensRefreshIndicator(
                      onRefresh: _controller.refresh,
                      child: visible.isEmpty
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: RequestEmptyState(
                                filtered: !params.isEmpty,
                              ),
                            )
                          : CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                if (recent.isNotEmpty)
                                  _group(context, 'Just now', recent),
                                if (earlier.isNotEmpty)
                                  _group(context, 'Earlier', earlier),
                                const SliverPadding(
                                  padding: EdgeInsets.only(bottom: 18),
                                ),
                              ],
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// One section of the list. The header stays pinned to the top while its
  /// group scrolls, and the next group's header pushes it out.
  Widget _group(
    BuildContext context,
    String label,
    List<RequestListItemEntity> items,
  ) {
    final theme = DioLensTheme.of(context);
    return SliverMainAxisGroup(
      slivers: [
        PinnedHeaderSliver(child: RequestGroupHeader(label: label)),
        SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => Divider(height: 1, color: theme.border),
          itemBuilder: (context, i) {
            final item = items[i];
            return RequestListTile(
              key: ValueKey(item.id),
              item: item,
              onTap: widget.onRequestTap == null
                  ? null
                  : () => widget.onRequestTap!(item),
              onDelete: () => _controller.deleteRequest(item.id),
            );
          },
        ),
      ],
    );
  }
}
