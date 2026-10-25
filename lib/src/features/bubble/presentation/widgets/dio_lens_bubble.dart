import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../settings/domain/enums/dio_lens_bubble_position.dart';

/// Round button that opens Dio Lens.
class DioLensBubble extends StatelessWidget {
  /// Creates the bubble.
  const DioLensBubble({super.key, this.onTap});

  /// Diameter of the bubble.
  static const double size = 56;

  /// Called on tap.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open Dio Lens inspector',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x24FFFFFF)),
            gradient: const LinearGradient(
              begin: Alignment(-0.42, -0.9),
              end: Alignment(0.42, 0.9),
              colors: [Color(0xFF3C6DFF), Color(0xFF203BB8)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x8C2741B4),
                offset: Offset(0, 10),
                blurRadius: 26,
              ),
            ],
          ),
          child: const Icon(
            Icons.bolt_rounded,
            size: 22,
            color: Color(0xFFEEF2FF),
          ),
        ),
      ),
    );
  }
}

/// Fills the overlay and floats a [DioLensBubble] that can be dragged anywhere;
/// [settleDelay] after a drag it slides to the nearer side edge.
class FloatingDioLensBubble extends StatefulWidget {
  /// Creates the floating bubble.
  const FloatingDioLensBubble({
    super.key,
    required this.initialPosition,
    this.onTap,
    this.settleDelay = const Duration(seconds: 2),
  });

  /// Corner the bubble starts in.
  final DioLensBubblePosition initialPosition;

  /// Called on tap.
  final VoidCallback? onTap;

  /// How long after a drag the bubble slides to an edge.
  final Duration settleDelay;

  /// Gap kept between the bubble and the screen edges.
  static const double margin = 16;

  /// Distance of a bottom corner from the bottom of the safe area.
  static const double bottomInset = 112;

  @override
  State<FloatingDioLensBubble> createState() => _FloatingDioLensBubbleState();
}

class _FloatingDioLensBubbleState extends State<FloatingDioLensBubble> {
  Offset? _position;
  bool _dragging = false;
  Timer? _settleTimer;

  @override
  void dispose() {
    _settleTimer?.cancel();
    super.dispose();
  }

  Rect _bounds(Size size, EdgeInsets padding) {
    const m = FloatingDioLensBubble.margin;
    const s = DioLensBubble.size;
    final left = padding.left + m;
    final top = padding.top + m;
    final right = size.width - padding.right - m - s;
    final bottom = size.height - padding.bottom - m - s;
    return Rect.fromLTRB(
      left,
      top,
      right < left ? left : right,
      bottom < top ? top : bottom,
    );
  }

  Offset _corner(Rect bounds, Size size, EdgeInsets padding) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final (top, start) = switch (widget.initialPosition) {
      DioLensBubblePosition.topStart => (true, true),
      DioLensBubblePosition.topEnd => (true, false),
      DioLensBubblePosition.bottomStart => (false, true),
      DioLensBubblePosition.bottomEnd => (false, false),
    };
    final left = start != rtl;
    final y = top
        ? bounds.top
        : size.height -
              padding.bottom -
              FloatingDioLensBubble.bottomInset -
              DioLensBubble.size;
    return Offset(left ? bounds.left : bounds.right, y);
  }

  Offset _clamp(Offset p, Rect bounds) => Offset(
    p.dx.clamp(bounds.left, bounds.right),
    p.dy.clamp(bounds.top, bounds.bottom),
  );

  void _settle(Size size, Rect bounds) {
    final position = _position;
    if (position == null || !mounted) return;
    final centerX = position.dx + DioLensBubble.size / 2;
    setState(() {
      _position = Offset(
        centerX < size.width / 2 ? bounds.left : bounds.right,
        position.dy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final bounds = _bounds(size, padding);
        final position = _clamp(
          _position ??= _corner(bounds, size, padding),
          bounds,
        );

        return Stack(
          children: [
            AnimatedPositioned(
              duration: _dragging
                  ? Duration.zero
                  : const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onPanStart: (_) {
                  _settleTimer?.cancel();
                  setState(() => _dragging = true);
                },
                onPanUpdate: (details) => setState(
                  () => _position = _clamp(
                    (_position ?? position) + details.delta,
                    bounds,
                  ),
                ),
                onPanEnd: (_) {
                  setState(() => _dragging = false);
                  _settleTimer = Timer(
                    widget.settleDelay,
                    () => _settle(size, bounds),
                  );
                },
                child: DioLensBubble(onTap: widget.onTap),
              ),
            ),
          ],
        );
      },
    );
  }
}
