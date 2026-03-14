import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    testWidgets('renders with IconData', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticleImage.icon(
              Icons.star,
              iconColor: Colors.amber,
              iconSize: 100,
              config: ParticleConfig(maxParticleCount: 50),
            ),
          ),
        ),
      );
      // Allow async icon rasterization to complete.
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ParticleImage), findsOneWidget);
      expect(
        find.descendant(of: find.byType(ParticleImage), matching: find.byType(CustomPaint)),
        findsOneWidget,
      );
    });

    testWidgets('renders with FaIconData', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticleImage.faIcon(
              FontAwesomeIcons.rocket,
              iconColor: Colors.white,
              iconSize: 100,
              config: ParticleConfig(maxParticleCount: 50),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ParticleImage), findsOneWidget);
      expect(
        find.descendant(of: find.byType(ParticleImage), matching: find.byType(CustomPaint)),
        findsOneWidget,
      );
    });

    testWidgets('respects explicit width and height', (tester) async {
      final image = await createTestImage(100, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParticleImage(
              image: image,
              width: 300,
              height: 200,
              config: const ParticleConfig(maxParticleCount: 50),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(of: find.byType(ParticleImage), matching: find.byType(SizedBox)),
      );
      expect(sizedBox.width, 300);
      expect(sizedBox.height, 200);
    });

    testWidgets('network constructor shows particle placeholder while loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticleImage.network(
              'https://example.com/fake.png',
              config: ParticleConfig(maxParticleCount: 50),
            ),
          ),
        ),
      );
      // Before network resolves the particle placeholder should be shown.
      expect(find.byType(ParticleImage), findsOneWidget);
    });

    testWidgets('network constructor shows custom placeholder while loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ParticleImage.network(
              'https://example.com/fake.png',
              placeholder: CircularProgressIndicator(),
              config: ParticleConfig(maxParticleCount: 50),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('icon mode handles iconColor change without crashing', (tester) async {
      Color color = Colors.white;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return GestureDetector(
                  onTap: () => setState(() => color = Colors.blue),
                  child: ParticleImage.icon(
                    Icons.star,
                    iconColor: color,
                    iconSize: 80,
                    config: const ParticleConfig(maxParticleCount: 50),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ParticleImage), findsOneWidget);
    });
  });
}
