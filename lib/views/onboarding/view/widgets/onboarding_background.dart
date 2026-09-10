import 'package:flutter/material.dart';

import '../../../../core/shared_widgets/pastel_flower.dart';

class OnboardingBackground extends StatelessWidget {
  final int pageIndex;

  const OnboardingBackground({super.key, required this.pageIndex});

  static const _layouts = <List<_FlowerPlacement>>[
    [
      _FlowerPlacement(top: -30, right: -26, size: 118, rotation: 0.3),
      _FlowerPlacement(
        top: 84,
        left: -14,
        size: 58,
        rotation: 0.2,
        opacity: 0.52,
      ),
      _FlowerPlacement(top: 190, left: -24, size: 92, rotation: -0.25),
      _FlowerPlacement(
        top: 350,
        right: -16,
        size: 64,
        rotation: -0.18,
        opacity: 0.54,
      ),
      _FlowerPlacement(
        bottom: 224,
        left: 8,
        size: 54,
        rotation: 0.26,
        opacity: 0.5,
      ),
      _FlowerPlacement(bottom: 94, right: -24, size: 96, rotation: 0.18),
      _FlowerPlacement(bottom: -24, left: 32, size: 82, rotation: -0.15),
      _FlowerPlacement(
        bottom: 28,
        right: 16,
        size: 48,
        rotation: -0.3,
        opacity: 0.48,
      ),
    ],
    [
      _FlowerPlacement(top: -22, left: 22, size: 102, rotation: -0.2),
      _FlowerPlacement(
        top: 104,
        right: -12,
        size: 58,
        rotation: 0.22,
        opacity: 0.5,
      ),
      _FlowerPlacement(top: 236, right: -22, size: 90, rotation: 0.3),
      _FlowerPlacement(
        top: 388,
        left: -14,
        size: 62,
        rotation: -0.25,
        opacity: 0.52,
      ),
      _FlowerPlacement(
        bottom: 226,
        right: 4,
        size: 54,
        rotation: -0.16,
        opacity: 0.48,
      ),
      _FlowerPlacement(bottom: 108, left: -24, size: 94, rotation: 0.16),
      _FlowerPlacement(bottom: -20, right: 28, size: 84, rotation: 0.22),
      _FlowerPlacement(
        bottom: 38,
        left: 16,
        size: 48,
        rotation: 0.28,
        opacity: 0.46,
      ),
    ],
    [
      _FlowerPlacement(top: -26, right: 36, size: 108, rotation: 0.18),
      _FlowerPlacement(
        top: 80,
        left: -12,
        size: 56,
        rotation: -0.26,
        opacity: 0.5,
      ),
      _FlowerPlacement(top: 248, left: -22, size: 88, rotation: 0.22),
      _FlowerPlacement(
        top: 402,
        right: -14,
        size: 62,
        rotation: -0.18,
        opacity: 0.52,
      ),
      _FlowerPlacement(
        bottom: 238,
        left: 12,
        size: 52,
        rotation: 0.3,
        opacity: 0.48,
      ),
      _FlowerPlacement(bottom: 108, right: -26, size: 98, rotation: -0.14),
      _FlowerPlacement(bottom: -18, left: 42, size: 80, rotation: 0.2),
      _FlowerPlacement(
        bottom: 34,
        right: 18,
        size: 50,
        rotation: -0.3,
        opacity: 0.46,
      ),
    ],
    [
      _FlowerPlacement(top: -24, left: -14, size: 110, rotation: -0.18),
      _FlowerPlacement(
        top: 114,
        right: -12,
        size: 58,
        rotation: 0.28,
        opacity: 0.5,
      ),
      _FlowerPlacement(top: 222, right: -24, size: 94, rotation: -0.22),
      _FlowerPlacement(
        top: 374,
        left: -12,
        size: 64,
        rotation: 0.2,
        opacity: 0.52,
      ),
      _FlowerPlacement(
        bottom: 242,
        right: 8,
        size: 54,
        rotation: -0.24,
        opacity: 0.48,
      ),
      _FlowerPlacement(bottom: 102, left: -26, size: 96, rotation: 0.16),
      _FlowerPlacement(bottom: -22, right: 34, size: 86, rotation: -0.18),
      _FlowerPlacement(
        bottom: 32,
        left: 18,
        size: 48,
        rotation: 0.3,
        opacity: 0.46,
      ),
    ],
    [
      _FlowerPlacement(top: -28, right: -20, size: 114, rotation: 0.26),
      _FlowerPlacement(
        top: 94,
        left: -14,
        size: 56,
        rotation: -0.2,
        opacity: 0.5,
      ),
      _FlowerPlacement(top: 210, left: -22, size: 90, rotation: 0.24),
      _FlowerPlacement(
        top: 396,
        right: -14,
        size: 64,
        rotation: -0.24,
        opacity: 0.52,
      ),
      _FlowerPlacement(
        bottom: 232,
        left: 10,
        size: 52,
        rotation: 0.22,
        opacity: 0.48,
      ),
      _FlowerPlacement(bottom: 98, right: -24, size: 98, rotation: 0.14),
      _FlowerPlacement(bottom: -20, left: 38, size: 84, rotation: -0.2),
      _FlowerPlacement(
        bottom: 30,
        right: 14,
        size: 50,
        rotation: 0.28,
        opacity: 0.46,
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final layout = _layouts[pageIndex % _layouts.length];
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFDFBF7),
                  Color(0xFFF4F0E8),
                  Color(0xFFE8EDE0),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        for (var index = 0; index < layout.length; index++)
          Positioned(
            top: layout[index].top,
            bottom: layout[index].bottom,
            left: layout[index].left,
            right: layout[index].right,
            child: PastelFlower(
              key: ValueKey('onboarding_flower_${pageIndex}_$index'),
              size: layout[index].size,
              rotation: layout[index].rotation,
              opacity: layout[index].opacity,
            ),
          ),
      ],
    );
  }
}

class _FlowerPlacement {
  final double size;
  final double rotation;
  final double opacity;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _FlowerPlacement({
    required this.size,
    required this.rotation,
    this.opacity = 0.72,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}
