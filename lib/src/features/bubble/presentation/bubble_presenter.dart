import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../settings/domain/entities/dio_lens_settings.dart';
import 'widgets/dio_lens_bubble.dart';

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

  void attach() {
    WidgetsFlutterBinding.ensureInitialized();
    SchedulerBinding.instance.addPostFrameCallback((_) => _insert());
  }

  void _insert() {
    if (_entry != null) return;
    final overlay = _navigatorKey.currentState?.overlay;
    if (overlay == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _insert());
      return;
    }
    final entry = OverlayEntry(
      builder: (context) => ListenableBuilder(
        listenable: Listenable.merge([_settings, _hidden]),
        builder: (context, _) {
          final settings = _settings.value;
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
