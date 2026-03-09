# particle_image

[![pub package](https://img.shields.io/pub/v/particle_image.svg)](https://pub.dev/packages/particle_image)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Interactive image-to-particle effect for Flutter. Renders any image as thousands of colored particles
that scatter on touch/hover, then reform — with per-pixel color accuracy.

> Looking for text-to-particle? See [particle_text](https://pub.dev/packages/particle_text).

## Preview

<!--suppress HtmlDeprecatedAttribute -->
<p align="center">
  <img src="https://raw.githubusercontent.com/HemangSidapara/particle_packages/main/preview/image_demo.gif" alt="particle_image demo" width="300"/>
</p>

## Features

- **Per-pixel color** — each particle takes the color of its source pixel
- **Touch & hover interaction** — particles scatter and reform
- **Auto background detection** — automatically filters out solid backgrounds
- **Asset & runtime images** — load from assets or use any `ui.Image`
- **Powered by particle_core** — single GPU draw call, 10,000+ particles at 60fps
- **Cross-platform** — iOS, Android, Web, macOS, Windows, Linux

## Getting started

```yaml
dependencies:
  particle_image: ^0.0.1
```

## Usage

### From a ui.Image

```dart
import 'package:particle_image/particle_image.dart';

ParticleImage(
  image: myUiImage,
  config: ParticleConfig(particleDensity: 2000),
)
```

### From an asset

```dart
ParticleImage.asset(
  'assets/logo.png',
  config: ParticleConfig.cosmic(),
)
```

### With configuration

```dart
ParticleImage(
  image: myImage,
  config: ParticleConfig(
    sampleGap: 2,          // lower = more particles, denser image
    backgroundColor: Color(0xFF020308),
    mouseRadius: 80,
    repelForce: 8.0,
    maxParticleCount: 50000,
  ),
)
```

### How particle count works for images

Unlike `ParticleText`, image particle count is determined by the number of visible pixels
sampled from the image (1 particle per sampled pixel). Control density with `sampleGap`:

```dart
ParticleConfig(sampleGap: 1)  // every pixel → most particles
ParticleConfig(sampleGap: 2)  // every 2nd pixel (default)
ParticleConfig(sampleGap: 4)  // every 4th pixel → fewer particles
```

Capped at `maxParticleCount` (default 50,000) for performance.

### Background detection

Images with solid backgrounds (black, white, etc.) are automatically handled —
corner pixels are sampled to detect and filter the background color.

For transparent PNGs, only the alpha channel is used (transparent pixels are skipped).

## Related packages

| Package | Description |
|---|---|
| [particle_core](https://pub.dev/packages/particle_core) | Core engine (used internally) |
| [particle_text](https://pub.dev/packages/particle_text) | Text-to-particle effect |

## License

MIT License. See [LICENSE](LICENSE) for details.
