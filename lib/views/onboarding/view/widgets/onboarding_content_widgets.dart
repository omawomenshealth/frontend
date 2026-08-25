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
          color: AppColors.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.88)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 26,
              offset: const Offset(0, 12),
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
                builder: (context, constraints) => FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: 480,
                    child: child,
                  ),
                ),
              ),
            ),
            if (footer != null) ...[const SizedBox(height: 8), footer!],
          ],
        ),
      ),
    );
  }
}