import 'package:material_ui/material_ui.dart';

import '../../../../theme/dio_lens_theme.dart';
import '../../../../core/widgets/dio_lens_confirm_dialog.dart';
import '../../../settings/domain/enums/dio_lens_delete_confirmation.dart';
import '../../domain/entities/request_list_item_entity.dart';
import '../../../../core/enums/export_format.dart';
import '../../../../core/widgets/dio_lens_refresh_indicator.dart';
import '../controllers/request_home_controller.dart';
import '../widgets/request_empty_state.dart';
import '../widgets/request_group_header.dart';
import '../widgets/request_home_header.dart';
import '../widgets/request_list_tile.dart';
import '../widgets/status_filter_bar.dart';

/// Clears every request through [controller], asking first when the settings
/// say so.
Future<void> clearAllRequests(
  BuildContext context,
  RequestHomeController controller,
) async {
  final ask = controller.settings.confirmsDelete(DioLensDeleteConfirmation.all);
  if (ask &&
      !await showDioLensConfirmDialog(
        context,
        title: 'Clear all requests?',
        message: 'Clear all captured requests? This cannot be undone.',
        action: 'Clear all',
      )) {
    return;
  }
  await controller.clearAll();
}

/// Request list of the Dio Lens home: header with search and filters, status
/// chips and requests grouped by time.
class RequestHomePage extends StatefulWidget {
  /// Creates the page.
  const RequestHomePage({
    super.key,
    required this.controller,
    this.onRequestTap,
    this.onRequestShare,
    this.onRequestCopyCurl,
    this.onRequestReplay,
    this.canReplay,
    this.onOpenSettings,
    this.onExport,
    this.onMinimize,
  });

  /// Owned by the caller, which also disposes it.
  final RequestHomeController controller;

  /// Opens a request's detail page.
  final ValueChanged<RequestListItemEntity>? onRequestTap;

  /// Shares a request from its row; null hides Share.
  final ValueChanged<RequestListItemEntity>? onRequestShare;

  /// Copies a request's cURL command from its row; null hides the button.
  final ValueChanged<RequestListItemEntity>? onRequestCopyCurl;

  /// Re-sends a request from its row; null hides Replay.
  final ValueChanged<RequestListItemEntity>? onRequestReplay;

  /// Whether a row's request can be replayed; Replay is hidden otherwise.
  final bool Function(RequestListItemEntity item)? canReplay;

  /// Opens the settings sheet.
  final VoidCallback? onOpenSettings;

  /// Exports in the chosen format; null disables export.
  final ValueChanged<DioLensExportFormat>? onExport;

  /// Closes Dio Lens.
  final VoidCallback? onMinimize;

  /// Requests newer than this are grouped as "Just now".
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

  Future<void> _confirmClearAll() => clearAllRequests(context, _controller);

  Future<void> _delete(RequestListItemEntity item) async {
    final ask = _controller.settings.confirmsDelete(
      DioLensDeleteConfirmation.single,
    );
    if (ask &&
        !await showDioLensConfirmDialog(
          context,
          title: 'Delete request?',
          message: 'Delete ${item.method} ${item.path}? This cannot be undone.',
          action: 'Delete',
        )) {
      return;
    }
    await _controller.deleteRequest(item.id);
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
    final canDelete = _controller.settings.isDeleteAllowed;

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
              showClearAll: canDelete,
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
              settings: _controller.settings,
              onTap: widget.onRequestTap == null
                  ? null
                  : () => widget.onRequestTap!(item),
              onShare: widget.onRequestShare == null
                  ? null
                  : () => widget.onRequestShare!(item),
              onCopyCurl: widget.onRequestCopyCurl == null
                  ? null
                  : () => widget.onRequestCopyCurl!(item),
              onReplay:
                  widget.onRequestReplay == null ||
                      !(widget.canReplay?.call(item) ?? true)
                  ? null
                  : () => widget.onRequestReplay!(item),
              onDelete: _controller.settings.isDeleteAllowed
                  ? () => _delete(item)
                  : null,
            );
          },
        ),
      ],
    );
  }
}
