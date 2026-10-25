import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../settings/domain/entities/dio_lens_settings.dart';
import 'widgets/dio_lens_bubble.dart';

/// Floats the Dio Lens bubble over the host app, in the overlay of the
/// host's navigator, above every route.
///
/// Shown while [DioLensSettings.showBubble] is on and no Dio Lens page is
/// open ([hidden]).
class BubblePresenter {
  BubblePresenter({
    required this._navigatorKey,
    required this._settings,
    required this._hidden,
    required this._onTap,
  });

  final GlobalKey<NavigatorState> _navigatorKey;
  final ValueListenable<DioLensSettings> _settings;
  final ValueListenable<bool> _hidden;
  final VoidCallback _onTap;

  OverlayEntry? _entry;

  /// Inserts the bubble once the navigator is mounted (after `runApp`'s
  /// first frame).
  void attach() {
    WidgetsFlutterBinding.ensureInitialized();
    SchedulerBinding.instance.addPostFrameCallback((_) => _insert());
  }

  void _insert() {
    if (_entry != null) return;
    final overlay = _navigatorKey.currentState?.overlay;
    if (overlay == null) {
      // Navigator not built yet: try again after the next frame.
      SchedulerBinding.instance.addPostFrameCallback((_) => _insert());
      return;
    }
    final entry = OverlayEntry(
      builder: (context) => ListenableBuilder(
        listenable: Listenable.merge([_settings, _hidden]),
        builder: (context, _) {
          final settings = _settings.value;
          // Hidden, not removed, so a dragged position survives a visit to
          // Dio Lens; a new corner setting starts it over.
          return Visibility(
            visible: settings.showBubble && !_hidden.value,
            maintainState: true,
            child: FloatingDioLensBubble(
              key: ValueKey(settings.bubblePosition),
              initialPosition: settings.bubblePosition,
              onTap: _onTap,
            ),
          );
        },
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }
}
