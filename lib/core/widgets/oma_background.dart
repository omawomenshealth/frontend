import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/image_constants.dart';

/// Sayfa arkasında hafifçe salınan dekoratif çiçekler.
///
/// Çiçekler `seed` değerine göre kenarlarda farklı noktalara dağılır.
class OmaBackground extends StatelessWidget {
  const OmaBackground({
    super.key,
    this.seed = 0,
    this.spotCount = 3,
    this.minSize = 60,
    this.maxSize = 88,
    this.bloomAssets = ImageConstants.decorativeBlooms,
  });

  final int seed;
  final int spotCount;
  final double minSize;
  final double maxSize;
  final List<String> bloomAssets;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pool = bloomAssets;
    final random = Random(seed);
    final sides = List.generate(spotCount, (index) => index.isEven)
      ..shuffle(random);
    final centers = <Offset>[];

    return IgnorePointer(
      child: Stack(
        children: [
          for (var i = 0; i < spotCount; i++)
            _buildSpot(i, size, pool, random, sides[i], centers),
        ],
      ),
    );
  }

  Widget _buildSpot(
    int index,
    Size size,
    List<String> pool,
    Random random,
    bool onLeft,
    List<Offset> centers,
  ) {
    final bloomSize = minSize + random.nextDouble() * (maxSize - minSize);
    late Offset center;
    for (var attempt = 0; attempt < 32; attempt++) {
      center = Offset(
        (onLeft ? 0.03 : 0.74) + random.nextDouble() * 0.23,
        0.07 + random.nextDouble() * 0.86,
      );
      if (centers.every((other) => (center - other).distance >= 0.22)) break;
    }
    centers.add(center);

    return Positioned(
      top: center.dy * size.height - bloomSize / 2,
      left: center.dx * size.width - bloomSize / 2,
      child: _SwayBloom(
        asset: pool[(seed * spotCount + index) % pool.length],
        size: bloomSize,
        rotation: (random.nextDouble() - 0.5) * 0.6,
        delay: Duration(milliseconds: index * 150),
        duration: Duration(milliseconds: 7000 + index * 800),
      ),
    );
  }
}

class _SwayBloom extends StatefulWidget {
  const _SwayBloom({
    required this.asset,
    required this.size,
    required this.rotation,
    required this.delay,
    required this.duration,
  });

  final String asset;
  final double size;
  final double rotation;
  final Duration delay;
  final Duration duration;

  @override
  State<_SwayBloom> createState() => _SwayBloomState();
}

class _SwayBloomState extends State<_SwayBloom>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_c.value);
        return Transform.translate(
          offset: Offset(0, -10 + t * 20),
          child: Transform.rotate(
            angle: widget.rotation + (t - 0.5) * 0.24,
            child: child,
          ),
        );
      },
      child: Opacity(
        opacity: 0.95,
        child: Image.asset(widget.asset, width: widget.size),
      ),
    );
  }
}
