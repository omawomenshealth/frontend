import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/oma_theme.dart';

/// Native açılış ekranından sonra gösterilen animasyonlu Oma splash ekranı.
class SplashView extends StatefulWidget {
  const SplashView({
    super.key,
    required this.onDone,
    this.hold = const Duration(milliseconds: 2600),
    this.fade = const Duration(milliseconds: 500),
  });

  final VoidCallback onDone;
  final Duration hold;
  final Duration fade;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _Bloom {
  const _Bloom(this.asset, this.top, this.left, this.size, this.rotation);

  final String asset;
  final double top;
  final double left;
  final double size;
  final double rotation;
}

const _blooms = <_Bloom>[
  _Bloom('assets/images/decorative/blooms/bloom-01.png', 0.08, 0.08, 88, -12),
  _Bloom('assets/images/decorative/blooms/bloom-03.png', 0.09, 0.74, 80, 14),
  _Bloom('assets/images/decorative/blooms/bloom-02.png', 0.20, 0.44, 96, -6),
  _Bloom('assets/images/decorative/blooms/bloom-04.png', 0.30, 0.80, 80, 18),
  _Bloom('assets/images/decorative/blooms/bloom-03.png', 0.34, 0.04, 72, -20),
  _Bloom('assets/images/decorative/blooms/bloom-04.png', 0.58, 0.07, 80, 22),
  _Bloom('assets/images/decorative/blooms/bloom-02.png', 0.62, 0.72, 88, -10),
  _Bloom('assets/images/decorative/blooms/bloom-01.png', 0.72, 0.14, 96, 6),
  _Bloom('assets/images/decorative/blooms/bloom-01.png', 0.78, 0.62, 80, -16),
];

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _exit;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();
    _exit = AnimationController(vsync: this, duration: widget.fade);
    _finishSplash();
  }

  Future<void> _finishSplash() async {
    await Future<void>.delayed(widget.hold);
    if (!mounted) return;
    await _exit.forward();
    if (mounted) widget.onDone();
  }

  @override
  void dispose() {
    _intro.dispose();
    _exit.dispose();
    super.dispose();
  }

  double _stagger(double start, double span) {
    final value = ((_intro.value - start) / span).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(value);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: context.omaTheme.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([_intro, _exit]),
        builder: (context, _) => Opacity(
          opacity: 1 - _exit.value,
          child: OmaSurface(
            child: SizedBox.expand(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < _blooms.length; i++)
                    _buildBloom(_blooms[i], i, screen),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _bloomIn(
                          progress: _stagger(0.05, 0.45),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/brand/logo-mark.png',
                                width: 144,
                                height: 144,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: OmaSpacing.lg),
                              Text('Oma', style: OmaText.display(56)),
                            ],
                          ),
                        ),
                        const SizedBox(height: OmaSpacing.lg),
                        _riseIn(
                          progress: _stagger(0.45, 0.4),
                          child: Text(
                            'Sağlığını kendi ritminde takip et',
                            textAlign: TextAlign.center,
                            style: OmaText.body(
                              14,
                              color: context.omaTheme.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBloom(_Bloom bloom, int index, Size screen) {
    final start = (0.15 + index * 0.13) / 2.2;
    final progress = _stagger(start.clamp(0.0, 0.95).toDouble(), 0.28);

    return Positioned(
      top: screen.height * bloom.top,
      left: screen.width * bloom.left,
      child: IgnorePointer(
        child: Opacity(
          opacity: progress,
          child: Transform.rotate(
            angle: bloom.rotation * math.pi / 180 * progress,
            child: Transform.scale(
              scale: 0.7 + 0.3 * progress,
              child: Image.asset(
                bloom.asset,
                width: bloom.size,
                height: bloom.size,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bloomIn({required double progress, required Widget child}) {
    return Opacity(
      opacity: progress,
      child: Transform.scale(scale: 0.88 + 0.12 * progress, child: child),
    );
  }

  Widget _riseIn({required double progress, required Widget child}) {
    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, 16 * (1 - progress)),
        child: child,
      ),
    );
  }
}
