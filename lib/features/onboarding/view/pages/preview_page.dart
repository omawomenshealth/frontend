import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/oma_theme.dart';
import '../../../../core/widgets/oma_callout.dart';
import '../../../../core/widgets/oma_logo.dart';
import '../../../../core/widgets/rise_in.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({
    super.key,
    required this.vm,
    this.isActive = true,
  });

  final OnboardingViewModel vm;
  final bool isActive;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage>
    with SingleTickerProviderStateMixin, RiseAnimationMixin {
  @override
  void initState() {
    super.initState();

    if (!widget.isActive) {
      riseController.stop();
      riseController.value = 0;
    }
  }

  @override
  void didUpdateWidget(covariant PreviewPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      riseController.forward(from: 0);
    } else if (oldWidget.isActive && !widget.isActive) {
      riseController.stop();
      riseController.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = context.t.onboarding.preview;
    final vm = widget.vm;
    final name = vm.userName.trim();

    final conditionSummary = vm.knownDiseases.isEmpty
        ? preview.summary.conditions.empty
        : vm.knownDiseases
            .map(AppStrings.localizeStoredValue)
            .join(', ');

    final accountStorageSummary = vm.isUserLoggedIn
        ? preview.summary.storage.google
        : preview.summary.storage.guest;

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
              RiseIn(
                animation: riseAt(0),
                child: Column(
                  children: [
                    const OmaLogo(
                      size: OmaLogoSize.standard,
                    ),
                    const SizedBox(height: OmaSpacing.xxl),
                    Text(
                      name.isEmpty
                          ? preview.hero.title
                          : preview.hero.titleWithName(name: name),
                      textAlign: TextAlign.center,
                      style: OmaText.display(
                        OmaTypeScale.display,
                        weight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: OmaSpacing.md),
                    Text(
                      preview.hero.subtitle,
                      textAlign: TextAlign.center,
                      style: OmaText.body(
                        14,
                        color: context.omaTheme.muted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: OmaSpacing.xxl),

              RiseIn(
                animation: riseAt(0.14),
                child: OmaCallout(
                  icon: Icons.auto_awesome_rounded,
                  child: Text(preview.callout.message),
                ),
              ),

              const SizedBox(height: OmaSpacing.xxl),

              RiseIn(
                animation: riseAt(0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReviewSummaryRow(
                      label: preview.summary.conditions.label,
                      value: conditionSummary,
                    ),
                    const SizedBox(height: OmaSpacing.sm),
                    ReviewSummaryRow(
                      label: preview.summary.cycle.label,
                      value: preview.summary.cycle.dayCount(
                        days: vm.averageCycleLength,
                      ),
                    ),
                    const SizedBox(height: OmaSpacing.sm),
                    ReviewSummaryRow(
                      label: preview.summary.storage.label,
                      value: accountStorageSummary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: OmaSpacing.xxxl),

              RiseIn(
                animation: riseAt(0.42),
                child: ReviewPrivacyNotice(
                  label: preview.privacy.deviceEncryptionNote,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
