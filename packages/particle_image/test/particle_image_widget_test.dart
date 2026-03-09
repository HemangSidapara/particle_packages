import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:particle_image/particle_image.dart';

/// Create a simple test image programmatically.
Future<ui.Image> createTestImage(int width, int height) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
    recorder,
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
  );
  canvas.drawCircle(
    Offset(width / 2, height / 2),
    width / 3,
    Paint()..color = const Color(0xFFFF0000),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  picture.dispose();
  return image;
}

void main() {
  group('ParticleImage Widget', () {
    testWidgets('renders with ui.Image', (tester) async {
      final image = await createTestImage(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticleImage(
              image: image,
              config: const ParticleConfig(maxParticleCount: 100),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(ParticleImage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ParticleImage),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('contains RepaintBoundary', (tester) async {
      final image = await createTestImage(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticleImage(
              image: image,
              config: const ParticleConfig(maxParticleCount: 100),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        find.descendant(
          of: find.byType(ParticleImage),
          matching: find.byType(RepaintBoundary),
        ),
        findsOneWidget,
      );
    });

    testWidgets('handles pan gestures without crashing', (tester) async {
      final image = await createTestImage(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticleImage(
              image: image,
              config: const ParticleConfig(maxParticleCount: 100),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final gesture = find.descendant(
        of: find.byType(ParticleImage),
        matching: find.byType(GestureDetector),
      );
      final center = tester.getCenter(gesture);
      final testGesture = await tester.startGesture(center);
      await tester.pump(const Duration(milliseconds: 50));
      await testGesture.moveBy(const Offset(50, 30));
      await tester.pump(const Duration(milliseconds: 50));
      await testGesture.up();
      await tester.pump(const Duration(milliseconds: 50));
    });

    testWidgets('expands by default', (tester) async {
      final image = await createTestImage(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticleImage(
              image: image,
              config: const ParticleConfig(maxParticleCount: 50),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(ParticleImage),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, double.infinity);
      expect(sizedBox.height, double.infinity);
    });

    testWidgets('works in non-expanding mode', (tester) async {
      final image = await createTestImage(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: ParticleImage(
                  image: image,
                  expand: false,
                  config: const ParticleConfig(maxParticleCount: 50),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(ParticleImage), findsOneWidget);
    });
  });
}
