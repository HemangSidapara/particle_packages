import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class ImageFitDemo extends StatefulWidget {
  const ImageFitDemo({super.key});

  @override
  State<ImageFitDemo> createState() => _ImageFitDemoState();
}

class _ImageFitDemoState extends State<ImageFitDemo> {
  int _selectedFit = 0;
  bool _useIcon = false;

  static const _fits = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
    BoxFit.fitWidth,
    BoxFit.fitHeight,
    BoxFit.scaleDown,
    BoxFit.none,
  ];

  static const _fitLabels = [
    'contain',
    'cover',
    'fill',
    'fitWidth',
    'fitHeight',
    'scaleDown',
    'none',
  ];

  @override
  Widget build(BuildContext context) {
    final config = ParticleConfig(
      imageFit: _fits[_selectedFit],
      particleDensity: 3000,
      backgroundColor: const Color(0xFF050508),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: Stack(
        children: [
          if (_useIcon)
            ParticleImage.icon(
              Icons.rocket_launch,
              key: ValueKey('icon-fit-$_selectedFit'),
              iconColor: const Color(0xFFFF8844),
              iconSize: 256,
              config: config,
            )
          else
            ParticleImage.asset(
              'assets/flutter_logo.png',
              key: ValueKey('asset-fit-$_selectedFit'),
              config: config,
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
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BoxFit.${_fitLabels[_selectedFit]}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => setState(() => _useIcon = !_useIcon),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _useIcon ? Icons.rocket_launch : Icons.image,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _useIcon ? 'Icon' : 'Asset',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_fits.length, (i) {
                        final sel = i == _selectedFit;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(_fitLabels[i], style: const TextStyle(fontSize: 11)),
                            selected: sel,
                            selectedColor: Colors.white.withValues(alpha: 0.2),
                            backgroundColor: Colors.white.withValues(alpha: 0.05),
                            side: BorderSide(color: Colors.white.withValues(alpha: sel ? 0.3 : 0.08)),
                            labelStyle: TextStyle(color: Colors.white.withValues(alpha: sel ? 0.9 : 0.4)),
                            onSelected: (_) => setState(() => _selectedFit = i),
                          ),
                        );
                      }),
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
