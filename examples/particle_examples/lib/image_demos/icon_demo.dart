import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:particle_image/particle_image.dart';

class _IconDef {
  final String name;
  final IconData icon;

  const _IconDef(this.name, this.icon);
}

class _FaDef {
  final String name;
  final FaIconData icon;

  const _FaDef(this.name, this.icon);
}

class IconParticleDemo extends StatefulWidget {
  const IconParticleDemo({super.key});

  @override
  State<IconParticleDemo> createState() => _IconParticleDemoState();
}

class _IconParticleDemoState extends State<IconParticleDemo> {
  int _tab = 0; // 0 = Material, 1 = Font Awesome
  int _selectedMaterial = 0;
  int _selectedFa = 0;
  int _selectedColor = 0;

  final _materialIcons = const [
    _IconDef('Favorite', Icons.favorite),
    _IconDef('Star', Icons.star),
    _IconDef('Rocket', Icons.rocket_launch),
    _IconDef('Music', Icons.music_note),
    _IconDef('Bolt', Icons.bolt),
    _IconDef('Cloud', Icons.cloud),
  ];

  final _faIcons = const [
    _FaDef('Rocket', FontAwesomeIcons.rocket),
    _FaDef('Dragon', FontAwesomeIcons.dragon),
    _FaDef('Star', FontAwesomeIcons.star),
    _FaDef('Ghost', FontAwesomeIcons.ghost),
    _FaDef('Fire', FontAwesomeIcons.fire),
    _FaDef('Bolt', FontAwesomeIcons.bolt),
  ];

  final _colors = [
    const Color(0xFFFF4466),
    const Color(0xFFFFCC00),
    const Color(0xFF54C5F8),
    const Color(0xFF88FF88),
    const Color(0xFFFF8844),
    Colors.white,
  ];

  Color get _currentColor => _colors[_selectedColor];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: Stack(
        children: [
          if (_tab == 0)
            ParticleImage.icon(
              _materialIcons[_selectedMaterial].icon,
              key: ValueKey('mat-$_selectedMaterial-$_selectedColor'),
              iconColor: _currentColor,
              iconSize: 260,
              config: const ParticleConfig(particleDensity: 3000, showPointerGlow: true),
            )
          else
            ParticleImage.faIcon(
              _faIcons[_selectedFa].icon,
              key: ValueKey('fa-$_selectedFa-$_selectedColor'),
              iconColor: _currentColor,
              iconSize: 260,
              config: const ParticleConfig(particleDensity: 3000, showPointerGlow: true),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white.withValues(alpha: 0.4)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Text(
                  'TOUCH & DRAG',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10, letterSpacing: 2),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _tabChip('Material', 0),
                      const SizedBox(width: 8),
                      _tabChip('Font Awesome', 1),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tab == 0
                          ? List.generate(_materialIcons.length, (i) {
                              final d = _materialIcons[i];
                              final sel = i == _selectedMaterial;
                              return _iconChip(
                                selected: sel,
                                onTap: () => setState(() => _selectedMaterial = i),
                                icon: Icon(
                                  d.icon,
                                  size: 22,
                                  color: sel ? _currentColor : Colors.white.withValues(alpha: 0.35),
                                ),
                                label: d.name,
                              );
                            })
                          : List.generate(_faIcons.length, (i) {
                              final d = _faIcons[i];
                              final sel = i == _selectedFa;
                              return _iconChip(
                                selected: sel,
                                onTap: () => setState(() => _selectedFa = i),
                                icon: FaIcon(
                                  d.icon,
                                  size: 20,
                                  color: sel ? _currentColor : Colors.white.withValues(alpha: 0.35),
                                ),
                                label: d.name,
                              );
                            }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_colors.length, (i) {
                      final sel = i == _selectedColor;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = i),
                        child: Container(
                          width: 26,
                          height: 26,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _colors[i],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: sel ? Colors.white : Colors.white.withValues(alpha: 0.2),
                              width: sel ? 2 : 1,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(String label, int index) {
    final sel = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: sel ? 0.12 : 0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: sel ? 0.25 : 0.08)),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: sel ? 0.9 : 0.35), fontSize: 12),
        ),
      ),
    );
  }

  Widget _iconChip({required bool selected, required VoidCallback onTap, required Widget icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: selected ? _currentColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? _currentColor.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: selected ? _currentColor : Colors.white.withValues(alpha: 0.35),
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
