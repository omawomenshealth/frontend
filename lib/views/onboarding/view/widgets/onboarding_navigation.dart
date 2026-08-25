import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../viewmodel/onboarding_view_model.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingProgressHeader({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 6),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                ),
              ),
              const Spacer(),
              Text(
                '${currentPage + 1} / $totalPages',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(totalPages, (index) {
              final colors = [
                AppColors.accent,
                AppColors.primary,
                AppColors.secondary,
              ];
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: index <= currentPage
                        ? colors[index % colors.length]
                        : AppColors.outline,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class OnboardingBottomNavigation extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const OnboardingBottomNavigation({
    super.key,
    required this.vm,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = vm.currentPage > 0 || !vm.isFirstDetailStep;
    final isLast =
        vm.currentPage == vm.totalPages - 1 &&
      vm.isLastDetailStep;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Row(
        children: [
          if (canGoBack)
            Expanded(
              child: CustomButton(
                text: AppStrings.back,
                isOutlined: true,
                onPressed: onBack,
              ),
            ),
          if (canGoBack) const SizedBox(width: 10),
          Expanded(
            flex: canGoBack ? 2 : 1,
            child: CustomButton(
              text: isLast ? AppStrings.finish : AppStrings.next,
              isLoading: vm.isSaving,
              onPressed: onNext,
              gradient: isLast
                  ? const LinearGradient(
                      colors: [AppColors.secondary, AppColors.accent],
                    )
                  : AppColors.primaryGradient,
            ),
          ),
        ],
      ),
    );
  }
}