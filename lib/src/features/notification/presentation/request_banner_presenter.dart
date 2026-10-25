import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../theme/dio_lens_theme_mode_controller.dart';
import '../../../theme/dio_lens_theme_scope.dart';
import '../../request_detail/domain/entities/request_detail_entity.dart';
import 'widgets/request_finished_banner.dart';

/// Shows the request-finished banner at the top of the host app, in the
/// overlay of the host's navigator. One banner at a time: a new one
/// replaces the current one.
class RequestBannerPresenter {
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

  /// Shows [request] for [duration]; skipped when the navigator is not
  /// mounted yet.
  void show(RequestDetailEntity request, {required Duration duration}) {
    // Inserting while a frame is being built would throw; wait for it.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => show(request, duration: duration),
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

  /// Hides the current banner, if any, with its exit animation.
  void dismiss() => _bannerKey?.currentState?.close();

  void _remove() {
    _entry?.remove();
    _entry = null;
    _bannerKey = null;
  }
}

/// Slides and fades the banner in, closes it after [duration] or on
/// [close], then reports [onClosed].
class _AnimatedBanner extends StatefulWidget {
  const _AnimatedBanner({
    super.key,
    required this.duration,
    required this.onClosed,
    required this.child,
  });

  final Duration duration;
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
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, -0.12),
                end: Offset.zero,
              ).animate(curved),
              child: Semantics(
                liveRegion: true,
                child: Material(
                  type: MaterialType.transparency,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
