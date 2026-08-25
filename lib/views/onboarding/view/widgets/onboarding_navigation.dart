import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../viewmodel/onboarding_view_model.dart';

class OnboardingBottomNavigation extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingBottomNavigation({
    super.key,
    required this.vm,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = vm.currentPage == vm.totalPages - 1 && vm.isLastDetailStep;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: vm.isSaving ? null : onNext,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: const Color(0xFF78904F),
                foregroundColor: AppColors.textOnPrimary,
                disabledBackgroundColor: const Color(0xFFBFCBB0),
                disabledForegroundColor: AppColors.textOnPrimary,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (vm.isSaving)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textOnPrimary,
                        ),
                      ),
                    )
                  else ...[
                    Text(isLast ? AppStrings.finish : AppStrings.next),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16),
                  ],
                ],
              ),
            ),
          ),
          if (!vm.isSaving)
            Container(
              width: double.infinity,
              height: 0,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3378904F),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
            ),
          if (!isLast) const SizedBox(height: 8),
          if (!isLast)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: vm.isSaving ? null : onSkip,
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  foregroundColor: AppColors.textSecondary,
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Text('Bu soruları şimdilik geç'),
              ),
            ),
        ],
      ),
    );
  }
}