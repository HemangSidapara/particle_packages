## 0.3.1

 - **FEAT**: Add README documentation for particle_core, particle_image, and particle_text packages. ([531b918b](https://github.com/HemangSidapara/particle_packages/commit/531b918b84e632146bb5a7c8cb6501d84e667fda))
 - **FEAT**: imageFit BoxFit support, responsive widget demo, docs update. ([9f4bfec0](https://github.com/HemangSidapara/particle_packages/commit/9f4bfec028e8a8fee426e436822f7441067db4f8))
 - **FEAT**: onReady/onError/onPause/onResume callbacks, pause control, animated spinner. ([de08d2fe](https://github.com/HemangSidapara/particle_packages/commit/de08d2fefa71c30097472f4dfbd61a0fbcceedfb))
 - **FEAT**(particle_image): network constructor, icon/faIcon constructors, width/height params, particle ring loader. ([59d1c737](https://github.com/HemangSidapara/particle_packages/commit/59d1c7372d6603ff1c023a9abff065304f3d069d))
 - **FEAT**(particle_core): implement responsive resizing, dark pixel visibility, and monorepo versioning (v0.2.0). ([8c666597](https://github.com/HemangSidapara/particle_packages/commit/8c666597c85e003f6e0f80616dad0810547fc2d4))
 - **FEAT**(particle_core): implement content-aware density scaling and responsive font sizes. ([270aa397](https://github.com/HemangSidapara/particle_packages/commit/270aa397433387d1f2906eb85acc8131d65191ec))
 - **FEAT**(particle_core): add support for custom font size, multi-line text, and transparent backgrounds. ([102d7ad8](https://github.com/HemangSidapara/particle_packages/commit/102d7ad83dcecf9324e20bde8f0fedafbd368cb5))
 - **DOCS**(repo): update READMEs and normalize changelog formatting. ([990affe9](https://github.com/HemangSidapara/particle_packages/commit/990affe97443ae1a01fdb4ac464d4c65bb08b536))
 - **DOCS**(core): Document internal ParticleSystem properties. ([efa5c663](https://github.com/HemangSidapara/particle_packages/commit/efa5c6632ef73f45190797527c33f15d8705aefc))
 - **DOCS**: improve code documentation and add melos doc scripts. ([2baf45db](https://github.com/HemangSidapara/particle_packages/commit/2baf45db8274cded915f0896240adf63d96004a7))
 - **DOCS**(readme): Update package dependency versions. ([c49b3ea2](https://github.com/HemangSidapara/particle_packages/commit/c49b3ea25d6f97c95e76300636e452efa6803871))

## 0.3.0

- **`imageFit: BoxFit`**: new config parameter to control image scaling within the particle canvas (`contain`, `cover`, `fill`, `fitWidth`, `fitHeight`, `scaleDown`, `none`). Uses Flutter's `applyBoxFit`. Default `BoxFit.contain` (replaces hardcoded 0.85 margin).
- **`widgetDensityMultiplier`**: new config parameter to scale particle density for widget captures (default `1.0`)
- **`isSettled` getter**: check if particles have settled near targets (avg displacement < 2px). Used by widget `onReady` callbacks.

## 0.2.1

- **FEAT**(particle_core): implement responsive resizing, dark pixel visibility, and monorepo versioning (v0.2.0). ([8c666597](https://github.com/HemangSidapara/particle_packages/commit/8c666597c85e003f6e0f80616dad0810547fc2d4))
- **FEAT**(particle_core): implement content-aware density scaling and responsive font sizes. ([270aa397](https://github.com/HemangSidapara/particle_packages/commit/270aa397433387d1f2906eb85acc8131d65191ec))
- **FEAT**(particle_core): add support for custom font size, multi-line text, and transparent backgrounds. ([102d7ad8](https://github.com/HemangSidapara/particle_packages/commit/102d7ad83dcecf9324e20bde8f0fedafbd368cb5))
- **DOCS**: improve code documentation and add melos doc scripts. ([2baf45db](https://github.com/HemangSidapara/particle_packages/commit/2baf45db8274cded915f0896240adf63d96004a7))
- **DOCS**(readme): Update package dependency versions. ([c49b3ea2](https://github.com/HemangSidapara/particle_packages/commit/c49b3ea25d6f97c95e76300636e452efa6803871))

## 0.2.0

- **Dark pixel visibility**: image particles with near-black source colors now have brightness boosted (luminance < 80) while preserving hue and saturation
- **Max particle count**: density-based count can exceed the default 50k cap; `maxParticleCount` only acts as a hard limit when explicitly set
- **Monorepo versioning**: all packages now share the same version number

## 0.0.2

- Repository URL fix

## 0.0.1

- Initial release — extracted from particle_text
- ParticleSystem with spring physics and pointer repulsion
- ParticleConfig with responsive density + 5 presets
- ParticlePainter with single GPU draw call via drawRawAtlas
- Support for both text and image pixel sources
- Auto background color detection for images
