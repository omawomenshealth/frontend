import 'package:flutter/material.dart';

import '../../../../../../core/widgets/oma_theme.dart';

class PhaseArtwork extends StatelessWidget {
  final OmaPhaseStyle palette;

  const PhaseArtwork({
    super.key,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -62,
          left: -65,
          child: _Flower(
            asset: palette.flowerAsset,
            size: 183,
          ),
        ),
        Positioned(
          right: -69,
          bottom: 45,
          child: _Flower(
            asset: palette.flowerAsset,
            size: 160,
            opacity: 0.72,
          ),
        ),
        Positioned(
          top: 125,
          right: 18,
          child: _Flower(
            asset: palette.flowerAsset,
            size: 42,
            opacity: 0.55,
          ),
        ),
      ],
    );
  }
}

class _Flower extends StatelessWidget {
  final String asset;
  final double size;
  final double opacity;

  const _Flower({
    required this.asset,
    required this.size,
    this.opacity = 1,
  });

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