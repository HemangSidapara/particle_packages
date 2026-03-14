import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class WidgetParticleDemo extends StatefulWidget {
  const WidgetParticleDemo({super.key});

  @override
  State<WidgetParticleDemo> createState() => _WidgetParticleDemoState();
}

class _WidgetParticleDemoState extends State<WidgetParticleDemo> {
  int _selected = 0;

  final _presets = [
    const _WidgetPreset('Default', ParticleConfig()),
    _WidgetPreset('Cosmic', ParticleConfig.cosmic()),
    _WidgetPreset('Fire', ParticleConfig.fire()),
    _WidgetPreset('Matrix', ParticleConfig.matrix()),
  ];

  static final _widgets = <_WidgetDef>[
    _WidgetDef(
      'Profile Card',
      Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'John Doe',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Flutter Developer', style: TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    ),
    _WidgetDef(
      'Badge',
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Text(
          'LIVE',
          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 8),
        ),
      ),
    ),
    _WidgetDef(
      'Logo Stack',
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flutter_dash, size: 80, color: Color(0xFF42A5F5)),
          SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flutter',
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Text('Particles', style: TextStyle(color: Colors.white54, fontSize: 20)),
            ],
          ),
        ],
      ),
    ),
    _WidgetDef(
      'Gradient Box',
      Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.orange, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Center(
          child: Icon(Icons.auto_awesome, size: 100, color: Colors.white),
        ),
      ),
    ),
  ];

  int _presetIndex = 0;

  @override
  Widget build(BuildContext context) {
    final config = _presets[_presetIndex].config;
    final child = _widgets[_selected].widget;

    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        title: const Text('Widget → Particles'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Side-by-side: original widget vs particle version
          Expanded(
            child: Row(
              children: [
                // Left: original widget
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Text(
                          'Original Widget',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Center(child: child),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(width: 1, color: Colors.white.withValues(alpha: 0.1)),
                // Right: particle version
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 12),
                        child: Text(
                          'As Particles',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: ParticleImage.widget(child, config: config),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Widget selector
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _widgets.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final active = i == _selected;
                        return ChoiceChip(
                          label: Text(_widgets[i].name),
                          selected: active,
                          onSelected: (_) => setState(() => _selected = i),
                          selectedColor: Colors.white.withValues(alpha: 0.2),
                          labelStyle: TextStyle(color: active ? Colors.white : Colors.white54, fontSize: 13),
                          backgroundColor: Colors.white.withValues(alpha: 0.06),
                          side: BorderSide.none,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Preset selector
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _presets.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final active = i == _presetIndex;
                        return ChoiceChip(
                          label: Text(_presets[i].name),
                          selected: active,
                          onSelected: (_) => setState(() => _presetIndex = i),
                          selectedColor: Colors.white.withValues(alpha: 0.2),
                          labelStyle: TextStyle(color: active ? Colors.white : Colors.white54, fontSize: 13),
                          backgroundColor: Colors.white.withValues(alpha: 0.06),
                          side: BorderSide.none,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetDef {
  final String name;
  final Widget widget;
  const _WidgetDef(this.name, this.widget);
}

class _WidgetPreset {
  final String name;
  final ParticleConfig config;
  const _WidgetPreset(this.name, this.config);
}
