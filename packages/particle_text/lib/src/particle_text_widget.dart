import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:particle_core/particle_core.dart';

/// An interactive particle text effect widget.
///
/// Renders thousands of particles that form the given [text].
/// Particles scatter when the user touches or hovers with a pointer,
/// then spring back into the text shape.
///
/// All particles are rendered in a single GPU draw call using
/// [Canvas.drawRawAtlas], making it capable of handling 10,000+
/// particles at 60fps.
///
/// ```dart
/// ParticleText(
///   text: 'Hello',
///   config: ParticleConfig(
///     particleCount: 6000,
///     particleColor: Color(0xFF8CAADE),
///   ),
/// )
/// ```
class ParticleText extends StatefulWidget {
  /// The text to render as particles.
  final String text;

  /// Configuration for particle behavior and appearance.
  final ParticleConfig config;

  /// If true, the widget expands to fill its parent.
  final bool expand;

  /// Called when the text changes and particles begin morphing.
  final VoidCallback? onTextChanged;

  /// Called once when particles have fully settled into the text shape
  /// for the first time. Useful for sequencing splash screens or entrance
  /// animations — fires when average particle displacement drops below 2px.
  ///
  /// Re-fires after a full config rebuild (e.g. [config] object changes).
  final VoidCallback? onReady;

  /// Whether the particle animation is paused.
  ///
  /// When `true`, the physics ticker stops completely — no CPU or GPU work.
  /// Toggle reactively to pause/resume from code:
  ///
  /// ```dart
  /// ParticleText(text: 'Hello', paused: _isPaused)
  /// ```
  ///
  /// Tab switching is handled automatically by Flutter's [TickerMode]
  /// (no extra wiring needed). App-backgrounding is handled automatically
  /// via [WidgetsBindingObserver]. This flag is for explicit manual control.
  final bool paused;

  /// Called when the particle animation pauses for any reason:
  /// [paused] set to `true`, app going to background, or widget entering
  /// an inactive tab (via [TickerMode]).
  final VoidCallback? onPause;

  /// Called when the particle animation resumes after being paused:
  /// [paused] set to `false`, app returning to foreground, or widget
  /// entering an active tab (via [TickerMode]).
  final VoidCallback? onResume;

  /// Creates a [ParticleText] that renders [text] as interactive particles.
  const ParticleText({
    super.key,
    required this.text,
    this.config = const ParticleConfig(),
    this.expand = true,
    this.paused = false,
    this.onTextChanged,
    this.onReady,
    this.onPause,
    this.onResume,
  });

  @override
  State<ParticleText> createState() => _ParticleTextState();
}

class _ParticleTextState extends State<ParticleText> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Ticker _ticker;
  late ParticleSystem _system;
  late ParticlePainter _painter;
  bool _initialized = false;
  bool _readyFired = false;
  bool _lifecyclePaused = false;
  bool? _lastTickerMuted;
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _system = ParticleSystem(config: widget.config);
    _painter = ParticlePainter(system: _system, config: widget.config);
    _ticker = createTicker(_onTick);
    if (!widget.paused) _ticker.start();
  }

  @override
  void didUpdateWidget(covariant ParticleText oldWidget) {
    super.didUpdateWidget(oldWidget);

    final configChanged = oldWidget.config != widget.config;
    final textChanged = oldWidget.text != widget.text;

    if (oldWidget.paused != widget.paused) {
      _updateTickerState();
    }

    if (configChanged) {
      // Config changed — rebuild the entire system
      _system.dispose();
      _system = ParticleSystem(config: widget.config);
      _painter = ParticlePainter(system: _system, config: widget.config);
      _initialized = false;
      _readyFired = false;
      if (_lastSize != Size.zero) {
        _initSystem(_lastSize, MediaQuery.devicePixelRatioOf(context));
      }
    } else if (textChanged && _lastSize != Size.zero) {
      // Only text changed — retarget existing particles (smooth morph)
      _system.setText(widget.text, _lastSize);
      widget.onTextChanged?.call();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    _system.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // super updates _ticker.muted via SingleTickerProviderStateMixin before we read it.
    super.didChangeDependencies();
    final muted = _ticker.muted;
    if (_lastTickerMuted == null) {
      // First call — record initial state without firing callbacks.
      _lastTickerMuted = muted;
      return;
    }
    if (muted == _lastTickerMuted) return;
    _lastTickerMuted = muted;
    // Only fire if no manual/lifecycle pause is in effect.
    if (widget.paused || _lifecyclePaused) return;
    if (!muted) {
      widget.onResume?.call();
    } else {
      widget.onPause?.call();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final shouldPause = state == AppLifecycleState.paused;
    if (shouldPause == _lifecyclePaused) return;
    _lifecyclePaused = shouldPause;
    _updateTickerState();
  }

  /// Starts or stops the ticker based on [widget.paused] and app lifecycle state.
  /// The ticker runs only when both are unpaused. Fires [onPause]/[onResume]
  /// on actual state transitions.
  void _updateTickerState() {
    final shouldRun = !widget.paused && !_lifecyclePaused;
    if (shouldRun) {
      if (!_ticker.isActive) {
        _ticker.start();
        widget.onResume?.call();
      }
    } else {
      if (_ticker.isActive) {
        _ticker.stop();
        widget.onPause?.call();
      }
    }
  }

  void _onTick(Duration elapsed) {
    // Drives physics → builds render data → notifyListeners → painter repaints
    // NO setState — only the CustomPaint canvas repaints
    _system.tick();
    if (!_readyFired && _system.isSettled) {
      _readyFired = true;
      widget.onReady?.call();
    }
  }

  Future<void> _initSystem(Size size, double dpr) async {
    final sizeChanged = _lastSize != size;
    _lastSize = size;
    _system.screenSize = size;
    _system.devicePixelRatio = dpr;

    // Create sprite texture (once)
    if (_system.sprite == null) {
      await _system.init();
    }

    if (!_initialized || sizeChanged) {
      _initialized = true;
      await _system.setText(widget.text, size);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);

    Widget child = LayoutBuilder(
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

    if (widget.expand) {
      child = SizedBox.expand(child: child);
    }

    return child;
  }
}
