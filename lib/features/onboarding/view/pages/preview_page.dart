import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/theme/oma_theme.dart';
import '../../../../core/widgets/oma_callout.dart';
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
                    color: context.omaTheme.surface.withValues(alpha: 0.86),
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
                name.isEmpty ? review.title : review.titleWithName(name: name),
                textAlign: TextAlign.center,
                style: OmaText.display(32, weight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Text(
                review.subtitle,
                textAlign: TextAlign.center,
                style: OmaText.body(
                  14,
                  color: context.omaTheme.muted,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 24),

              OmaCallout(
                icon: Icons.auto_awesome_rounded,
                child: Text(context.t.onboarding.prompt.review),
              ),

              const SizedBox(height: 24),

              ReviewSummaryRow(
                label: review.conditionsLabel,
                value: conditionSummary,
              ),

              const SizedBox(height: 8),

              ReviewSummaryRow(
                label: review.cycleLabel,
                value: review.dayCount(days: vm.averageCycleLength),
              ),

              const SizedBox(height: 8),

              ReviewSummaryRow(
                label: review.accountStorageLabel,
                value: accountStorageSummary,
              ),

              const SizedBox(height: 8),

              const SizedBox(height: 24),

              ReviewPrivacyNotice(label: review.deviceEncryptionNote),
            ],
          ),
        ),
      ),
    );
  }
}
