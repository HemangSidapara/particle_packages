import 'package:flutter/material.dart';
import 'package:particle_text/particle_text.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ParticleTextDemo());
  }
}

class ParticleTextDemo extends StatefulWidget {
  const ParticleTextDemo({super.key});

  @override
  State<ParticleTextDemo> createState() => _ParticleTextDemoState();
}

class _ParticleTextDemoState extends State<ParticleTextDemo> {
  final String _text = 'Flutter';
  int _presetIndex = 0;

  final _presets = [
    ('Default', const ParticleConfig()),
    ('Cosmic', ParticleConfig.cosmic()),
    ('Fire', ParticleConfig.fire()),
    ('Matrix', ParticleConfig.matrix()),
    ('Pastel', ParticleConfig.pastel()),
    ('Minimal', ParticleConfig.minimal()),
  ];

  @override
  Widget build(BuildContext context) {
    final (label, config) = _presets[_presetIndex];

    return Scaffold(
      backgroundColor: config.backgroundColor,
      body: Stack(
        children: [
          // Full-screen particle text
          ParticleText(text: _text, config: config),

          // Preset selector at the bottom
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_presets.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_presets[i].$1),
                    selected: i == _presetIndex,
                    onSelected: (_) => setState(() => _presetIndex = i),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
