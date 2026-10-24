import 'package:flutter/material.dart';

import '../../../../theme/dio_lens_theme.dart';
import '../../domain/entities/request_list_item_entity.dart';
import '../models/request_status_filter.dart';
import '../widgets/request_empty_state.dart';
import '../widgets/request_group_header.dart';
import '../widgets/request_home_header.dart';
import '../widgets/request_list_tile.dart';
import '../widgets/status_filter_bar.dart';

/// The inspector's home screen: every captured request, newest first, with
/// status/method filters and search.
///
/// Filtering and search are local UI state for now; data and actions come
/// from the caller.
class RequestHomePage extends StatefulWidget {
  const RequestHomePage({
    super.key,
    required this.requests,
    this.onRequestTap,
    this.onRequestDelete,
    this.onClearAll,
    this.onToggleTheme,
    this.onOpenSettings,
    this.onExport,
    this.onMinimize,
  });

  /// Captured requests, newest first.
  final List<RequestListItemEntity> requests;

  final ValueChanged<RequestListItemEntity>? onRequestTap;
  final ValueChanged<RequestListItemEntity>? onRequestDelete;

  /// Called after the user confirms "Clear all requests".
  final VoidCallback? onClearAll;
  final VoidCallback? onToggleTheme;
  final VoidCallback? onOpenSettings;
  final ValueChanged<RequestExportFormat>? onExport;
  final VoidCallback? onMinimize;

  /// Requests started within this window are grouped under "Just now".
  static const Duration recentWindow = Duration(minutes: 5);

  @override
  State<RequestHomePage> createState() => _RequestHomePageState();
}

class _RequestHomePageState extends State<RequestHomePage> {
  final _searchController = TextEditingController();
  RequestStatusFilter _statusFilter = RequestStatusFilter.all;
  final Set<String> _methods = {};
  bool _searchOpen = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesMethodAndSearch(RequestListItemEntity r) {
    if (_methods.isNotEmpty && !_methods.contains(r.method.toUpperCase())) {
      return false;
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return true;
    final haystack = '${r.method} ${r.host} ${r.path} ${r.query ?? ''}'
        .toLowerCase();
    return haystack.contains(query);
  }

  void _closeSearch() {
    _searchController.clear();
    setState(() => _searchOpen = false);
  }

  Future<void> _confirmClearAll() async {
    final theme = DioLensTheme.of(context);
    final count = widget.requests.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all requests?'),
        content: Text(
          'Clear all $count captured requests? This cannot be undone.',
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
    if (confirmed ?? false) widget.onClearAll?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);

    final visible = widget.requests
        .where(
          (r) =>
              _statusFilter.matches(r.statusClass) &&
              _matchesMethodAndSearch(r),
        )
        .toList();

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
              selectedMethods: _methods,
              onMethodToggled: (m) => setState(() {
                if (!_methods.remove(m)) _methods.add(m);
              }),
              onMethodsCleared: () => setState(_methods.clear),
              onToggleTheme: widget.onToggleTheme,
              onOpenSettings: widget.onOpenSettings,
              onExport: widget.onExport,
              onClearAll: widget.requests.isEmpty ? null : _confirmClearAll,
              onMinimize: widget.onMinimize,
            ),
            StatusFilterBar(
              selected: _statusFilter,
              onSelected: (f) => setState(() => _statusFilter = f),
            ),
            Expanded(
              child: visible.isEmpty
                  ? SingleChildScrollView(
                      child: RequestEmptyState(
                        filtered: widget.requests.isNotEmpty,
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        if (recent.isNotEmpty)
                          ..._group(context, 'Just now', recent),
                        if (earlier.isNotEmpty)
                          ..._group(context, 'Earlier', earlier),
                        const SliverPadding(
                          padding: EdgeInsets.only(bottom: 18),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _group(
    BuildContext context,
    String label,
    List<RequestListItemEntity> items,
  ) {
    final theme = DioLensTheme.of(context);
    return [
      SliverToBoxAdapter(child: RequestGroupHeader(label: label)),
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
            onDelete: widget.onRequestDelete == null
                ? null
                : () => widget.onRequestDelete!(item),
          );
        },
      ),
    ];
  }
}
