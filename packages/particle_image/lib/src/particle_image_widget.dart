import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:particle_core/particle_core.dart';

/// Renders an image as interactive particles.
///
/// Each particle takes the color of its source pixel, creating
/// a colorful particle representation of the image that scatters
/// on touch/hover.
///
/// ```dart
/// ParticleImage(
///   image: myUiImage,
///   config: ParticleConfig(particleDensity: 2000),
/// )
/// ```
///
/// To load from an asset:
/// ```dart
/// ParticleImage.asset(
///   'assets/logo.png',
///   config: ParticleConfig.cosmic(),
/// )
/// ```
///
/// To load from a network URL:
/// ```dart
/// ParticleImage.network(
///   'https://example.com/logo.png',
///   placeholder: CircularProgressIndicator(), // optional custom placeholder
/// )
/// ```
///
/// To render any Flutter [IconData] directly:
/// ```dart
/// ParticleImage.icon(
///   Icons.star,
///   iconColor: Colors.amber,
///   iconSize: 300,
/// )
/// ```
///
/// To render a Font Awesome icon ([FaIconData]):
/// ```dart
/// ParticleImage.faIcon(
///   FontAwesomeIcons.rocket,
///   iconColor: Colors.white,
///   iconSize: 250,
/// )
/// ```
class ParticleImage extends StatefulWidget {
  /// A pre-loaded [ui.Image] to render as particles.
  final ui.Image? image;

  /// Asset path to load an image from (e.g. `'assets/logo.png'`).
  final String? assetPath;

  /// A network URL to load an image from (e.g. `'https://example.com/logo.png'`).
  /// Uses Flutter's built-in [ImageCache] — no extra dependencies needed.
  final String? networkUrl;

  /// A Flutter [IconData] to rasterize and render as particles.
  /// Works with [Icons], [CupertinoIcons], or any package that exposes [IconData].
  final IconData? iconData;

  /// A Font Awesome [FaIconData] to rasterize and render as particles.
  /// Requires [font_awesome_flutter] in your app's pubspec.
  final FaIconData? faIconData;

  /// Fill color used when rasterizing [iconData] or [faIconData]. Defaults to [Colors.white].
  final Color iconColor;

  /// Logical size in pixels at which [iconData] or [faIconData] is rasterized. Defaults to 200.
  /// Larger values produce more particle detail at the cost of rasterization time.
  final double iconSize;

  /// Configuration for particle behavior and appearance.
  /// Note: [ParticleConfig.particleColor] and [ParticleConfig.displacedColor] are ignored in image mode;
  /// per-pixel colors from the image are used instead.
  final ParticleConfig config;

  /// If true, the widget expands to fill its parent. Ignored when [width] or [height] is set.
  final bool expand;

  /// Fixed width for the widget. When set, [expand] is ignored.
  final double? width;

  /// Fixed height for the widget. When set, [expand] is ignored.
  final double? height;

  /// Widget shown while a [networkUrl] image is loading.
  ///
  /// - `null` (default) — shows a built-in particle loading animation.
  /// - Any [Widget] — shows that widget instead.
  /// - [SizedBox.shrink()] — shows nothing while loading.
  final Widget? placeholder;

  /// Called when the image is loaded and particles start forming.
  final VoidCallback? onImageLoaded;

  /// Creates a ParticleImage from a pre-loaded [ui.Image].
  const ParticleImage({
    super.key,
    required this.image,
    this.config = const ParticleConfig(),
    this.expand = true,
    this.width,
    this.height,
    this.onImageLoaded,
  }) : assetPath = null,
       networkUrl = null,
       iconData = null,
       faIconData = null,
       iconColor = Colors.white,
       iconSize = 200.0,
       placeholder = null;

  /// Creates a ParticleImage from an asset path.
  const ParticleImage.asset(
    this.assetPath, {
    super.key,
    this.config = const ParticleConfig(),
    this.expand = true,
    this.width,
    this.height,
    this.onImageLoaded,
  }) : image = null,
       networkUrl = null,
       iconData = null,
       faIconData = null,
       iconColor = Colors.white,
       iconSize = 200.0,
       placeholder = null;

  /// Creates a ParticleImage from a network URL.
  ///
  /// Uses Flutter's built-in [ImageCache] — the image is automatically cached
  /// in memory and shared with [Image.network] if the same URL was already loaded.
  ///
  /// While loading, [placeholder] is shown:
  /// - `null` (default) — built-in particle loading animation
  /// - Any [Widget] — your custom loading widget
  /// - [SizedBox.shrink()] — nothing
  const ParticleImage.network(
    this.networkUrl, {
    super.key,
    this.placeholder,
    this.config = const ParticleConfig(),
    this.expand = true,
    this.width,
    this.height,
    this.onImageLoaded,
  }) : image = null,
       assetPath = null,
       iconData = null,
       faIconData = null,
       iconColor = Colors.white,
       iconSize = 200.0;

  /// Creates a ParticleImage from a Flutter [IconData] (e.g. [Icons.star], [CupertinoIcons.heart]).
  ///
  /// The icon is rasterized internally — no manual [ui.Image] conversion needed.
  /// Use [iconColor] to set the fill color and [iconSize] to control rasterization
  /// resolution (larger = more particle detail).
  const ParticleImage.icon(
    this.iconData, {
    super.key,
    this.iconColor = Colors.white,
    this.iconSize = 200.0,
    this.config = const ParticleConfig(),
    this.expand = true,
    this.width,
    this.height,
    this.onImageLoaded,
  }) : image = null,
       assetPath = null,
       networkUrl = null,
       faIconData = null,
       placeholder = null;

  /// Creates a ParticleImage from a Font Awesome [FaIconData]
  /// (e.g. `FontAwesomeIcons.rocket`).
  ///
  /// The icon is rasterized internally — no manual [ui.Image] conversion needed.
  /// Use [iconColor] to set the fill color and [iconSize] to control rasterization
  /// resolution (larger = more particle detail).
  const ParticleImage.faIcon(
    this.faIconData, {
    super.key,
    this.iconColor = Colors.white,
    this.iconSize = 200.0,
    this.config = const ParticleConfig(),
    this.expand = true,
    this.width,
    this.height,
    this.onImageLoaded,
  }) : image = null,
       assetPath = null,
       networkUrl = null,
       iconData = null,
       placeholder = null;

  @override
  State<ParticleImage> createState() => _ParticleImageState();
}

class _ParticleImageState extends State<ParticleImage> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late ParticleSystem _system;
  late ParticlePainter _painter;
  bool _initialized = false;
  Size _lastSize = Size.zero;
  ui.Image? _loadedImage;
  bool _iconRendering = false;
  bool _networkLoading = false;
  bool _networkImageOwned = false;

  @override
  void initState() {
    super.initState();
    _system = ParticleSystem(config: widget.config);
    _painter = ParticlePainter(system: _system, config: widget.config);
    _ticker = createTicker(_onTick)..start();

    if (widget.assetPath != null) {
      _loadAsset(widget.assetPath!);
    }
    if (widget.networkUrl != null) {
      _loadNetwork(widget.networkUrl!);
    }
    // Icon / FaIcon rendering is deferred to _initSystem when DPR is available.
  }

  @override
  void didUpdateWidget(covariant ParticleImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final configChanged = oldWidget.config != widget.config;

    if (configChanged) {
      _system.dispose();
      _system = ParticleSystem(config: widget.config);
      _painter = ParticlePainter(system: _system, config: widget.config);
      _initialized = false;
      // Do NOT clear _loadedImage here. The decoded asset / rendered icon / ui.Image
      // is still valid — only the physics config changed. Clearing it would cause
      // .asset() to stall (image == null → _initSystem returns early) and force
      // .icon()/.faIcon() to re-rasterize unnecessarily.
      if (_lastSize != Size.zero) {
        _initSystem(_lastSize, MediaQuery.devicePixelRatioOf(context));
      }
      return;
    }

    if (oldWidget.image != widget.image && widget.image != null) {
      _initialized = false;
      if (_lastSize != Size.zero) {
        _initSystem(_lastSize, MediaQuery.devicePixelRatioOf(context));
      }
    }

    if (oldWidget.assetPath != widget.assetPath && widget.assetPath != null) {
      _loadedImage = null;
      _initialized = false;
      _loadAsset(widget.assetPath!);
    }

    if (oldWidget.networkUrl != widget.networkUrl && widget.networkUrl != null) {
      _disposeNetworkImage();
      _loadedImage = null;
      _initialized = false;
      _loadNetwork(widget.networkUrl!);
    }

    if (widget.iconData != null &&
        (oldWidget.iconData != widget.iconData ||
            oldWidget.iconColor != widget.iconColor ||
            oldWidget.iconSize != widget.iconSize)) {
      _loadedImage = null;
      _initialized = false;
      if (_lastSize != Size.zero) {
        _initSystem(_lastSize, MediaQuery.devicePixelRatioOf(context));
      }
    }

    if (widget.faIconData != null &&
        (oldWidget.faIconData != widget.faIconData ||
            oldWidget.iconColor != widget.iconColor ||
            oldWidget.iconSize != widget.iconSize)) {
      _loadedImage = null;
      _initialized = false;
      if (_lastSize != Size.zero) {
        _initSystem(_lastSize, MediaQuery.devicePixelRatioOf(context));
      }
    }
  }

  void _disposeNetworkImage() {
    if (_networkImageOwned) {
      _loadedImage?.dispose();
      _networkImageOwned = false;
    }
  }

  Future<void> _loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _loadedImage = frame.image;

    _initialized = false;
    if (_lastSize != Size.zero) {
      if (mounted) {
        _initSystem(_lastSize, MediaQuery.devicePixelRatioOf(context));
      }
    } else {
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadNetwork(String url) async {
    setState(() => _networkLoading = true);

    final completer = Completer<ui.Image>();
    final stream = NetworkImage(url).resolve(ImageConfiguration.empty);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        if (!completer.isCompleted) completer.complete(info.image.clone());
        stream.removeListener(listener);
      },
      onError: (e, st) {
        if (!completer.isCompleted) completer.completeError(e, st);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);

    try {
      final image = await completer.future;
      if (!mounted) {
        image.dispose();
        return;
      }
      _disposeNetworkImage();
      _loadedImage = image;
      _networkImageOwned = true;
      _initialized = false;
      // setState triggers a rebuild which switches from placeholder → canvas.
      // _initSystem is called from LayoutBuilder inside build(), so we don't
      // call it here — the rebuild will invoke it with the correct size.
      setState(() => _networkLoading = false);
    } catch (_) {
      if (mounted) setState(() => _networkLoading = false);
    }
  }

  /// Rasterizes a glyph (identified by [codePoint] + font info) into a [ui.Image]
  /// at [widget.iconSize] × [dpr] physical pixels.
  Future<ui.Image> _renderGlyph({
    required int codePoint,
    required String? fontFamily,
    required String? fontPackage,
    required double dpr,
  }) async {
    final physicalSize = (widget.iconSize * dpr).ceilToDouble();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, physicalSize, physicalSize));

    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(codePoint),
        style: TextStyle(
          // 85% fill leaves a small margin so the glyph is never clipped.
          fontSize: physicalSize * 0.85,
          fontFamily: fontFamily,
          package: fontPackage,
          color: widget.iconColor,
        ),
      )
      ..layout();

    // Center the glyph within the canvas.
    final dx = (physicalSize - textPainter.width) / 2;
    final dy = (physicalSize - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(dx, dy));

    final picture = recorder.endRecording();
    final image = await picture.toImage(physicalSize.ceil(), physicalSize.ceil());
    picture.dispose();
    return image;
  }

  @override
  void dispose() {
    _disposeNetworkImage();
    _ticker.dispose();
    _system.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    _system.tick();
  }

  Future<void> _initSystem(Size size, double dpr) async {
    final sizeChanged = _lastSize != size;
    _lastSize = size;
    _system.screenSize = size;
    _system.devicePixelRatio = dpr;

    // Rasterize icon / faIcon on first call (or after relevant field changes).
    final needsIconRender = (widget.iconData != null || widget.faIconData != null) && _loadedImage == null;
    if (needsIconRender && !_iconRendering) {
      _iconRendering = true;
      if (widget.iconData != null) {
        _loadedImage = await _renderGlyph(
          codePoint: widget.iconData!.codePoint,
          fontFamily: widget.iconData!.fontFamily,
          fontPackage: widget.iconData!.fontPackage,
          dpr: dpr,
        );
      } else {
        _loadedImage = await _renderGlyph(
          codePoint: widget.faIconData!.codePoint,
          fontFamily: widget.faIconData!.fontFamily,
          fontPackage: widget.faIconData!.fontPackage,
          dpr: dpr,
        );
      }
      _iconRendering = false;
      if (mounted) {
        _initSystem(size, dpr);
      }
      return;
    }

    final image = widget.image ?? _loadedImage;
    if (image == null) return; // asset/icon/network still loading

    if (_initialized && !sizeChanged) return;
    _initialized = true;

    if (_system.sprite == null) {
      await _system.init();
    }

    await _system.setImage(image, size);
    widget.onImageLoaded?.call();
  }

  Widget _wrapSize(Widget child) {
    if (widget.width != null || widget.height != null) {
      return SizedBox(width: widget.width, height: widget.height, child: child);
    }
    if (widget.expand) return SizedBox.expand(child: child);
    return child;
  }

  @override
  Widget build(BuildContext context) {
    if (_networkLoading) {
      final ph = widget.placeholder ?? _ParticleLoadingIndicator(backgroundColor: widget.config.backgroundColor);
      return _wrapSize(ph);
    }

    final dpr = MediaQuery.devicePixelRatioOf(context);

    final canvas = LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initSystem(size, dpr);

        return RepaintBoundary(
          child: GestureDetector(
            onPanStart: (d) => _system.pointer = d.localPosition,
            onPanUpdate: (d) => _system.pointer = d.localPosition,
            onPanEnd: (_) => _system.pointer = const Offset(-9999, -9999),
            onPanCancel: () => _system.pointer = const Offset(-9999, -9999),
            child: MouseRegion(
              onHover: (e) => _system.pointer = e.localPosition,
              onExit: (_) => _system.pointer = const Offset(-9999, -9999),
              cursor: SystemMouseCursors.none,
              child: CustomPaint(
                size: size,
                painter: _painter,
                willChange: true,
              ),
            ),
          ),
        );
      },
    );

    return _wrapSize(canvas);
  }
}

/// Built-in particle loading indicator shown while a network image loads.
///
/// Draws a ring onto a canvas and feeds it to [ParticleSystem.setImage], so
/// particles form a circular shape and scatter/reform while loading.
class _ParticleLoadingIndicator extends StatefulWidget {
  final Color backgroundColor;

  const _ParticleLoadingIndicator({required this.backgroundColor});

  @override
  State<_ParticleLoadingIndicator> createState() => _ParticleLoadingIndicatorState();
}

class _ParticleLoadingIndicatorState extends State<_ParticleLoadingIndicator> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late ParticleSystem _system;
  late ParticlePainter _painter;
  bool _initialized = false;
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    final config = ParticleConfig(
      particleCount: 300,
      backgroundColor: widget.backgroundColor,
      drawBackground: true,
      showPointerGlow: false,
      returnSpeed: 0.025,
      friction: 0.91,
      repelForce: 4.0,
    );
    _system = ParticleSystem(config: config);
    _painter = ParticlePainter(system: _system, config: config);
    _ticker = createTicker((_) => _system.tick())..start();
  }

  /// Draws a glowing ring onto a [ui.Image] that the particle system uses as
  /// its target layout. The ring is a fixed loader-sized circle (radius ~36 logical px).
  Future<ui.Image> _buildRingImage(Size size, double dpr) async {
    final pw = (size.width * dpr).ceil().clamp(1, 4096);
    final ph = (size.height * dpr).ceil().clamp(1, 4096);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final cx = pw / 2.0;
    final cy = ph / 2.0;
    // Fixed logical radius of 36px — like a standard circular progress indicator.
    final r = 36.0 * dpr;
    final strokeW = 4.0 * dpr;

    // Outer soft glow ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = const Color(0xFF8CAADE).withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW * 2.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Main ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = const Color(0xFF8CAADE)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW,
    );
    // Bright inner ring
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = const Color(0xFFDCE5FF).withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW * 0.35,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(pw, ph);
    picture.dispose();
    return image;
  }

  Future<void> _init(Size size, double dpr) async {
    if (_initialized && _lastSize == size) return;
    _lastSize = size;
    _system.screenSize = size;
    _system.devicePixelRatio = dpr;
    if (_system.sprite == null) await _system.init();
    _initialized = true;
    final ringImage = await _buildRingImage(size, dpr);
    await _system.setImage(ringImage, size);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _system.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _init(size, dpr);
          return RepaintBoundary(
            child: GestureDetector(
              onPanUpdate: (d) => _system.pointer = d.localPosition,
              onPanEnd: (_) => _system.pointer = const Offset(-9999, -9999),
              child: MouseRegion(
                onHover: (e) => _system.pointer = e.localPosition,
                onExit: (_) => _system.pointer = const Offset(-9999, -9999),
                cursor: SystemMouseCursors.none,
                child: CustomPaint(
                  size: size,
                  painter: _painter,
                  willChange: true,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
