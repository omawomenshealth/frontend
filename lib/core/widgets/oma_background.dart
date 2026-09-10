import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/image_constants.dart';

/// Sayfa arkasında hafifçe salınan dekoratif çiçekler.
///
/// Konumlar sabit bir liste yerine `seed` değerinden üretilir; farklı
/// ekran/kartlara farklı bir dizilim vermek için farklı bir `seed` yeterlidir.
class OmaBackground extends StatelessWidget {
  const OmaBackground({
    super.key,
    this.seed = 0,
    this.spotCount = 5,
    this.minSize = 60,
    this.maxSize = 88,
  });

  final int seed;
  final int spotCount;
  final double minSize;
  final double maxSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final pool = ImageConstants.decorativeBlooms;
    final random = Random(seed);

    return IgnorePointer(
      child: Stack(
        children: [
          for (var i = 0; i < spotCount; i++)
            _buildSpot(i, size, pool, random),
        ],
      ),
    );
  }

  Widget _buildSpot(int index, Size size, List<String> pool, Random random) {
    final band = index / spotCount;
    final verticalJitter = random.nextDouble() * (1 / spotCount);
    final onLeft = index.isEven;
    final edgeOffset = random.nextDouble() * 0.05 * size.width;

    return Positioned(
      top: (band + verticalJitter) * size.height,
      left: onLeft ? edgeOffset - 0.02 * size.width : null,
      right: onLeft ? null : edgeOffset,
      child: _SwayBloom(
        asset: pool[(seed * spotCount + index) % pool.length],
        size: minSize + random.nextDouble() * (maxSize - minSize),
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
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);

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
