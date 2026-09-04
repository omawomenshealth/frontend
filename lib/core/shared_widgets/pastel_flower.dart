import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/image_constants.dart';

class PastelFlower extends StatefulWidget {
  final double size;
  final double rotation;
  final double opacity;

  const PastelFlower({
    super.key,
    required this.size,
    this.rotation = 0,
    this.opacity = 0.72,
  });

  @override
  State<PastelFlower> createState() => _PastelFlowerState();
}

class _PastelFlowerState extends State<PastelFlower> {
  late final String _asset =
      ImageConstants.decorativeBlooms[Random().nextInt(
        ImageConstants.decorativeBlooms.length,
      )];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Transform.rotate(
        angle: widget.rotation,
        child: Opacity(
          opacity: widget.opacity,
          child: Image.asset(
            _asset,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
