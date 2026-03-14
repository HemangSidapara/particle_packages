<p align="center">
  <img src="../../resources/banner_2800x800.png"
       alt="particle_text demo: Blue and cyan glowing particles form the word Flutter against a dark starry background. The particles scatter and reform responsively as the cursor moves across them, demonstrating spring physics interactions."
       width="900">
</p>

# particle_image

[![pub package](https://img.shields.io/pub/v/particle_image.svg)](https://pub.dev/packages/particle_image)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Interactive image-to-particle effect for Flutter. Renders any image as thousands of colored
particles that scatter on touch/hover, then reform — with per-pixel color accuracy.

> Looking for text-to-particle? See [particle_text](https://pub.dev/packages/particle_text).

## 🔴 Live Demo

**[Try it in your browser →](https://hemangsidapara.github.io/particle_packages/)**

Move your cursor or touch to scatter the particles!

## Preview

<!--suppress HtmlDeprecatedAttribute -->
<p align="center">
  <img src="https://raw.githubusercontent.com/HemangSidapara/particle_packages/master/preview/image_preview.gif" alt="particle_image demo" width="600"/>
</p>

## Features

- **Per-pixel color** — each particle takes the color of its source pixel
- **Touch & hover interaction** — particles scatter and reform
- **Auto background detection** — automatically filters out solid backgrounds
- **Asset, network & runtime images** — load from assets, URLs, or any `ui.Image`
- **Network caching** — uses Flutter's built-in `ImageCache`; no extra dependencies
- **Flutter icon support** — pass any `IconData` directly; rasterized internally
- **Font Awesome support** — `ParticleImage.faIcon()` for `FaIconData` (v11+); `ParticleImage.icon()` for older FA versions
- **Particle loading placeholder** — animated particle ring while network image loads; swappable with any widget or another `ParticleImage`
- **Fixed size** — optional `width`/`height` parameters; no need to wrap in `SizedBox`
- **Dark pixel visibility** — dark image content (logos, text) stays visible as particles
- **Powered by particle_core** — single GPU draw call, 10,000+ particles at 60fps
- **Cross-platform** — iOS, Android, Web, macOS, Windows, Linux

## Getting started

```yaml
dependencies:
  particle_image: ^0.2.1
```

## Usage

### From a `ui.Image`

```dart
import 'package:particle_image/particle_image.dart';

ParticleImage(
  image: myUiImage,
  config: ParticleConfig(sampleGap: 2),
)
```

### From an asset

```dart
ParticleImage.asset(
  'assets/logo.png',
  config: ParticleConfig.cosmic(),
)
```

### From a network URL

Uses Flutter's built-in `ImageCache` — no extra package needed. If the same URL was already
fetched by `Image.network` elsewhere in the app, it's instant.

```dart
ParticleImage.network(
  'https://example.com/logo.png',
)
```

While loading, a built-in **particle ring** animation is shown by default — 300 particles form a
glowing circular loader shape. Override `placeholder` with any widget:

```dart
// Default — animated particle ring
ParticleImage.network('https://example.com/logo.png')

// Custom loading widget
ParticleImage.network(
  'https://example.com/logo.png',
  placeholder: CircularProgressIndicator(),
)

// Another ParticleImage as placeholder — fully particle experience while loading
ParticleImage.network(
  'https://example.com/logo.png',
  placeholder: ParticleImage.icon(Icons.image, iconColor: Colors.white54),
)

// No placeholder
ParticleImage.network(
  'https://example.com/logo.png',
  placeholder: SizedBox.shrink(),
)
```

### Fixed size

Set `width` and/or `height` directly instead of wrapping in `SizedBox`:

```dart
ParticleImage.asset('assets/logo.png', width: 400, height: 250)
ParticleImage.network('https://example.com/logo.png', width: 300, height: 300)
ParticleImage.icon(Icons.star, width: 200, height: 200)
```

### From a Flutter icon

Pass any `IconData` — works with `Icons`, `CupertinoIcons`, or any package that exposes `IconData`.
The icon is rasterized internally; no manual `ui.Image` conversion needed.

```dart
ParticleImage.icon(
  Icons.star,
  iconColor: Colors.amber,
  iconSize: 300,   // logical px — larger = more particle detail
  config: ParticleConfig.cosmic(),
)
```

### From a Font Awesome icon

`font_awesome_flutter` changed its icon type in **v11.0.0**. Use the table below to pick the
right constructor:

| Font Awesome version | Icon type  | Constructor to use         |
|----------------------|------------|----------------------------|
| `^11.0.0` (v11+)     | `FaIconData` | `ParticleImage.faIcon()`  |
| `<11.0.0` (legacy)   | `IconData`   | `ParticleImage.icon()`    |

#### Font Awesome v11+ (`FaIconData`)

`FaIconData` in v11 is a standalone wrapper class (does **not** extend `IconData`), so it requires
its own dedicated constructor.

Add `font_awesome_flutter: ^11.0.0` to your app's `pubspec.yaml`:

```yaml
dependencies:
  font_awesome_flutter: ^11.0.0
```

Then use `ParticleImage.faIcon()`:

```dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ParticleImage.faIcon(
  FontAwesomeIcons.rocket,
  iconColor: Colors.white,
  iconSize: 250,
  config: ParticleConfig.fire(),
)
```

#### Font Awesome < v11 (`IconData`)

In older versions, `FaIconData` extended `IconData`, so the standard `.icon()` constructor works:

```dart
// font_awesome_flutter: <11.0.0
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ParticleImage.icon(
  FontAwesomeIcons.rocket,   // typed as IconData in legacy versions
  iconColor: Colors.white,
  iconSize: 250,
  config: ParticleConfig.fire(),
)
```

#### Icon parameters (shared by both icon constructors)

| Parameter   | Type     | Default        | Description                                        |
|-------------|----------|----------------|----------------------------------------------------|
| `iconColor` | `Color`  | `Colors.white` | Fill color for the rasterized glyph                |
| `iconSize`  | `double` | `200.0`        | Logical size in px (larger = more particle detail) |

#### Common parameters (all constructors)

| Parameter     | Type      | Default  | Description                                                   |
|---------------|-----------|----------|---------------------------------------------------------------|
| `config`      | `ParticleConfig` | `ParticleConfig()` | Particle physics and appearance          |
| `expand`      | `bool`    | `true`   | Fill parent; ignored when `width`/`height` are set            |
| `width`       | `double?` | `null`   | Fixed widget width — no `SizedBox` wrapper needed             |
| `height`      | `double?` | `null`   | Fixed widget height — no `SizedBox` wrapper needed            |
| `onImageLoaded` | `VoidCallback?` | `null` | Called when image is loaded and particles start forming |
| `placeholder` | `Widget?` | `null`   | `.network()` only — `null` = particle ring, widget = custom, `SizedBox.shrink()` = none |

### With configuration

```dart
ParticleImage(
  image: myImage,
  config: ParticleConfig(
    sampleGap: 2,                       // lower = more particles, denser image
    backgroundColor: Color(0xFF020308),
    mouseRadius: 80,
    repelForce: 8.0,
    maxParticleCount: 50000,
  ),
)
```

### Background detection

Images with solid backgrounds (black, white, etc.) are automatically handled —
corner pixels are sampled to detect and filter the background color.

For transparent PNGs, only the alpha channel is used (transparent pixels are skipped).

### Background options

```dart
// Dark background (default)
ParticleImage.asset('logo.png', config: ParticleConfig())

// Light background
ParticleImage.asset('logo.png', config: ParticleConfig(
  backgroundColor: Colors.white,
  showPointerGlow: false,
))

// Transparent (overlay on any background)
ParticleImage.asset('logo.png', config: ParticleConfig(
  drawBackground: false,
  backgroundColor: Colors.transparent,
))
```

### Responsive resize

`ParticleImage` automatically re-rasterizes and repositions particles when the widget size changes
(window resize, orientation change). No extra code needed.

### Dark pixel visibility

Image content with very dark or near-black pixels (e.g. dark text in a logo PNG) is automatically
brightened to remain visible as particles. Hue and saturation are preserved — only luminance is
boosted.

## ParticleConfig options

All constructors accept an optional `config` parameter. Every field has a sensible default.

### Particle count

| Parameter          | Type     | Default | Description                                                          |
|--------------------|----------|---------|----------------------------------------------------------------------|
| `particleCount`    | `int?`   | `null`  | Fixed count — strict override, ignores content size and density      |
| `particleDensity`  | `double` | `10000` | Particles per 100,000 px² of drawn image area (ignored when `particleCount` is set) |
| `maxParticleCount` | `int`    | `50000` | Hard cap when explicitly set; density-driven count bypasses the default 50k cap |
| `minParticleCount` | `int`    | `1000`  | Lower floor for density-based count                                  |
| `sampleGap`        | `int`    | `2`     | Pixel sampling gap when rasterizing (lower = denser targets = more particles) |

### Physics

| Parameter     | Type     | Default | Description                                      |
|---------------|----------|---------|--------------------------------------------------|
| `mouseRadius` | `double` | `80.0`  | Pointer repulsion radius in logical px           |
| `returnSpeed` | `double` | `0.04`  | Spring return speed — `0.01` (slow) to `0.1` (snappy) |
| `friction`    | `double` | `0.88`  | Velocity damping per frame — `0.80` (heavy) to `0.95` (floaty) |
| `repelForce`  | `double` | `8.0`   | Pointer repulsion strength — `1.0` (gentle) to `20.0` (explosive) |

### Appearance

| Parameter         | Type     | Default | Description                              |
|-------------------|----------|---------|------------------------------------------|
| `minParticleSize` | `double` | `0.4`   | Minimum particle radius in logical px    |
| `maxParticleSize` | `double` | `2.2`   | Maximum particle radius in logical px    |
| `minAlpha`        | `double` | `0.5`   | Minimum particle opacity (0.0–1.0)       |
| `maxAlpha`        | `double` | `1.0`   | Maximum particle opacity (0.0–1.0)       |

### Colors

| Parameter          | Type    | Default   | Description                                                              |
|--------------------|---------|-----------|--------------------------------------------------------------------------|
| `backgroundColor`  | `Color` | `#020308` | Canvas background fill color                                             |
| `particleColor`    | `Color` | `#8CAADE` | Particle color at rest (near target). **Ignored in image mode** — per-pixel colors are used instead |
| `displacedColor`   | `Color` | `#DCE5FF` | Particle color when displaced far from target. **Ignored in image mode** |
| `pointerGlowColor` | `Color` | `#C8D2F0` | Color of the pointer glow orb                                            |

### Pointer glow & background

| Parameter          | Type     | Default | Description                                           |
|--------------------|----------|---------|-------------------------------------------------------|
| `drawBackground`   | `bool`   | `true`  | Draw solid background rect; set `false` for overlay use |
| `showPointerGlow`  | `bool`   | `true`  | Show radial glow orb at pointer position              |
| `pointerDotRadius` | `double` | `4.0`   | Radius of the bright dot at the pointer center        |

### Image particle count

Particle count is determined by `particleDensity` × **drawn image area**:

```text
count = drawWidth × drawHeight × particleDensity / 100,000
```

- Larger images → more drawn area → more particles
- `sampleGap` controls pixel target density (lower = denser target positions)

Control coverage with `sampleGap` or `particleDensity`:

```dart
ParticleConfig(sampleGap: 1)            // densest pixel targets
ParticleConfig(particleDensity: 14000)  // more particles per area
```

Capped at `maxParticleCount` only when explicitly set. The default 50,000 can be exceeded by
density.

## Performance

`particle_image` renders all particles in a **single GPU draw call** using `Canvas.drawRawAtlas`
(powered by `particle_core`). This means 10,000+ particles run smoothly at 60fps.

Key optimizations: pre-allocated typed array buffers (zero GC), squared-distance physics (avoids
`sqrt`), `ChangeNotifier`-driven repainting (no `setState` / no widget rebuilds), and
`RepaintBoundary` isolation.

Each particle stores its own ARGB color from the source image, rendered via per-particle tinting in
the atlas draw call — no extra GPU overhead compared to single-color mode.

## Related packages

| Package                                                 | Description                   |
|---------------------------------------------------------|-------------------------------|
| [particle_core](https://pub.dev/packages/particle_core) | Core engine (used internally) |
| [particle_text](https://pub.dev/packages/particle_text) | Text-to-particle effect       |

## License

MIT License. See [LICENSE](LICENSE) for details.
