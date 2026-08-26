import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../data/models/user_settings_model.dart';
import '../../viewmodel/onboarding_view_model.dart';

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
    final conditionSummary = vm.knownDiseases.isEmpty
        ? AppStrings.noConditionSelected
        : vm.knownDiseases.map(AppStrings.localizeStoredValue).join(', ');
    final smokingSummary = vm.smokingStatus == SmokingStatus.current
        ? AppStrings.yes
        : vm.smokingStatus == SmokingStatus.never
        ? AppStrings.no
        : 'Bıraktım';

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
              name.isEmpty ? AppStrings.great : 'Yanındayım, $name',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                color: AppColors.textPrimary,
                fontSize: 34,
                height: 1.05,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              AppStrings.profileReady,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0x157D4BA3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF9252B5)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.insightDataBuildingTitle,
                    style: const TextStyle(
                      color: Color(0xFF9252B5),
                      fontSize: 13,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _PreviewSummary(
            label: AppStrings.knownConditionQuestion,
            value: conditionSummary,
          ),
          _PreviewSummary(
            label: AppStrings.cycleInformation,
            value: AppStrings.dayCount(vm.averageCycleLength),
          ),
          _PreviewSummary(
            label: AppStrings.smokingStatus,
            value: smokingSummary,
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
                AppStrings.privacyAndData,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
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
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: vm.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(AppStrings.letsStart),
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
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
