## 0.3.1

 - **FEAT**: Add README documentation for particle_core, particle_image, and particle_text packages. ([531b918b](https://github.com/HemangSidapara/particle_packages/commit/531b918b84e632146bb5a7c8cb6501d84e667fda))
 - **FEAT**: onReady/onError/onPause/onResume callbacks, pause control, animated spinner. ([de08d2fe](https://github.com/HemangSidapara/particle_packages/commit/de08d2fefa71c30097472f4dfbd61a0fbcceedfb))
 - **FEAT**(particle_image): network constructor, icon/faIcon constructors, width/height params, particle ring loader. ([59d1c737](https://github.com/HemangSidapara/particle_packages/commit/59d1c7372d6603ff1c023a9abff065304f3d069d))
 - **FEAT**(particle_core): implement responsive resizing, dark pixel visibility, and monorepo versioning (v0.2.0). ([8c666597](https://github.com/HemangSidapara/particle_packages/commit/8c666597c85e003f6e0f80616dad0810547fc2d4))
 - **FEAT**(particle_core): implement content-aware density scaling and responsive font sizes. ([270aa397](https://github.com/HemangSidapara/particle_packages/commit/270aa397433387d1f2906eb85acc8131d65191ec))
 - **FEAT**(particle_core): add support for custom font size, multi-line text, and transparent backgrounds. ([102d7ad8](https://github.com/HemangSidapara/particle_packages/commit/102d7ad83dcecf9324e20bde8f0fedafbd368cb5))
 - **DOCS**: remove border-radius styling from README banner images and correct the root README image path. ([c59074d6](https://github.com/HemangSidapara/particle_packages/commit/c59074d6008516e034215134433378a75edbe475))
 - **DOCS**: Standardize banner image paths and add banners to package READMEs. ([cb0a97cc](https://github.com/HemangSidapara/particle_packages/commit/cb0a97ccd0d6a00f8f82079beda26edaacfa1f0b))
 - **DOCS**(repo): update READMEs and normalize changelog formatting. ([990affe9](https://github.com/HemangSidapara/particle_packages/commit/990affe97443ae1a01fdb4ac464d4c65bb08b536))
 - **DOCS**: improve code documentation and add melos doc scripts. ([2baf45db](https://github.com/HemangSidapara/particle_packages/commit/2baf45db8274cded915f0896240adf63d96004a7))
 - **DOCS**(readme): Update package dependency versions. ([c49b3ea2](https://github.com/HemangSidapara/particle_packages/commit/c49b3ea25d6f97c95e76300636e452efa6803871))

## 0.3.0

- **Pause / resume**: `paused` param + auto-pause on app background (`WidgetsBindingObserver`) and inactive tabs (`TickerMode`)
- **`onReady` callback**: fires once when particles fully settle into shape
- **`onPause` / `onResume` callbacks**: fire on any pause/resume transition (manual, background, tab)
- Requires `particle_core: ^0.3.0`

## 0.2.1

- **FEAT**(particle_core): implement responsive resizing, dark pixel visibility, and monorepo versioning (v0.2.0). ([8c666597](https://github.com/HemangSidapara/particle_packages/commit/8c666597c85e003f6e0f80616dad0810547fc2d4))
- **FEAT**(particle_core): implement content-aware density scaling and responsive font sizes. ([270aa397](https://github.com/HemangSidapara/particle_packages/commit/270aa397433387d1f2906eb85acc8131d65191ec))
- **FEAT**(particle_core): add support for custom font size, multi-line text, and transparent backgrounds. ([102d7ad8](https://github.com/HemangSidapara/particle_packages/commit/102d7ad83dcecf9324e20bde8f0fedafbd368cb5))
- **DOCS**: improve code documentation and add melos doc scripts. ([2baf45db](https://github.com/HemangSidapara/particle_packages/commit/2baf45db8274cded915f0896240adf63d96004a7))
- **DOCS**(readme): Update package dependency versions. ([c49b3ea2](https://github.com/HemangSidapara/particle_packages/commit/c49b3ea25d6f97c95e76300636e452efa6803871))

## 0.2.0

- **Responsive resize**: particles automatically re-rasterize and reposition when widget size changes (window resize, orientation change)
- **Max particle count**: density-based count can exceed the default 50k cap; `maxParticleCount` only acts as a hard limit when explicitly set
- **Monorepo versioning**: all packages now share the same version number
- Requires `particle_core: ^0.2.0`

## 0.1.1

- Repository URL fix

## 0.1.0

- **BREAKING**: Core engine extracted to `particle_core` package
- ParticleText widget now depends on `particle_core` for physics and rendering
- Re-exports `particle_core` for convenience — no extra imports needed
- Removed `ParticleImage` (moved to separate `particle_image` package)

## 0.0.2

- Added responsive density-based particle count
- Single GPU draw call rendering via `drawRawAtlas`
- Fixed deprecated Flutter API warnings
- Fixed half-text rendering on high-DPR devices

## 0.0.1

- Initial release
