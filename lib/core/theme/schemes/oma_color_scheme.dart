import 'package:flutter/material.dart';

@immutable
class OmaColorScheme {
  const OmaColorScheme({
    required this.primary,
    required this.primarySoft,
    required this.primaryStrong,
    required this.accent,
    required this.accentSoft,
    required this.border,
  });

  final Color primary;
  final Color primarySoft;
  final Color primaryStrong;
  final Color accent;
  final Color accentSoft;
  final Color border;
}
