<p align="center">
  <img src="https://raw.githubusercontent.com/HemangSidapara/particle_packages/master/resources/banner_2800x800.png"
       alt="particle_text demo: Blue and cyan glowing particles form the word Flutter against a dark starry background. The particles scatter and reform responsively as the cursor moves across them, demonstrating spring physics interactions."
       width="900">
</p>

# particle_text

[![pub package](https://img.shields.io/pub/v/particle_text.svg)](https://pub.dev/packages/particle_text)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Interactive particle text effect for Flutter. Thousands of particles form text shapes and scatter on
touch/hover, then spring back — with full customization.

> Looking for image-to-particle? See [particle_image](https://pub.dev/packages/particle_image).

## 🔴 Live Demo

**[Try it in your browser →](https://hemangsidapara.github.io/particle_packages/)**

Move your cursor or touch to scatter the particles!

## Preview

<!--suppress HtmlDeprecatedAttribute -->
<p align="center">
  <img src="https://raw.githubusercontent.com/HemangSidapara/particle_packages/master/preview/text_preview.gif" alt="particle_text demo: Blue glowing particles spelling Flutter scatter and reform on a dark background, responding to cursor interaction with spring physics" width="600"/>
</p>

## Features

- **Touch & hover interaction** — particles scatter away from your finger/cursor
- **Spring physics** — smooth, natural particle reformation
- **Fully customizable** — colors, particle count, physics, font, and more
- **Built-in presets** — cosmic, fire, matrix, pastel, minimal
- **Pause / resume control** — manual `paused` param + auto-pause on app background and inactive tabs
- **Lifecycle callbacks** — `onReady`, `onPause`, `onResume`, `onTextChanged`
- **Powered by particle_core** — high-performance single GPU draw call engine
- **Cross-platform** — works on iOS, Android, Web, macOS, Windows, Linux

## Getting started

```yaml
dependencies:
  particle_text: ^0.3.0
```

## Usage

### Basic

```dart
import 'package:particle_text/particle_text.dart';

ParticleText(text: 'Hello')
```

### With configuration

```dart
ParticleText(
  text: 'Flutter',
  config: ParticleConfig(
    fontSize: 80,
    particleColor: Color(0xFF8CAADE),
    displacedColor: Color(0xFFDCE5FF),
    backgroundColor: Color(0xFF020308),
    mouseRadius: 80,
    repelForce: 8.0,
    returnSpeed: 0.04,
  ),
)
```

### Using presets

```dart
// Cosmic blue dust
ParticleText(text: 'Cosmic', config: ParticleConfig.cosmic())

// Fiery warm particles
ParticleText(text: 'Fire', config: ParticleConfig.fire())

// Neon green matrix
ParticleText(text: 'Matrix', config: ParticleConfig.matrix())

// Soft pastel glow
ParticleText(text: 'Pastel', config: ParticleConfig.pastel())

// Fewer, larger particles
ParticleText(text: 'Clean', config: ParticleConfig.minimal())
```

### Dynamic text

Simply update the `text` parameter and the particles will morph:

```dart
ParticleText(
  text: _currentText, // change this and particles re-target
  onTextChanged: () => print('Morphing!'),
)
```

### Pause and resume

Stop the physics ticker entirely — zero CPU/GPU cost while paused:

```dart
ParticleText(
  text: 'Hello',
  paused: _isPaused, // toggle reactively
)
```

Three pause sources are handled automatically:

| Source | Behavior |
|--------|----------|
| `paused: true` | Manual — caller controls it |
| App backgrounded | Auto-paused via `WidgetsBindingObserver` |
| Inactive tab | Auto-paused via Flutter's `TickerMode` |

### Callbacks

```dart
ParticleText(
  text: 'Hello',
  paused: _isPaused,
  onReady: () {
    // Fires once when particles have fully settled into shape.
    // Use this for splash screen sequencing instead of a fixed timer.
  },
  onTextChanged: () {
    // Fires when text changes and morph begins.
  },
  onPause: () {
    // Fires when animation pauses — any source.
  },
  onResume: () {
    // Fires when animation resumes — any source.
  },
)
```

#### Splash screen example with `onReady`

```dart
ParticleText(
  text: 'MyApp',
  onReady: () {
    // Particles are fully visible — now start the fade-out
    Future.delayed(const Duration(seconds: 1), fadeOut);
  },
)
```

### Fixed size (non-expanding)

By default, `ParticleText` expands to fill its parent. To use a fixed size:

```dart
SizedBox(
  width: 400,
  height: 300,
  child: ParticleText(
    text: 'Sized',
    expand: false,
  ),
)
```

### Inside Expanded

Use `ParticleText` alongside other widgets in a `Column` or `Row`:

```dart
Column(
  children: [
    AppBar(title: Text('My App')),
    Expanded(
      child: ParticleText(text: 'Hello'),
    ),
    BottomNavigationBar(...),
  ],
)
```

## ParticleConfig options

All constructors accept an optional `config` parameter. Every field has a sensible default.

### Particle count

| Parameter          | Type     | Default | Description                                                                         |
|--------------------|----------|---------|-------------------------------------------------------------------------------------|
| `particleCount`    | `int?`   | `null`  | Fixed count — strict override, ignores content size and density                     |
| `particleDensity`  | `double` | `10000` | Particles per 100,000 px² of text bounding-box area (ignored when `particleCount` is set) |
| `maxParticleCount` | `int`    | `50000` | Hard cap when explicitly set; density-driven count bypasses the default 50k cap     |
| `minParticleCount` | `int`    | `1000`  | Lower floor for density-based count                                                 |
| `sampleGap`        | `int`    | `2`     | Pixel sampling gap when rasterizing (lower = denser targets = more particles)       |

### Physics

| Parameter     | Type     | Default | Description                                                        |
|---------------|----------|---------|--------------------------------------------------------------------|
| `mouseRadius` | `double` | `80.0`  | Pointer repulsion radius in logical px                             |
| `returnSpeed` | `double` | `0.04`  | Spring return speed — `0.01` (slow) to `0.1` (snappy)             |
| `friction`    | `double` | `0.88`  | Velocity damping per frame — `0.80` (heavy) to `0.95` (floaty)    |
| `repelForce`  | `double` | `8.0`   | Pointer repulsion strength — `1.0` (gentle) to `20.0` (explosive) |

### Appearance

| Parameter         | Type     | Default | Description                           |
|-------------------|----------|---------|---------------------------------------|
| `minParticleSize` | `double` | `0.4`   | Minimum particle radius in logical px |
| `maxParticleSize` | `double` | `2.2`   | Maximum particle radius in logical px |
| `minAlpha`        | `double` | `0.5`   | Minimum particle opacity (0.0–1.0)    |
| `maxAlpha`        | `double` | `1.0`   | Maximum particle opacity (0.0–1.0)    |

### Colors

| Parameter          | Type    | Default   | Description                                      |
|--------------------|---------|-----------|--------------------------------------------------|
| `backgroundColor`  | `Color` | `#020308` | Canvas background fill color                     |
| `particleColor`    | `Color` | `#8CAADE` | Particle color at rest (near target)             |
| `displacedColor`   | `Color` | `#DCE5FF` | Particle color when displaced far from target    |
| `pointerGlowColor` | `Color` | `#C8D2F0` | Color of the pointer glow orb                    |

### Pointer glow & background

| Parameter          | Type     | Default | Description                                             |
|--------------------|----------|---------|---------------------------------------------------------|
| `drawBackground`   | `bool`   | `true`  | Draw solid background rect; set `false` for overlay use |
| `showPointerGlow`  | `bool`   | `true`  | Show radial glow orb at pointer position                |
| `pointerDotRadius` | `double` | `4.0`   | Radius of the bright dot at the pointer center          |

### Text rendering

| Parameter    | Type         | Default             | Description                                                          |
|--------------|--------------|---------------------|----------------------------------------------------------------------|
| `fontSize`   | `double?`    | `null` (responsive) | Font size in logical px. When `null`, auto-computed from widget size (32–200 px) |
| `fontWeight` | `FontWeight` | `bold`              | Font weight used when rasterizing the text shape                     |
| `fontFamily` | `String?`    | `null`              | Custom font family for the text shape                                |
| `textAlign`  | `TextAlign`  | `center`            | Text alignment for multi-line text                                   |

### Built-in presets

| Preset             | Density | Friction | Repel | Style                        |
|--------------------|---------|----------|-------|------------------------------|
| `ParticleConfig()` | 10,000  | 0.88     | 8.0   | Blue-white on dark navy      |
| `.cosmic()`        | 14,000  | 0.86     | 10.0  | Dense cosmic dust            |
| `.fire()`          | 12,000  | 0.88     | 12.0  | Orange/gold fiery            |
| `.matrix()`        | 10,000  | 0.90     | 6.0   | Neon green                   |
| `.pastel()`        | 8,500   | 0.90     | 6.0   | Soft plum/pink               |
| `.minimal()`       | 4,500   | 0.88     | 10.0  | Fewer, larger gray particles |

Every preset accepts named overrides for any parameter:

```dart
ParticleConfig.cosmic(fontSize: 48, repelForce: 15.0)
ParticleConfig.fire(drawBackground: false)

// Or use copyWith on any config
myConfig.copyWith(particleDensity: 8000, particleColor: Colors.red)
```

### How particle count works

Particle count is determined by `particleDensity` × **text bounding-box area**:

```text
count = textWidth × textHeight × particleDensity / 100,000
```

- Larger `fontSize` → bigger bounding box → more particles automatically
- Multi-line text → taller bounding box → more particles
- `sampleGap` controls pixel target density (lower = denser target positions)
- `fontSize` is **responsive** when null — auto-scales with widget size (32–200 px)

To force an exact count:

```dart
ParticleConfig(particleCount: 6000)  // always exactly 6000, ignores content size
```

> **Max count behavior:** When `maxParticleCount` is left at its default (50,000), density-based
> counts can exceed it. Set a custom value to enforce a hard cap.

### Widget parameters

| Parameter       | Type               | Default | Description |
|-----------------|--------------------|---------|-------------|
| `text`          | `String`           | required | Text to render as particles |
| `config`        | `ParticleConfig`   | `ParticleConfig()` | Physics, appearance, and colors |
| `expand`        | `bool`             | `true` | Fill parent container |
| `paused`        | `bool`             | `false` | Pause the physics ticker entirely |
| `onReady`       | `VoidCallback?`    | `null` | Fires once when particles fully settle (avg displacement < 2 px) |
| `onTextChanged` | `VoidCallback?`    | `null` | Fires when text changes and morph begins |
| `onPause`       | `VoidCallback?`    | `null` | Fires when animation pauses (any source) |
| `onResume`      | `VoidCallback?`    | `null` | Fires when animation resumes (any source) |

### Responsive resize

`ParticleText` automatically re-rasterizes and repositions particles when the widget size changes
(window resize, orientation change, layout changes). No extra code needed.

## Performance

`particle_text` renders all particles in a **single GPU draw call** using `Canvas.drawRawAtlas` (
powered by `particle_core`). This means 10,000+ particles run smoothly at 60fps.

Key optimizations: pre-allocated typed array buffers (zero GC), squared-distance physics (avoids
`sqrt`), `ChangeNotifier`-driven repainting (no `setState` / no widget rebuilds), and
`RepaintBoundary` isolation.

## Related packages

| Package                                                   | Description                   |
|-----------------------------------------------------------|-------------------------------|
| [particle_core](https://pub.dev/packages/particle_core)   | Core engine (used internally) |
| [particle_image](https://pub.dev/packages/particle_image) | Image-to-particle effect      |

## License

MIT License. See [LICENSE](LICENSE) for details.
