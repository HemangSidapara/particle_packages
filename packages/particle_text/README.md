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
  <img src="https://raw.githubusercontent.com/HemangSidapara/particle_packages/main/preview/demo.gif" alt="particle_text demo" width="300"/>
</p>

## Features

- **Touch & hover interaction** — particles scatter away from your finger/cursor
- **Spring physics** — smooth, natural particle reformation
- **Fully customizable** — colors, particle count, physics, font, and more
- **Built-in presets** — cosmic, fire, matrix, pastel, minimal
- **Powered by particle_core** — high-performance single GPU draw call engine
- **Cross-platform** — works on iOS, Android, Web, macOS, Windows, Linux

## Getting started

```yaml
dependencies:
  particle_text: ^0.1.0
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
    particleDensity: 2000,
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

## Related packages

| Package | Description |
|---|---|
| [particle_core](https://pub.dev/packages/particle_core) | Core engine (used internally) |
| [particle_image](https://pub.dev/packages/particle_image) | Image-to-particle effect |

## License

MIT License. See [LICENSE](LICENSE) for details.
