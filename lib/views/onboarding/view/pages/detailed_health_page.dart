import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';
import 'detailed_health_steps.dart';

class DetailedHealthPage extends StatelessWidget {
  final OnboardingViewModel vm;
  final int step;
  final bool forward;
  final VoidCallback onOpenLabs;

  const DetailedHealthPage({
    super.key,
    required this.vm,
    required this.step,
    required this.forward,
    required this.onOpenLabs,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      LabStep(
        resultCount: vm.labResults.length,
        onOpen: onOpenLabs,
      ),
    ];
    return OnboardingCard(
      title: AppStrings.detailedHealthInformationTitle,
      subtitle: AppStrings.detailedHealthInformationSubtitle,
      accent: AppColors.secondary,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          OnboardingViewModel.detailStepCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: index == step ? 22 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: index == step
                  ? AppColors.secondary
                  : AppColors.secondary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        transitionBuilder: (child, animation) {
          final begin = Offset(forward ? 0.16 : -0.16, 0);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(begin: begin, end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(key: ValueKey(step), child: children[step]),
      ),
    );
  }
}