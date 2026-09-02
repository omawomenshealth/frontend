import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';
import 'onboarding_prompt.dart';
import 'onboarding_typography.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final String prompt;
  final VoidCallback onBack;
  final bool canGoBack;

  const OnboardingProgressHeader({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.prompt,
    required this.onBack,
    required this.canGoBack,
  });

  @override
  Widget build(BuildContext context) {
    final safeTotalPages = totalPages <= 0 ? 1 : totalPages;
    final progress = ((currentPage + 1) / safeTotalPages)
        .clamp(0.0, 1.0)
        .toDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: canGoBack ? onBack : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.80),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A5E5A52),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: canGoBack
                        ? const Color(0xFF7A756C)
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: const Color(0xFFE3DFD7),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF78904F)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${currentPage + 1}/$safeTotalPages',
                style: OnboardingTypography.counter.copyWith(
                  color: Color(0xFF7A756C),
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OnboardingPrompt(message: prompt),
        ],
      ),
    );
  }
}
