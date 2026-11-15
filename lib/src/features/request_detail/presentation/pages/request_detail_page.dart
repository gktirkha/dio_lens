import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/clipboard_utils.dart';
import '../../../../theme/dio_lens_theme.dart';
import '../../../settings/domain/entities/dio_lens_settings.dart';
import '../../../settings/domain/enums/dio_lens_redaction_target.dart';
import '../../../settings/domain/utils/request_redactor.dart';
import '../../../share/domain/entities/dio_lens_share_content.dart';
import '../../domain/entities/request_detail_entity.dart';
import '../controllers/request_detail_controller.dart';
import '../widgets/overview_tab.dart';
import '../widgets/request_detail_header.dart';
import '../widgets/request_tab.dart';
import '../widgets/response_tab.dart';

/// Detail page of one request: header with actions, and Overview, Request and
/// Response tabs.
class RequestDetailPage extends StatefulWidget {
  /// Creates the detail page.
  const RequestDetailPage({
    super.key,
    required this.createController,
    this.onShare,
    this.onReplay,
    this.replayUnavailableReason,
    this.onOpenHome,
  });

  /// Creates the page's controller; the page disposes it.
  final RequestDetailController Function() createController;

  /// Set when the page was opened on its own (from the banner): the header then
  /// offers a way to the Dio Lens home.
  final VoidCallback? onOpenHome;

  /// Receives the request to share; without it, the report is copied to the
  /// clipboard.
  final DioLensShareCallback? onShare;

  /// Re-sends the request.
  final ValueChanged<RequestDetailEntity>? onReplay;

  /// Why the request can't be replayed, or null when it can.
  final String? Function(RequestDetailEntity request)? replayUnavailableReason;

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

  Future<void> _share(RequestDetailEntity request) async {
    final onShare = widget.onShare;
    if (onShare == null) return;
    final content = await _controller.shareContent(request);
    if (!mounted) return;
    await onShare(content);
  }

  /// Deletes the request at once, without asking, and goes back.
  Future<void> _delete() async {
    Navigator.of(context).maybePop();
    await _controller.deleteRequest();
  }

  void _replay(RequestDetailEntity request) {
    final onReplay = widget.onReplay;
    if (onReplay == null) return;
    final reason = widget.replayUnavailableReason?.call(request);
    if (reason == null) onReplay(request);
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            reason == null ? 'Request replayed' : "Can't replay: $reason",
          ),
          duration: Duration(milliseconds: reason == null ? 1400 : 2600),
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
              // Without onShare there is nothing to share with.
              onShare: widget.onShare == null ? null : _share,
              onReplay: widget.onReplay == null ? null : _replay,
              onDelete: _delete,
              onOpenHome: widget.onOpenHome,
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
    this.onDelete,
    this.onOpenHome,
  });

  final RequestDetailEntity request;
  final DioLensSettings settings;
  final VoidCallback? onOpenHome;
  final ValueChanged<RequestDetailEntity>? onShare;
  final ValueChanged<RequestDetailEntity>? onReplay;
  final VoidCallback? onDelete;

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
                  // Query values in the header masked like the other tabs.
                  request: RequestRedactor.redact(request, settings),
                  onCopyCurl: () => copyToClipboard(
                    context,
                    RequestRedactor.redact(
                      request,
                      settings,
                      target: DioLensRedactionTarget.clipboard,
                    ).curl,
                    label: 'cURL',
                  ),
                  onShare: onShare == null ? null : () => onShare(request),
                  onReplay: onReplay == null ? null : () => onReplay(request),
                  onDelete: onDelete,
                  onOpenHome: onOpenHome,
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
