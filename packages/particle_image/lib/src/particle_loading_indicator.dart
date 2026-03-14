import 'dart:math';

import 'package:flutter/material.dart';

/// Built-in animated spinner shown while a network image loads.
///
/// Renders a spinning 270° gradient arc with a glowing head dot driven by an
/// [AnimationController]. Lifecycle-aware — pauses automatically on app background.
///
/// Replace via [ParticleImage.network]'s `placeholder` parameter.
class ParticleLoadingIndicator extends StatefulWidget {
  final Color backgroundColor;

  const ParticleLoadingIndicator({super.key, required this.backgroundColor});

  @override
  State<ParticleLoadingIndicator> createState() => _ParticleLoadingIndicatorState();
}

class _ParticleLoadingIndicatorState extends State<ParticleLoadingIndicator>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  bool _lifecyclePaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final shouldPause = state == AppLifecycleState.paused;
    if (shouldPause == _lifecyclePaused) return;
    _lifecyclePaused = shouldPause;
    if (_lifecyclePaused) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backgroundColor,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) => CustomPaint(
            size: const Size(88, 88),
            painter: _SpinnerPainter(_controller.value),
          ),
        ),
      ),
    );
  }
}

/// Paints a spinning gradient arc with a glowing head dot.
///
/// [t] is the animation progress from 0.0 to 1.0 (one full rotation = 1.0).
class _SpinnerPainter extends CustomPainter {
  final double t;
  const _SpinnerPainter(this.t);

  static const _arc = Color(0xFF8CAADE);
  static const _head = Color(0xFFDCE5FF);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final radius = cx - 6.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Subtle background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _arc.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Rotate canvas so the arc spins — everything inside save/restore is in rotated space.
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(t * pi * 2);
    canvas.translate(-cx, -cy);

    const startAngle = -pi / 2.0;
    const sweepAngle = pi * 1.5; // 270° comet arc

    // Outer glow layer
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [Colors.transparent, _arc.withValues(alpha: 0.45), _head.withValues(alpha: 0.35)],
          stops: const [0.0, 0.72, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Main arc with fade-in gradient
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..shader = const SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [Colors.transparent, _arc, _head],
          stops: [0.0, 0.72, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round,
    );

    // Bright glowing dot at the leading edge
    final headX = cx + radius * cos(startAngle + sweepAngle);
    final headY = cy + radius * sin(startAngle + sweepAngle);
    final headPos = Offset(headX, headY);

    canvas.drawCircle(
      headPos,
      5.5,
      Paint()
        ..color = _head.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(headPos, 2.8, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) => old.t != t;
}
