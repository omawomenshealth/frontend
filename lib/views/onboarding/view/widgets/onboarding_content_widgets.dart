import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

class OnboardingCompactPrompt extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String description;
  final String summary;
  final String buttonLabel;
  final VoidCallback onPressed;

  const OnboardingCompactPrompt({
    super.key,
    required this.icon,
    required this.accent,
    required this.title,
    required this.description,
    required this.summary,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accent, size: 30),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            color: AppColors.textPrimary,
            fontSize: 21,
            height: 1.08,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11.5,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 13),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(backgroundColor: accent),
            icon: const Icon(Icons.search_rounded, size: 18),
            label: Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;
  final Widget child;
  final Widget? footer;

  const OnboardingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE3DFD7), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A5E5A52),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                color: AppColors.textPrimary,
                fontSize: 27,
                height: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: child,
                    ),
                  );
                },
              ),
            ),
            if (footer != null) ...[const SizedBox(height: 8), footer!],
          ],
        ),
      ),
    );
  }
}

class OnboardingFormCard extends StatelessWidget {
  final String eyebrow;
  final Widget child;

  const OnboardingFormCard({
    super.key,
    required this.eyebrow,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE3DFD7), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A5E5A52),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}