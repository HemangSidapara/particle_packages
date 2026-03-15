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
    const _WidgetPreset('Dense 2x', ParticleConfig(widgetDensityMultiplier: 2.0)),
    const _WidgetPreset('Sparse 0.3x', ParticleConfig(widgetDensityMultiplier: 0.3)),
    _WidgetPreset('Cosmic', ParticleConfig.cosmic()),
    _WidgetPreset('Fire', ParticleConfig.fire()),
    _WidgetPreset('Matrix', ParticleConfig.matrix()),
  ];

  static final _widgets = <_WidgetDef>[
    // 1. Profile Card — solid gradient bg + icon + text hierarchy
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
    // 2. Badge — pill shape, bold text, single solid color
    _WidgetDef(
      'Badge',
      Container(
        margin: const EdgeInsets.all(16),
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
    // 3. Logo Stack — sparse, transparent bg, icon + text row
    _WidgetDef(
      'Logo Stack',
      Padding(
        padding: const EdgeInsets.all(16),
        child: const Row(
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
    ),
    // 4. Gradient Box — 3-color gradient fill + centered icon
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
    // 5. Stats Row — multiple small elements, thin text, mixed sizes
    _WidgetDef(
      'Stats Row',
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatItem(icon: Icons.favorite, value: '2.4k', label: 'Likes', color: Colors.redAccent),
            SizedBox(width: 32),
            _StatItem(icon: Icons.visibility, value: '18k', label: 'Views', color: Colors.blueAccent),
            SizedBox(width: 32),
            _StatItem(icon: Icons.share, value: '340', label: 'Shares', color: Colors.greenAccent),
          ],
        ),
      ),
    ),
    // 6. Notification — small toast-like widget with icon + text
    _WidgetDef(
      'Toast',
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text('Payment successful!', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    ),
    // 7. Emoji Grid — pure text, no background, tests sparse colorful content
    _WidgetDef(
      'Emoji Grid',
      const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🔥🌊⚡🌿', style: TextStyle(fontSize: 48)),
            Text('🎯🎨🎵🚀', style: TextStyle(fontSize: 48)),
          ],
        ),
      ),
    ),
    // 8. Glass Card — semi-transparent overlay, subtle borders, layered
    _WidgetDef(
      'Glass Card',
      Container(
        width: 220,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withValues(alpha: 0.15), Colors.white.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud, size: 48, color: Colors.white70),
            SizedBox(height: 12),
            Text('22°C', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w300)),
            Text('Partly Cloudy', style: TextStyle(color: Colors.white60, fontSize: 14)),
          ],
        ),
      ),
    ),
    // 9. Progress Card — dark bg, colored progress bar, small details
    _WidgetDef(
      'Progress',
      Container(
        width: 240,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF212121),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Storage', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            const Text('64 GB / 128 GB', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.5,
                backgroundColor: Color(0xFF424242),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF42A5F5)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            const Text('50% used', style: TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    ),
    // 10. Chip Group — multiple small elements, outlined borders
    _WidgetDef(
      'Chip Group',
      Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip('Flutter', const Color(0xFF42A5F5)),
            _buildChip('Dart', const Color(0xFF00BCD4)),
            _buildChip('Firebase', const Color(0xFFFF9800)),
            _buildChip('GraphQL', const Color(0xFFE91E63)),
            _buildChip('Riverpod', const Color(0xFF7C4DFF)),
            _buildChip('Bloc', const Color(0xFF4CAF50)),
          ],
        ),
      ),
    ),
    // 11. Fine Print — very thin text, tests limits of particle resolution
    // Try with Dense 2x preset to see the difference
    _WidgetDef(
      'Fine Print',
      Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms of Service', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              'By using this app you agree to our\nprivacy policy and cookie usage.\nLast updated: March 2026.',
              style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4),
            ),
            SizedBox(height: 12),
            Divider(color: Colors.white24, height: 1),
            SizedBox(height: 8),
            Text('v2.4.1 · Build 847', style: TextStyle(color: Colors.white30, fontSize: 9)),
          ],
        ),
      ),
    ),
    // 12. Neon Sign — glowing text on dark bg, tests color vibrancy
    _WidgetDef(
      'Neon Sign',
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: const Text(
          'OPEN',
          style: TextStyle(
            color: Color(0xFF00FF88),
            fontSize: 52,
            fontWeight: FontWeight.w900,
            letterSpacing: 12,
            shadows: [
              Shadow(color: Color(0xFF00FF88), blurRadius: 20),
              Shadow(color: Color(0xFF00FF88), blurRadius: 40),
            ],
          ),
        ),
      ),
    ),
  ];

  static Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

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
          // Compare: original widget vs particle version
          // Responsive: vertical stack on narrow screens, side-by-side on wide
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 500;

                final original = _ComparePane(
                  label: 'Original Widget',
                  labelColor: Colors.white.withValues(alpha: 0.5),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: child,
                    ),
                  ),
                );
                final particles = _ComparePane(
                  label: 'As Particles',
                  labelColor: Colors.white.withValues(alpha: 0.5),
                  child: ParticleImage.widget(
                    FittedBox(fit: BoxFit.scaleDown, child: child),
                    config: config,
                  ),
                );

                if (isWide) {
                  return Row(
                    children: [
                      Expanded(child: original),
                      Container(width: 1, color: Colors.white.withValues(alpha: 0.1)),
                      Expanded(child: particles),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(child: original),
                      Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
                      Expanded(child: particles),
                    ],
                  );
                }
              },
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

class _ComparePane extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Widget child;

  const _ComparePane({required this.label, required this.labelColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(label, style: TextStyle(color: labelColor, fontSize: 12)),
        ),
        Expanded(child: ClipRect(child: child)),
      ],
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}
