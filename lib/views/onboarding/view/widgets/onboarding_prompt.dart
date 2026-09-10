import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/oma_theme.dart';

class OnboardingPrompt extends StatelessWidget {
  const OnboardingPrompt({
    super.key,
    required this.message,
    this.animate = true,
  });

  final String message;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: OmaColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 16,
            color: OmaColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              height: 1.6,
              color: OmaColors.foreground.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );

    if (!animate) {
      return row;
    }

    return _Rise(
      key: ValueKey(message),
      child: row,
    );
  }
}

class _Rise extends StatefulWidget {
  const _Rise({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<_Rise> createState() => _RiseState();
}

class _RiseState extends State<_Rise>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  )..forward();

  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.18),
          end: Offset.zero,
        ).animate(_curve),
        child: widget.child,
      ),
    );
  }
}