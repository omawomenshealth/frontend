import 'package:flutter/material.dart';

/// An Oma-themed horizontal content separator backed by Material [Divider].
///
/// Null properties inherit from the app's [DividerThemeData]. Explicit values
/// override those defaults while preserving native Material layout semantics.
class OmaDivider extends StatelessWidget {
  const OmaDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.radius,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final BorderRadiusGeometry? radius;

  @override
  Widget build(BuildContext context) => Divider(
    height: height,
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
    color: color,
    radius: radius,
  );
}

/// An Oma-themed vertical content separator backed by Material
/// [VerticalDivider].
///
/// Null properties inherit from the app's [DividerThemeData]. Explicit values
/// override those defaults while preserving native Material layout semantics.
class OmaVerticalDivider extends StatelessWidget {
  const OmaVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.radius,
  });

  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final BorderRadiusGeometry? radius;

  @override
  Widget build(BuildContext context) => VerticalDivider(
    width: width,
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
    color: color,
    radius: radius,
  );
}
