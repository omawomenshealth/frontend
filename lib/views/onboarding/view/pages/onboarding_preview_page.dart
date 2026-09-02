import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/onboarding_prompt.dart';
import '../widgets/onboarding_typography.dart';

class OnboardingPreviewPage extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onComplete;

  const OnboardingPreviewPage({
    super.key,
    required this.vm,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final name = vm.userName.trim();
    final review = context.t.onboarding.review;
    final conditionSummary = vm.knownDiseases.isEmpty
        ? review.noConditions
        : vm.knownDiseases.map(AppStrings.localizeStoredValue).join(', ');
    final accountStorageSummary = vm.isUserLoggedIn
        ? review.googleStorage
        : review.guestStorage;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A5E5A52),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Image.asset(ImageConstants.logo),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              name.isEmpty ? review.title : review.titleWithName(name: name),
              textAlign: TextAlign.center,
              style: OnboardingTypography.welcomeDisplay.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              review.subtitle,
              textAlign: TextAlign.center,
              style: OnboardingTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          OnboardingPrompt(message: context.t.onboarding.prompt.review),
          const SizedBox(height: 18),
          _PreviewSummary(
            label: review.conditionsLabel,
            value: conditionSummary,
          ),
          _PreviewSummary(
            label: review.cycleLabel,
            value: review.dayCount(days: vm.averageCycleLength),
          ),
          _PreviewSummary(
            label: review.accountStorageLabel,
            value: accountStorageSummary,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.favorite_border_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                review.privacyAndData,
                style: OnboardingTypography.helper.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: vm.isSaving ? null : onComplete,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              backgroundColor: const Color(0xFF9252B5),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              textStyle: OnboardingTypography.button,
            ),
            child: vm.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(review.start),
          ),
        ],
      ),
    );
  }
}

class _PreviewSummary extends StatelessWidget {
  final String label;
  final String value;

  const _PreviewSummary({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: OnboardingTypography.helper.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: OnboardingTypography.counter.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
