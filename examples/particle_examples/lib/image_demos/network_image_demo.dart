import 'package:flutter/material.dart';
import 'package:particle_image/particle_image.dart';

class NetworkImageDemo extends StatefulWidget {
  const NetworkImageDemo({super.key});

  @override
  State<NetworkImageDemo> createState() => _NetworkImageDemoState();
}

class _NetworkImageDemoState extends State<NetworkImageDemo> {
  int _selectedUrl = 0;
  bool _useParticlePlaceholder = true;
  String? _statusMessage;
  Color _statusColor = Colors.white54;

  final _urls = [
    'https://avatars.githubusercontent.com/u/14101776?s=400', // Flutter
    'https://avatars.githubusercontent.com/u/1609975?s=400', // Dart
    'https://avatars.githubusercontent.com/u/1342004?s=400', // Google
    'https://this-url-does-not-exist.invalid/404.png', // Bad URL — triggers onError
  ];
  final _labels = ['Flutter', 'Dart', 'Google', '❌ Bad URL'];

  void _onImageLoaded() => setState(() => _statusMessage = null);

  void _onReady() {
    setState(() {
      _statusMessage = '✓ onReady — particles formed';
      _statusColor = const Color(0xFF69F0AE);
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _statusMessage = null);
    });
  }

  void _onError() => setState(() {
        _statusMessage = '⚠ onError — failed to load image';
        _statusColor = const Color(0xFFEF9A9A);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: Stack(
        children: [
          ParticleImage.network(
            _urls[_selectedUrl],
            key: ValueKey('net-$_selectedUrl'),
            placeholder: _useParticlePlaceholder ? null : const Center(child: CircularProgressIndicator()),
            config: const ParticleConfig(particleDensity: 2500, showPointerGlow: true),
            onImageLoaded: _onImageLoaded,
            onReady: _onReady,
            onError: _onError,
          ),
          if (_statusMessage != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _statusColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  _statusMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _statusColor, fontSize: 12.5),
                ),
              ),
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
                      Text(
                        'Placeholder: ',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
                      ),
                      _modeChip('Particle', true),
                      const SizedBox(width: 8),
                      _modeChip('Spinner', false),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_urls.length, (i) {
                        final sel = i == _selectedUrl;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedUrl = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: sel ? 0.12 : 0.04),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withValues(alpha: sel ? 0.25 : 0.08)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cloud_download,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: sel ? 0.8 : 0.3),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _labels[i],
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: sel ? 0.9 : 0.35),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _modeChip(String label, bool isParticle) {
    final sel = _useParticlePlaceholder == isParticle;
    return GestureDetector(
      onTap: () => setState(() => _useParticlePlaceholder = isParticle),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: sel ? 0.12 : 0.04),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withValues(alpha: sel ? 0.25 : 0.08)),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: sel ? 0.9 : 0.35), fontSize: 11),
        ),
      ),
    );
  }
}
