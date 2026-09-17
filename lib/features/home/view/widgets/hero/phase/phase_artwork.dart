import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../../core/widgets/oma_theme.dart';

class PhaseArtwork extends StatefulWidget {
  final OmaPhaseStyle palette;

  const PhaseArtwork({super.key, required this.palette});

  @override
  State<PhaseArtwork> createState() => _PhaseArtworkState();
}

class _PhaseArtworkState extends State<PhaseArtwork>
    with SingleTickerProviderStateMixin {
  late List<String> _flowerAssets = _pickFlowerAssets(widget.palette);

  static List<String> _pickFlowerAssets(OmaPhaseStyle palette) {
    final folder = switch (palette.number) {
      '01' => 'menstrual',
      '02' => 'follicular',
      '03' => 'ovulation',
      '04' => 'luteal',
      _ => throw StateError('Unknown phase: ${palette.number}'),
    };
    final varieties = List.generate(4, (index) => index + 1)
      ..shuffle(math.Random());
    return List.generate(3 + _driftingFlowers.length, (index) {
      final variety = varieties[index % varieties.length];
      final name = 'phase_bloom_${variety.toString().padLeft(2, '0')}.png';
      return 'assets/images/decorative/blooms/$folder/$name';
    });
  }

  static const _driftingFlowers = <_DriftingFlower>[
    _DriftingFlower(
      x: 0.06,
      phase: 0.00,
      speed: 0.86,
      size: 18,
      sway: 14,
      opacity: 0.48,
    ),
    _DriftingFlower(
      x: 0.88,
      phase: 0.18,
      speed: 1.05,
      size: 14,
      sway: 12,
      opacity: 0.55,
    ),
    _DriftingFlower(
      x: 0.18,
      phase: 0.34,
      speed: 1.12,
      size: 23,
      sway: 17,
      opacity: 0.38,
    ),
    _DriftingFlower(
      x: 0.76,
      phase: 0.51,
      speed: 0.94,
      size: 20,
      sway: 16,
      opacity: 0.42,
    ),
    _DriftingFlower(
      x: 0.94,
      phase: 0.67,
      speed: 1.18,
      size: 12,
      sway: 11,
      opacity: 0.58,
    ),
    _DriftingFlower(
      x: 0.10,
      phase: 0.82,
      speed: 1.00,
      size: 15,
      sway: 13,
      opacity: 0.50,
    ),
  ];

  late final AnimationController _fall = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
  );

  @override
  void didUpdateWidget(covariant PhaseArtwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.palette.number != widget.palette.number) {
      _flowerAssets = _pickFlowerAssets(widget.palette);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _fall.stop();
    } else if (!_fall.isAnimating) {
      _fall.repeat();
    }
  }

  @override
  void dispose() {
    _fall.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return ExcludeSemantics(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) => RepaintBoundary(
            child: AnimatedBuilder(
              animation: _fall,
              builder: (context, _) => Stack(
                fit: StackFit.expand,
                children: [
                  _StaticFlowers(
                    assets: _flowerAssets,
                    breeze: reduceMotion
                        ? 0
                        : math.sin(_fall.value * 2 * math.pi),
                    offsetBreeze: reduceMotion
                        ? 0
                        : math.sin(_fall.value * 2 * math.pi + 1.4),
                  ),
                  if (!reduceMotion)
                    for (
                      var index = 0;
                      index < _driftingFlowers.length;
                      index++
                    )
                      _driftingFlower(
                        _driftingFlowers[index],
                        constraints.biggest,
                        _flowerAssets[index + 3],
                        index,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _driftingFlower(
    _DriftingFlower flower,
    Size bounds,
    String asset,
    int index,
  ) {
    final progress = (_fall.value * flower.speed + flower.phase) % 1;
    final angle = progress * 2 * math.pi;
    final x = bounds.width * flower.x + math.sin(angle * 1.7) * flower.sway;
    final y = -flower.size + (bounds.height + flower.size * 2) * progress;
    final fade = math.sin(math.pi * progress).clamp(0.0, 1.0);

    return Positioned(
      key: ValueKey('drifting_flower_$index'),
      left: x,
      top: y,
      child: Transform.rotate(
        angle: math.sin(angle * 1.2 + flower.phase) * 0.32 + progress * 0.4,
        child: _Flower(
          asset: asset,
          size: flower.size,
          opacity: flower.opacity * fade,
        ),
      ),
    );
  }
}

class _StaticFlowers extends StatelessWidget {
  const _StaticFlowers({
    required this.assets,
    required this.breeze,
    required this.offsetBreeze,
  });

  final List<String> assets;
  final double breeze;
  final double offsetBreeze;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        key: const ValueKey('anchored_flower_0'),
        top: -62 + breeze * 2,
        left: -65 + breeze * 4,
        child: Transform.rotate(
          angle: breeze * 0.032,
          alignment: Alignment.topCenter,
          child: _Flower(asset: assets[0], size: 183),
        ),
      ),
      Positioned(
        key: const ValueKey('anchored_flower_1'),
        right: -69 + offsetBreeze * 3,
        bottom: 45 + offsetBreeze * 2,
        child: Transform.rotate(
          angle: -offsetBreeze * 0.028,
          alignment: Alignment.topRight,
          child: _Flower(asset: assets[1], size: 160, opacity: 0.72),
        ),
      ),
      Positioned(
        key: const ValueKey('anchored_flower_2'),
        top: 125 + breeze * 3,
        right: 18 + breeze * 3,
        child: Transform.rotate(
          angle: breeze * 0.055,
          alignment: Alignment.topCenter,
          child: _Flower(asset: assets[2], size: 42, opacity: 0.55),
        ),
      ),
    ],
  );
}

class _DriftingFlower {
  const _DriftingFlower({
    required this.x,
    required this.phase,
    required this.speed,
    required this.size,
    required this.sway,
    required this.opacity,
  });

  final double x;
  final double phase;
  final double speed;
  final double size;
  final double sway;
  final double opacity;
}

class _Flower extends StatelessWidget {
  final String asset;
  final double size;
  final double opacity;

  const _Flower({required this.asset, required this.size, this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
