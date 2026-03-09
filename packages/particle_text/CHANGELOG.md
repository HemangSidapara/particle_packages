## 0.1.0

* **BREAKING**: Core engine extracted to `particle_core` package
* ParticleText widget now depends on `particle_core` for physics and rendering
* Re-exports `particle_core` for convenience — no extra imports needed
* Removed `ParticleImage` (moved to separate `particle_image` package)

## 0.0.2

* Added responsive density-based particle count
* Single GPU draw call rendering via `drawRawAtlas`
* Fixed deprecated Flutter API warnings
* Fixed half-text rendering on high-DPR devices

## 0.0.1

* Initial release
