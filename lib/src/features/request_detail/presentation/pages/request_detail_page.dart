import 'package:flutter/material.dart';

import '../../../../core/utils/clipboard_utils.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../domain/entities/request_detail_entity.dart';
import '../controllers/request_detail_controller.dart';
import '../widgets/overview_tab.dart';
import '../widgets/request_detail_header.dart';
import '../widgets/request_tab.dart';
import '../widgets/response_tab.dart';

/// One captured request: header, quick actions and Overview / Request /
/// Response tabs.
///
/// Creates its controller with [createController] and disposes it, so it
/// can be pushed as a route directly.
class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({
    super.key,
    required this.createController,
    this.onShare,
    this.onReplay,
  });

  final RequestDetailController Function() createController;
  final ValueChanged<RequestDetailEntity>? onShare;
  final ValueChanged<RequestDetailEntity>? onReplay;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  late final RequestDetailController _controller = widget.createController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _replay(RequestDetailEntity request) {
    widget.onReplay?.call(request);
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Request replayed'),
          duration: Duration(milliseconds: 1400),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading) return const SizedBox.shrink();
            final request = _controller.request;
            if (request == null) return const _RequestGone();
            return _DetailBody(
              request: request,
              settings: _controller.settings,
              onShare: widget.onShare,
              onReplay: widget.onReplay == null ? null : _replay,
            );
          },
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.request,
    required this.settings,
    this.onShare,
    this.onReplay,
  });

  final RequestDetailEntity request;
  final DioLensSettings settings;
  final ValueChanged<RequestDetailEntity>? onShare;
  final ValueChanged<RequestDetailEntity>? onReplay;

  static const _tabs = ['Overview', 'Request', 'Response'];

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    final onShare = this.onShare;
    final onReplay = this.onReplay;

    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.background,
              border: Border(bottom: BorderSide(color: theme.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RequestDetailHeader(
                  request: request,
                  onCopyCurl: () =>
                      copyToClipboard(context, request.curl, label: 'cURL'),
                  onShare: onShare == null ? null : () => onShare(request),
                  onReplay: onReplay == null ? null : () => onReplay(request),
                ),
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: theme.accent,
                  unselectedLabelColor: theme.textFaint,
                  labelStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: [for (final t in _tabs) Tab(text: t, height: 42)],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                OverviewTab(request: request, settings: settings),
                RequestTab(request: request, settings: settings),
                ResponseTab(request: request, settings: settings),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestGone extends StatelessWidget {
  const _RequestGone();

  @override
  Widget build(BuildContext context) {
    final theme = DioLensTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              size: 40,
              color: theme.textFaint,
            ),
            const SizedBox(height: 10),
            Text(
              'This request is no longer available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.text,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Back to requests'),
            ),
          ],
        ),
      ),
    );
  }
}
