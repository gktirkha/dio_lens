import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../theme/dio_lens_theme_mode_controller.dart';
import '../../../theme/dio_lens_theme_scope.dart';
import '../../request_detail/domain/entities/request_detail_entity.dart';
import '../../settings/domain/enums/dio_lens_notification_position.dart';
import 'widgets/request_finished_banner.dart';

/// Shows the request-finished banner over the host app, in the overlay of the
/// host's navigator. One banner at a time.
class RequestBannerPresenter {
  /// Creates the presenter.
  RequestBannerPresenter({
    required this._navigatorKey,
    required this._themeController,
    required this._onView,
  });

  final GlobalKey<NavigatorState> _navigatorKey;
  final DioLensThemeModeController _themeController;
  final ValueChanged<String> _onView;

  OverlayEntry? _entry;
  GlobalKey<_AnimatedBannerState>? _bannerKey;

  /// Shows the banner for request for duration at position; skipped while the
  /// navigator is not mounted.
  void show(
    RequestDetailEntity request, {
    required Duration duration,
    DioLensNotificationPosition position = DioLensNotificationPosition.top,
  }) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => show(request, duration: duration, position: position),
      );
      return;
    }
    final overlay = _navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _remove();
    final key = GlobalKey<_AnimatedBannerState>();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _AnimatedBanner(
        key: key,
        duration: duration,
        position: position,
        onClosed: () {
          if (identical(_entry, entry)) _remove();
        },
        child: DioLensThemeScope(
          controller: _themeController,
          child: RequestFinishedBanner(
            request: request,
            onView: () {
              dismiss();
              _onView(request.id);
            },
            onDismiss: dismiss,
          ),
        ),
      ),
    );
    _entry = entry;
    _bannerKey = key;
    overlay.insert(entry);
  }

  /// Hides the current banner, if any.
  void dismiss() => _bannerKey?.currentState?.close();

  void _remove() {
    _entry?.remove();
    _entry = null;
    _bannerKey = null;
  }
}

class _AnimatedBanner extends StatefulWidget {
  const _AnimatedBanner({
    super.key,
    required this.duration,
    required this.position,
    required this.onClosed,
    required this.child,
  });

  final Duration duration;
  final DioLensNotificationPosition position;
  final VoidCallback onClosed;
  final Widget child;

  @override
  State<_AnimatedBanner> createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<_AnimatedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
    reverseDuration: const Duration(milliseconds: 180),
  )..forward();

  late final Timer _timer;

  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, close);
  }

  Future<void> close() async {
    if (_closing) return;
    _closing = true;
    _timer.cancel();
    await _animation.reverse();
    if (mounted) widget.onClosed();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _animation,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    final banner = FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: Offset(0, switch (widget.position) {
            DioLensNotificationPosition.top => -0.12,
            DioLensNotificationPosition.center => 0.06,
            DioLensNotificationPosition.bottom => 0.12,
          }),
          end: Offset.zero,
        ).animate(curved),
        child: Semantics(
          liveRegion: true,
          child: Material(type: MaterialType.transparency, child: widget.child),
        ),
      ),
    );
    return switch (widget.position) {
      DioLensNotificationPosition.top => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: banner,
          ),
        ),
      ),
      DioLensNotificationPosition.center => Positioned.fill(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: banner,
            ),
          ),
        ),
      ),
      DioLensNotificationPosition.bottom => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 82),
            child: banner,
          ),
        ),
      ),
    };
  }
}
