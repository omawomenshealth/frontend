import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/oma_theme.dart';
import '../../../../core/widgets/oma_callout.dart';
import '../../../../core/widgets/oma_logo.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class PreviewPage extends StatelessWidget {
  final OnboardingViewModel vm;

  const PreviewPage({super.key, required this.vm});

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
        padding: const EdgeInsets.symmetric(
          horizontal: OmaSpacing.xl,
          vertical: OmaSpacing.xxxl,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: OmaLogo(size: OmaLogoSize.compact)),

              const SizedBox(height: OmaSpacing.xxl),

              Text(
                name.isEmpty ? review.title : review.titleWithName(name: name),
                textAlign: TextAlign.center,
                style: OmaText.display(32, weight: FontWeight.w600),
              ),

              const SizedBox(height: OmaSpacing.md),

              Text(
                review.subtitle,
                textAlign: TextAlign.center,
                style: OmaText.body(
                  14,
                  color: context.omaTheme.muted,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: OmaSpacing.xxl),

              OmaCallout(
                icon: Icons.auto_awesome_rounded,
                child: Text(context.t.onboarding.prompt.review),
              ),

              const SizedBox(height: OmaSpacing.xxl),

              ReviewSummaryRow(
                label: review.conditionsLabel,
                value: conditionSummary,
              ),

              const SizedBox(height: OmaSpacing.sm),

              ReviewSummaryRow(
                label: review.cycleLabel,
                value: review.dayCount(days: vm.averageCycleLength),
              ),

              const SizedBox(height: OmaSpacing.sm),

              ReviewSummaryRow(
                label: review.accountStorageLabel,
                value: accountStorageSummary,
              ),

              const SizedBox(height: OmaSpacing.xxxl),

              ReviewPrivacyNotice(label: review.deviceEncryptionNote),
            ],
          ),
        ),
      ),
    );
  }
}
