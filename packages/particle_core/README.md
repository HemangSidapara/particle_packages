# particle_core

[![pub package](https://img.shields.io/pub/v/particle_core.svg)](https://pub.dev/packages/particle_core)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Core engine for particle effects in Flutter. High-performance physics, single GPU draw call rendering, and full customization.

**You probably want [particle_text](https://pub.dev/packages/particle_text) or [particle_image](https://pub.dev/packages/particle_image) instead** — they provide ready-to-use widgets built on this engine.

## What's inside

- **ParticleSystem** — physics engine with spring forces, pointer repulsion, and text/image rasterization
- **ParticleConfig** — full configuration: colors, density, physics, fonts, presets
- **ParticlePainter** — high-performance renderer using `Canvas.drawRawAtlas` (single GPU draw call)
- **Particle** — data model for individual particles

## Use this package if

- You want to build a custom particle widget on top of the engine
- You need direct access to the physics system
- You're creating a new particle effect type beyond text and images

## Getting started

```yaml
dependencies:
  particle_core: ^0.0.1
```

## License

MIT License. See [LICENSE](LICENSE) for details.
