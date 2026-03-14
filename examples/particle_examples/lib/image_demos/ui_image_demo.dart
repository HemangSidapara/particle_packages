import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class UiImageDemo extends StatefulWidget {
  const UiImageDemo({super.key});

  @override
  State<UiImageDemo> createState() => _UiImageDemoState();
}

class _UiImageDemoState extends State<UiImageDemo> {
  int _selectedShape = 0;
  ui.Image? _image;
  bool _loading = false;

  final _shapes = ['Gradient Circle', 'Flower', 'Star Burst'];

  @override
  void initState() {
    super.initState();
    _generate(0);
  }

  Future<void> _generate(int index) async {
    if (_loading) return;
    setState(() => _loading = true);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 400.0;

    if (index == 0) {
      _drawGradientCircle(canvas, size);
    } else if (index == 1) {
      _drawFlower(canvas, size);
    } else {
      _drawStarBurst(canvas, size);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());

    if (mounted) {
      setState(() {
        _image = image;
        _loading = false;
      });
    }
  }

  void _drawGradientCircle(Canvas canvas, double size) {
    final center = Offset(size / 2, size / 2);
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        size / 2,
        [const Color(0xFF54C5F8), const Color(0xFF9C27B0), Colors.transparent],
        [0.0, 0.6, 1.0],
      );
    canvas.drawCircle(center, size / 2, paint);

    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, size * 0.3, ringPaint);
    canvas.drawCircle(center, size * 0.15, ringPaint..strokeWidth = 2);
  }

  void _drawFlower(Canvas canvas, double size) {
    final center = Offset(size / 2, size / 2);
    const petalCount = 8;
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < petalCount; i++) {
      final angle = (i / petalCount) * pi * 2;
      final dx = center.dx + (size * 0.22) * cos(angle);
      final dy = center.dy + (size * 0.22) * sin(angle);
      paint.color = HSVColor.fromAHSV(1.0, (i / petalCount) * 360, 0.8, 1.0).toColor();
      canvas.drawCircle(Offset(dx, dy), size * 0.15, paint);
    }

    paint.color = Colors.white;
    canvas.drawCircle(center, size * 0.1, paint);
  }

  void _drawStarBurst(Canvas canvas, double size) {
    final center = Offset(size / 2, size / 2);
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        size / 2,
        [const Color(0xFFFFCC00), const Color(0xFFFF4466), Colors.transparent],
        [0.0, 0.5, 1.0],
      );

    const spokes = 12;
    final path = Path();
    for (var i = 0; i < spokes; i++) {
      final outerAngle = (i / spokes) * pi * 2 - pi / 2;
      final innerAngle = outerAngle + pi / spokes;
      final outerR = size * 0.48;
      final innerR = size * 0.18;

      final ox = center.dx + outerR * cos(outerAngle);
      final oy = center.dy + outerR * sin(outerAngle);
      final ix = center.dx + innerR * cos(innerAngle);
      final iy = center.dy + innerR * sin(innerAngle);

      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: Stack(
        children: [
          if (_image != null)
            ParticleImage(
              key: ValueKey('ui-$_selectedShape'),
              image: _image,
              config: const ParticleConfig(particleDensity: 2500, showPointerGlow: true),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white24)),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white.withValues(alpha: 0.4)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Text(
                  'TOUCH & DRAG',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10, letterSpacing: 2),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Custom ui.Image drawn on Canvas',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_shapes.length, (i) {
                        final sel = i == _selectedShape;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (_loading || i == _selectedShape) return;
                              setState(() => _selectedShape = i);
                              _generate(i);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: sel ? 0.12 : 0.04),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withValues(alpha: sel ? 0.25 : 0.08)),
                              ),
                              child: Text(
                                _shapes[i],
                                style: TextStyle(color: Colors.white.withValues(alpha: sel ? 0.9 : 0.35), fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
