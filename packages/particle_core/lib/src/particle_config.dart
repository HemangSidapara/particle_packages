import 'package:flutter/material.dart';

/// Configuration for the [ParticleText] widget.
///
/// Controls particle behavior, appearance, and physics.
///
/// ### Responsive particle count
///
/// By default, particle count scales automatically with screen size
/// using [particleDensity]. This ensures text looks equally dense
/// on a mobile phone and a 4K desktop monitor.
///
/// ```dart
/// // Auto-scales (recommended)
/// ParticleConfig(particleDensity: 2000)
///
/// // Fixed count (manual override)
/// ParticleConfig(particleCount: 6000)
/// ```
class ParticleConfig {
  /// Fixed particle count. When set, overrides [particleDensity].
  /// Use this only when you need an exact number regardless of screen size.
  final int? particleCount;

  /// Particles per 100,000 logical pixels² of screen area.
  /// The effective count is calculated as:
  ///
  /// `effectiveCount = (screenWidth × screenHeight × density / 100000)`
  ///
  /// Reference values at default density (2000):
  /// - Mobile  (360×800)  → ~5,760 particles
  /// - Tablet  (768×1024) → ~15,729 particles
  /// - Desktop (1920×1080) → ~41,472 particles
  ///
  /// Ignored when [particleCount] is set.
  final double particleDensity;

  /// Maximum particle count to prevent performance issues on very
  /// large screens. Only applies when using [particleDensity].
  /// Default: 50,000 (safe for drawRawAtlas rendering).
  final int maxParticleCount;

  /// Minimum particle count to ensure text is visible on tiny screens.
  /// Only applies when using [particleDensity]. Default: 1,000.
  final int minParticleCount;

  /// Radius around the pointer that repels particles (in logical pixels).
  final double mouseRadius;

  /// How fast particles spring back to their target position.
  /// Range: 0.01 (very slow) to 0.1 (snappy). Default: 0.04.
  final double returnSpeed;

  /// Velocity damping per frame. Lower = more drag.
  /// Range: 0.8 (heavy drag) to 0.95 (floaty). Default: 0.88.
  final double friction;

  /// Strength of the repulsion force from the pointer.
  /// Range: 1.0 (gentle) to 20.0 (explosive). Default: 8.0.
  final double repelForce;

  /// Background color of the canvas.
  final Color backgroundColor;

  /// Base color of particles when at rest (near their target).
  final Color particleColor;

  /// Highlight color of particles when displaced far from target.
  final Color displacedColor;

  /// Color of the pointer glow orb.
  final Color pointerGlowColor;

  /// Minimum particle radius.
  final double minParticleSize;

  /// Maximum particle radius.
  final double maxParticleSize;

  /// Minimum particle opacity (0.0–1.0).
  final double minAlpha;

  /// Maximum particle opacity (0.0–1.0).
  final double maxAlpha;

  /// Sampling gap in physical pixels when rasterizing text.
  /// Lower = more text-pixel targets (denser coverage). Default: 2.
  final int sampleGap;

  /// Font weight used for rendering the text shape.
  final FontWeight fontWeight;

  /// Optional font family for the text shape.
  final String? fontFamily;

  /// Whether to show the pointer glow orb.
  final bool showPointerGlow;

  /// Radius of the bright dot at the pointer center.
  final double pointerDotRadius;

  const ParticleConfig({
    this.particleCount,
    this.particleDensity = 2000,
    this.maxParticleCount = 50000,
    this.minParticleCount = 1000,
    this.mouseRadius = 80.0,
    this.returnSpeed = 0.04,
    this.friction = 0.88,
    this.repelForce = 8.0,
    this.backgroundColor = const Color(0xFF020308),
    this.particleColor = const Color(0xFF8CAADE),
    this.displacedColor = const Color(0xFFDCE5FF),
    this.pointerGlowColor = const Color(0xFFC8D2F0),
    this.minParticleSize = 0.4,
    this.maxParticleSize = 2.2,
    this.minAlpha = 0.5,
    this.maxAlpha = 1.0,
    this.sampleGap = 2,
    this.fontWeight = FontWeight.bold,
    this.fontFamily,
    this.showPointerGlow = true,
    this.pointerDotRadius = 4.0,
  });

  /// Calculate effective particle count for the given screen [size].
  ///
  /// If [particleCount] is set, returns that value directly.
  /// Otherwise, scales based on [particleDensity] and screen area.
  int effectiveParticleCount(Size size) {
    if (particleCount != null) return particleCount!;

    final area = size.width * size.height;
    final count = (area * particleDensity / 100000).round();
    return count.clamp(minParticleCount, maxParticleCount);
  }

  /// Preset: dense cosmic dust look.
  factory ParticleConfig.cosmic() => const ParticleConfig(
    particleDensity: 2800,
    particleColor: Color(0xFF6E7FCC),
    displacedColor: Color(0xFFA8C4FF),
    pointerGlowColor: Color(0xFF8090E0),
    backgroundColor: Color(0xFF05060F),
    maxParticleSize: 1.8,
    repelForce: 10.0,
    friction: 0.86,
  );

  /// Preset: fiery warm particles.
  factory ParticleConfig.fire() => const ParticleConfig(
    particleDensity: 2400,
    particleColor: Color(0xFFCC6633),
    displacedColor: Color(0xFFFFCC44),
    pointerGlowColor: Color(0xFFFF8844),
    backgroundColor: Color(0xFF0A0504),
    maxParticleSize: 2.0,
    repelForce: 12.0,
    returnSpeed: 0.03,
  );

  /// Preset: neon green matrix style.
  factory ParticleConfig.matrix() => const ParticleConfig(
    particleDensity: 2000,
    particleColor: Color(0xFF00CC44),
    displacedColor: Color(0xFF88FF88),
    pointerGlowColor: Color(0xFF44FF66),
    backgroundColor: Color(0xFF010A02),
    maxParticleSize: 1.6,
    repelForce: 6.0,
    friction: 0.90,
  );

  /// Preset: soft pastel glow.
  factory ParticleConfig.pastel() => const ParticleConfig(
    particleDensity: 1700,
    particleColor: Color(0xFFDDA0DD),
    displacedColor: Color(0xFFFFE4F0),
    pointerGlowColor: Color(0xFFFFB6D9),
    backgroundColor: Color(0xFF0A0610),
    minParticleSize: 0.6,
    maxParticleSize: 2.4,
    repelForce: 6.0,
    returnSpeed: 0.03,
    friction: 0.90,
  );

  /// Preset: minimal with fewer, larger particles.
  factory ParticleConfig.minimal() => const ParticleConfig(
    particleDensity: 900,
    particleColor: Color(0xFFCCCCCC),
    displacedColor: Color(0xFFFFFFFF),
    pointerGlowColor: Color(0xFFEEEEEE),
    backgroundColor: Color(0xFF111111),
    minParticleSize: 1.0,
    maxParticleSize: 3.0,
    mouseRadius: 100,
    repelForce: 10.0,
    sampleGap: 3,
  );
}
