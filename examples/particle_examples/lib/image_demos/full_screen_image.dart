import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';
import '../shared/models.dart';

class FullScreenImageDemo extends StatefulWidget {
  const FullScreenImageDemo({super.key});

  @override
  State<FullScreenImageDemo> createState() => _FullScreenImageDemoState();
}

class _FullScreenImageDemoState extends State<FullScreenImageDemo> {
  int _selectedIcon = -1;
  int _bgMode = 0;
  int _assetIndex = 0;

  final _icons = [
    IconDef('Heart', Icons.favorite, const Color(0xFFFF4466)),
    IconDef('Star', Icons.star, const Color(0xFFFFCC00)),
    IconDef('Music', Icons.music_note, const Color(0xFF88FF88)),
    IconDef('Rocket', Icons.rocket_launch, const Color(0xFFFF8844)),
  ];

  final _assets = ['assets/flutter_logo.png', 'assets/mw_logo.png'];
  final _bgLabels = ['Dark', 'Light', 'Transparent'];

  Color get _bgColor => switch (_bgMode) {
    1 => Colors.white,
    2 => Colors.transparent,
    _ => const Color(0xFF050508),
  };

  Color get _scaffoldBg => switch (_bgMode) {
    1 => Colors.white,
    2 => const Color(0xFFF5F5F5),
    _ => const Color(0xFF050508),
  };

  Color get _themeColor => _bgMode == 0 ? Colors.white : Colors.black;

  ParticleConfig get _config => ParticleConfig(
    particleDensity: 3000,
    drawBackground: _bgMode != 2,
    backgroundColor: _bgColor,
    showPointerGlow: _bgMode == 0,
    pointerGlowColor: _bgMode == 0 ? const Color(0xFFC8D2F0) : Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    final isAssetMode = _selectedIcon < 0;
    final def = isAssetMode ? null : _icons[_selectedIcon];

    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: Stack(
        children: [
          if (isAssetMode)
            ParticleImage.asset(
              _assets[_assetIndex],
              key: ValueKey('asset-$_assetIndex-$_bgMode'),
              config: _config,
            )
          else
            ParticleImage.icon(
              def!.icon,
              key: ValueKey('icon-$_selectedIcon-$_bgMode'),
              iconColor: def.color,
              iconSize: 256,
              config: _config,
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: _themeColor.withValues(alpha: 0.4)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Text(
                  'TOUCH & DRAG',
                  style: TextStyle(color: _themeColor.withValues(alpha: 0.2), fontSize: 10, letterSpacing: 2),
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
                color: (_bgMode == 0 ? Colors.black : Colors.white).withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _themeColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Background: ', style: TextStyle(color: _themeColor.withValues(alpha: 0.4), fontSize: 11)),
                      ...List.generate(3, (i) {
                        final sel = i == _bgMode;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => setState(() => _bgMode = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _themeColor.withValues(alpha: sel ? 0.15 : 0.04),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: _themeColor.withValues(alpha: sel ? 0.3 : 0.08)),
                              ),
                              child: Text(
                                _bgLabels[i],
                                style: TextStyle(color: _themeColor.withValues(alpha: sel ? 0.9 : 0.35), fontSize: 11),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(_assets.length, (i) {
                          final sel = isAssetMode && i == _assetIndex;
                          return _chip(
                            selected: sel,
                            accentColor: const Color(0xFF54C5F8),
                            onTap: () => setState(() {
                              _selectedIcon = -1;
                              _assetIndex = i;
                            }),
                            child: Icon(
                              Icons.image,
                              size: 20,
                              color: sel ? const Color(0xFF54C5F8) : _themeColor.withValues(alpha: 0.35),
                            ),
                            label: i == 0 ? 'Logo1' : 'Logo2',
                          );
                        }),
                        ...List.generate(_icons.length, (i) {
                          final sel = !isAssetMode && i == _selectedIcon;
                          final d = _icons[i];
                          return _chip(
                            selected: sel,
                            accentColor: d.color,
                            onTap: () => setState(() => _selectedIcon = i),
                            child: Icon(d.icon, size: 22, color: sel ? d.color : _themeColor.withValues(alpha: 0.35)),
                            label: d.name,
                          );
                        }),
                      ],
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

  Widget _chip({
    required bool selected,
    required Color accentColor,
    required VoidCallback onTap,
    required Widget child,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: selected ? accentColor.withValues(alpha: 0.15) : _themeColor.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? accentColor.withValues(alpha: 0.4) : _themeColor.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: selected ? accentColor : _themeColor.withValues(alpha: 0.35),
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
