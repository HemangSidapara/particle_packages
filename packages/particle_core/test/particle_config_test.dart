import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:particle_core/particle_core.dart';

void main() {
  group('ParticleConfig', () {
    test('default values are set correctly', () {
      const config = ParticleConfig();

      expect(config.particleCount, isNull);
      expect(config.particleDensity, 2000);
      expect(config.maxParticleCount, 50000);
      expect(config.minParticleCount, 1000);
      expect(config.mouseRadius, 80.0);
      expect(config.returnSpeed, 0.04);
      expect(config.friction, 0.88);
      expect(config.repelForce, 8.0);
      expect(config.backgroundColor, const Color(0xFF020308));
      expect(config.minParticleSize, 0.4);
      expect(config.maxParticleSize, 2.2);
      expect(config.minAlpha, 0.5);
      expect(config.maxAlpha, 1.0);
      expect(config.sampleGap, 2);
      expect(config.fontWeight, FontWeight.bold);
      expect(config.fontFamily, isNull);
      expect(config.showPointerGlow, true);
      expect(config.pointerDotRadius, 4.0);
    });

    test('fixed particleCount overrides density', () {
      const config = ParticleConfig(particleCount: 5000);
      const mobile = Size(360, 800);
      const desktop = Size(1920, 1080);

      // Returns exact count regardless of screen size
      expect(config.effectiveParticleCount(mobile), 5000);
      expect(config.effectiveParticleCount(desktop), 5000);
    });

    test('custom values override defaults', () {
      const config = ParticleConfig(
        particleCount: 3000,
        mouseRadius: 120.0,
        returnSpeed: 0.08,
        friction: 0.92,
        repelForce: 15.0,
        backgroundColor: Color(0xFF111111),
        particleColor: Color(0xFFFF0000),
        fontFamily: 'Roboto',
        showPointerGlow: false,
      );

      expect(config.particleCount, 3000);
      expect(config.mouseRadius, 120.0);
      expect(config.returnSpeed, 0.08);
      expect(config.friction, 0.92);
      expect(config.repelForce, 15.0);
      expect(config.backgroundColor, const Color(0xFF111111));
      expect(config.particleColor, const Color(0xFFFF0000));
      expect(config.fontFamily, 'Roboto');
      expect(config.showPointerGlow, false);
    });
  });

  group('ParticleConfig - responsive particle count', () {
    test('scales with screen area on mobile', () {
      const config = ParticleConfig(); // density: 2000
      const mobile = Size(360, 800); // area: 288,000

      final count = config.effectiveParticleCount(mobile);
      // 288000 * 2000 / 100000 = 5760
      expect(count, 5760);
    });

    test('scales with screen area on tablet', () {
      const config = ParticleConfig();
      const tablet = Size(768, 1024); // area: 786,432

      final count = config.effectiveParticleCount(tablet);
      // 786432 * 2000 / 100000 = 15729 (rounded)
      expect(count, greaterThan(15000));
      expect(count, lessThan(16000));
    });

    test('scales with screen area on desktop', () {
      const config = ParticleConfig();
      const desktop = Size(1920, 1080); // area: 2,073,600

      final count = config.effectiveParticleCount(desktop);
      // 2073600 * 2000 / 100000 = 41472
      expect(count, greaterThan(40000));
      expect(count, lessThan(42000));
    });

    test('respects maxParticleCount cap', () {
      const config = ParticleConfig(
        particleDensity: 5000,
        maxParticleCount: 20000,
      );
      const huge = Size(3840, 2160); // 4K

      final count = config.effectiveParticleCount(huge);
      expect(count, 20000);
    });

    test('respects minParticleCount floor', () {
      const config = ParticleConfig(
        particleDensity: 100,
        minParticleCount: 2000,
      );
      const tiny = Size(200, 300);

      final count = config.effectiveParticleCount(tiny);
      expect(count, 2000);
    });

    test('different densities produce proportional counts', () {
      const low = ParticleConfig(particleDensity: 1000);
      const high = ParticleConfig(particleDensity: 3000);
      const size = Size(1000, 1000); // area: 1,000,000

      final lowCount = low.effectiveParticleCount(size);
      final highCount = high.effectiveParticleCount(size);

      // 1000000 * 1000 / 100000 = 10000
      // 1000000 * 3000 / 100000 = 30000
      expect(lowCount, 10000);
      expect(highCount, 30000);
      expect(highCount, 3 * lowCount);
    });
  });

  group('ParticleConfig - presets', () {
    test('cosmic preset has higher density', () {
      final config = ParticleConfig.cosmic();

      expect(config.particleDensity, 2800);
      expect(config.repelForce, 10.0);
      expect(config.friction, 0.86);
      expect(config.maxParticleSize, 1.8);
      expect(config.particleCount, isNull);
    });

    test('fire preset values', () {
      final config = ParticleConfig.fire();

      expect(config.particleDensity, 2400);
      expect(config.repelForce, 12.0);
      expect(config.returnSpeed, 0.03);
      expect(config.particleCount, isNull);
    });

    test('matrix preset values', () {
      final config = ParticleConfig.matrix();

      expect(config.particleDensity, 2000);
      expect(config.repelForce, 6.0);
      expect(config.friction, 0.90);
      expect(config.particleCount, isNull);
    });

    test('pastel preset values', () {
      final config = ParticleConfig.pastel();

      expect(config.particleDensity, 1700);
      expect(config.minParticleSize, 0.6);
      expect(config.maxParticleSize, 2.4);
      expect(config.particleCount, isNull);
    });

    test('minimal preset has lowest density', () {
      final config = ParticleConfig.minimal();

      expect(config.particleDensity, 900);
      expect(config.minParticleSize, 1.0);
      expect(config.maxParticleSize, 3.0);
      expect(config.mouseRadius, 100);
      expect(config.sampleGap, 3);
      expect(config.particleCount, isNull);
    });

    test('all presets scale correctly to desktop', () {
      final presets = [
        ParticleConfig.cosmic(),
        ParticleConfig.fire(),
        ParticleConfig.matrix(),
        ParticleConfig.pastel(),
        ParticleConfig.minimal(),
      ];
      const desktop = Size(1920, 1080);

      for (final preset in presets) {
        final count = preset.effectiveParticleCount(desktop);
        expect(count, greaterThan(preset.minParticleCount));
        expect(count, lessThanOrEqualTo(preset.maxParticleCount));
      }
    });
  });
}
