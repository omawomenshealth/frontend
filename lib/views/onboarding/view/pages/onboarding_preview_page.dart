import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/theme/oma_typography.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../viewmodel/onboarding_view_model.dart';

const _readyPlum = Color(0xFF7A4F63);
const _readyPlumForeground = Color(0xFFFFF7FA);
const _readyPlumSoft = Color(0x1A7A4F63);

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

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14705F4A),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(ImageConstants.logo),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  name.isEmpty
                      ? review.title
                      : review.titleWithName(name: name),
                  textAlign: TextAlign.center,
                  style: OmaTypography.display(
                    size: 32,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  review.subtitle,
                  textAlign: TextAlign.center,
                  style: OmaTypography.body(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                _PreviewNote(message: context.t.onboarding.prompt.review),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x26705F4A),
                          blurRadius: 32,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: vm.isSaving ? null : onComplete,
                      style: FilledButton.styleFrom(
                        backgroundColor: _readyPlum,
                        foregroundColor: _readyPlumForeground,
                        shape: const StadiumBorder(),
                        textStyle: OmaTypography.body(
                          size: 15,
                          color: _readyPlumForeground,
                          weight: FontWeight.w600,
                        ),
                      ),
                      child: vm.isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(review.start),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _PreviewPrivacy(label: review.deviceEncryptionNote),
              ],
          ),
        ),
      ),
    );
  }
}

class _PreviewNote extends StatelessWidget {
  final String message;

  const _PreviewNote({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _readyPlumSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: _readyPlum,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: OmaTypography.body(size: 12, color: _readyPlum),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPrivacy extends StatelessWidget {
  final String label;

  const _PreviewPrivacy({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.favorite_border_rounded,
          color: AppColors.textSecondary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: OmaTypography.body(
              size: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.start,
                style: OmaTypography.body(
                  size: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: OmaTypography.body(size: 12, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
