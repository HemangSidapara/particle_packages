import 'package:flutter/material.dart';
import 'package:particle_text/particle_text.dart';

/// Demonstrates the pause/resume API and lifecycle callbacks:
/// - [ParticleText.paused] — toggle animation on/off from code
/// - [ParticleText.onReady] — fires once when particles fully settle
/// - [ParticleText.onPause] — fires whenever animation stops
/// - [ParticleText.onResume] — fires whenever animation restarts
///
/// All three sources of pause are covered:
///   Manual  → tap the Pause/Resume button
///   Tab     → switch to another tab (TickerMode auto-pause, no code needed)
///   App bg  → background the app (WidgetsBindingObserver auto-pause)
class PauseDemo extends StatefulWidget {
  const PauseDemo({super.key});

  @override
  State<PauseDemo> createState() => _PauseDemoState();
}

class _PauseDemoState extends State<PauseDemo> {
  bool _paused = false;
  final List<_LogEntry> _log = [];

  void _addLog(String message, Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _log.insert(0, _LogEntry(message, color));
        if (_log.length > 5) _log.removeLast();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020308),
      appBar: AppBar(
        title: const Text('Pause & Callbacks'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ParticleText(
              text: _paused ? 'Paused' : 'Running',
              config: const ParticleConfig(
                particleDensity: 2000,
                backgroundColor: Color(0xFF020308),
              ),
              paused: _paused,
              onReady: () => _addLog('onReady — particles fully formed', const Color(0xFF69F0AE)),
              onPause: () => _addLog('onPause — animation stopped', const Color(0xFFFFB74D)),
              onResume: () => _addLog('onResume — animation running', const Color(0xFF64B5F6)),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 14, 16, MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'CALLBACK LOG',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 10, letterSpacing: 1.5),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 96,
                  child: _log.isEmpty
                      ? Center(
                          child: Text(
                            'Callbacks will appear here.\nTry pausing, resuming, or switching tabs.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 12),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _log.length,
                          itemBuilder: (_, i) {
                            final entry = _log[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(color: entry.color, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    entry.message,
                                    style: TextStyle(color: entry.color.withValues(alpha: 0.85), fontSize: 12.5),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => setState(() => _paused = !_paused),
                  icon: Icon(_paused ? Icons.play_arrow_rounded : Icons.pause_rounded, size: 20),
                  label: Text(_paused ? 'Resume Animation' : 'Pause Animation'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: _paused ? 0.14 : 0.08),
                    foregroundColor: Colors.white.withValues(alpha: 0.9),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tab switch & app background also fire onPause/onResume automatically.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogEntry {
  final String message;
  final Color color;
  const _LogEntry(this.message, this.color);
}
