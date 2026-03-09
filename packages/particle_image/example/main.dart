import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ParticleImageDemo());
  }
}

class ParticleImageDemo extends StatefulWidget {
  const ParticleImageDemo({super.key});

  @override
  State<ParticleImageDemo> createState() => _ParticleImageDemoState();
}

class _ParticleImageDemoState extends State<ParticleImageDemo> {
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _createSampleImage();
  }

  /// Generate a colorful image programmatically.
  Future<void> _createSampleImage() async {
    const size = 256;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    );

    // Draw colorful circles
    final rng = Random(42);
    for (int i = 0; i < 12; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size, rng.nextDouble() * size),
        20 + rng.nextDouble() * 50,
        Paint()
          ..color = HSVColor.fromAHSV(
            0.9,
            rng.nextDouble() * 360,
            0.8,
            0.9,
          ).toColor(),
      );
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    picture.dispose();

    if (mounted) setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020308),
      body: _image != null
          ? ParticleImage(
              image: _image,
              config: const ParticleConfig(
                backgroundColor: Color(0xFF020308),
                sampleGap: 2,
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// For asset-based usage:
//
// ParticleImage.asset(
//   'assets/logo.png',
//   config: ParticleConfig.cosmic(),
// )
