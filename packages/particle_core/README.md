# particle_core

[![pub package](https://img.shields.io/pub/v/particle_core.svg)](https://pub.dev/packages/particle_core)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Core engine for particle effects in Flutter. High-performance physics, single GPU draw call
rendering, and full customization.

**You probably want [particle_text](https://pub.dev/packages/particle_text)
or [particle_image](https://pub.dev/packages/particle_image) instead** — they provide ready-to-use
widgets built on this engine.

## What's inside

- **ParticleSystem** — physics engine with spring forces, pointer repulsion, and text/image
  rasterization
- **ParticleConfig** — full configuration: colors, density, physics, fonts, image fit, presets
- **ParticlePainter** — high-performance renderer using `Canvas.drawRawAtlas` (single GPU draw call)
- **Particle** — data model for individual particles

## Use this package if

- You want to build a custom particle widget on top of the engine
- You need direct access to the physics system
- You're creating a new particle effect type beyond text and images

## Getting started

```yaml
dependencies:
  particle_core: ^0.2.1
```

## ParticleConfig options

Every field has a sensible default. Pass only what you want to override.

### Particle count

| Parameter          | Type     | Default | Description                                                                              |
|--------------------|----------|---------|------------------------------------------------------------------------------------------|
| `particleCount`    | `int?`   | `null`  | Fixed count — strict override, ignores content size and density                          |
| `particleDensity`  | `double` | `10000` | Particles per 100,000 px² of content area (text bbox or image drawn area)                |
| `maxParticleCount` | `int`    | `50000` | Hard cap when explicitly set; density-driven count bypasses the default 50k cap          |
| `minParticleCount` | `int`    | `1000`  | Lower floor for density-based count                                                      |
| `sampleGap`        | `int`    | `2`     | Pixel sampling gap when rasterizing (lower = denser targets = more particles)            |

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

| Parameter          | Type    | Default   | Description                                                                        |
|--------------------|---------|-----------|------------------------------------------------------------------------------------|
| `backgroundColor`  | `Color` | `#020308` | Canvas background fill color                                                       |
| `particleColor`    | `Color` | `#8CAADE` | Particle color at rest (near target). Ignored in image mode — per-pixel colors used instead |
| `displacedColor`   | `Color` | `#DCE5FF` | Particle color when displaced far from target. Ignored in image mode               |
| `pointerGlowColor` | `Color` | `#C8D2F0` | Color of the pointer glow orb                                                      |

### Pointer glow & background

| Parameter          | Type     | Default | Description                                             |
|--------------------|----------|---------|---------------------------------------------------------|
| `drawBackground`   | `bool`   | `true`  | Draw solid background rect; set `false` for overlay use |
| `showPointerGlow`  | `bool`   | `true`  | Show radial glow orb at pointer position                |
| `pointerDotRadius` | `double` | `4.0`   | Radius of the bright dot at the pointer center          |

### Image scaling *(used by ParticleImage; ignored in text mode)*

| Parameter  | Type     | Default          | Description                                                                                       |
|------------|----------|------------------|---------------------------------------------------------------------------------------------------|
| `imageFit` | `BoxFit` | `BoxFit.contain` | How the source image is inscribed into the particle canvas. Supports all standard `BoxFit` modes. |

`imageFit` controls how images and icons scale within the particle canvas when the aspect ratio
doesn't match the widget bounds:

| BoxFit        | Behavior                                                    |
|---------------|-------------------------------------------------------------|
| `contain`     | Scales to fit entirely within the canvas (default)          |
| `cover`       | Scales to fill the canvas, cropping edges as needed         |
| `fill`        | Stretches to fill the canvas exactly (may distort)          |
| `fitWidth`    | Scales to match the canvas width, may crop top/bottom       |
| `fitHeight`   | Scales to match the canvas height, may crop left/right      |
| `scaleDown`   | Like `contain` but never scales up beyond original size     |
| `none`        | No scaling — centered at original pixel size                |

For cropping modes (`cover`, `fitWidth`, `fitHeight`), only the visible source region is sampled —
pixels outside the crop are not turned into particles.

Does **not** apply to widget captures (`ParticleImage.widget()`) which preserve their original
logical size, or to text mode.

```dart
// Default — image fits within canvas, no cropping
ParticleConfig(imageFit: BoxFit.contain)

// Fill the entire canvas — crops edges if aspect ratios differ
ParticleConfig(imageFit: BoxFit.cover)

// Match width exactly — may crop top/bottom on tall images
ParticleConfig(imageFit: BoxFit.fitWidth)
```

### Widget capture density *(used by ParticleImage.widget(); ignored elsewhere)*

| Parameter                  | Type     | Default | Description                                                                                |
|----------------------------|----------|---------|--------------------------------------------------------------------------------------------|
| `widgetDensityMultiplier`  | `double` | `1.0`   | Scale factor for auto-computed particle density when rendering widget captures              |

The particle system auto-computes density based on how much of the widget is filled vs transparent.
This multiplier scales that result:

- `1.0` (default) — adaptive density, no change
- `2.0` — double the particles (denser, better coverage for faint or thin content)
- `0.5` — half the particles (better performance, more sparse)

Only affects `ParticleImage.widget()` — has no effect on text, asset images, network images,
or icons.

### Text rendering *(used by ParticleText; ignored in image mode)*

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

Particle count is determined by `particleDensity` × **content area**:

```text
count = contentArea × particleDensity / 100,000
```

- **Content area** = text bounding box or image drawn area — NOT the full widget/screen
- Larger `fontSize` → bigger bounding box → more particles automatically
- Multi-line text → taller bounding box → more particles
- `sampleGap` controls how many target positions are sampled (lower = denser)
- `fontSize` is **responsive** when null — auto-scales with widget size (32–200 px)

To force an exact count: `ParticleConfig(particleCount: 6000)`

> **Max count behavior:** When `maxParticleCount` is left at its default (50,000), the density-based
> count is allowed to exceed it. The cap only applies when you explicitly set a custom value.

### Responsive resize

Both `ParticleText` and `ParticleImage` detect widget size changes (window resize, orientation
change) and automatically re-rasterize content and reposition particles at the new size.

### Dark image pixel visibility

Image particles with very dark/near-black source colors (luminance < 80) have their brightness
automatically boosted while preserving hue and saturation. This keeps logos and text within images
visible as particles regardless of background color.

## Performance

`particle_core` renders all particles in a **single GPU draw call** using `Canvas.drawRawAtlas`.
This means 10,000+ particles run smoothly at 60fps — compared to traditional `drawCircle`
-per-particle approaches that start lagging at 1,000.

Other optimizations:

- **Pre-allocated `Float32List`/`Int32List` buffers** — zero GC pressure per frame
- **Squared-distance checks** — avoids `sqrt` in physics hot loops
- **`ChangeNotifier`-driven repainting** — no `setState`, no widget tree rebuilds
- **`RepaintBoundary` isolation** — only the canvas layer repaints
- **Pre-rendered sprite texture** — 32×32 soft glow circle created once, reused every frame

## License

MIT License. See [LICENSE](LICENSE) for details.