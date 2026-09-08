import 'package:flutter/material.dart';

import '../../../../core/widgets/oma_theme.dart';

/// Geri butonu + ilerleme çizgileri + sayaç.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.index,
    required this.total,
    required this.onBack,
  });

  final int index;
  final int total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final safeTotal = total <= 0 ? 1 : total;

    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: OmaColors.card.withValues(alpha: 0.8),
              shape: BoxShape.circle,
              boxShadow: OmaShadows.soft,
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 16,
              color: OmaColors.muted,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              for (var i = 0; i < safeTotal; i++) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Stack(
                      children: [
                        Container(
                          height: 4,
                          color: OmaColors.border,
                        ),
                        AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          widthFactor: i <= index ? 1 : 0,
                          child: Container(
                            height: 4,
                            color: OmaColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (i != safeTotal - 1)
                  const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${index + 1}/$safeTotal',
          style: OmaText.body(
            12,
            color: OmaColors.muted,
          ),
        ),
      ],
    );
  }
}