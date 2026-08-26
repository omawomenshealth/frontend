import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_constants.dart';
import '../controller/onboarding_controller.dart';
import '../utils/onboarding_date_utils.dart';
import 'pages/health_profile_page.dart';
import 'widgets/index.dart';
import '../viewmodel/onboarding_view_model.dart';
import 'pages/index.dart';

/// Üç ana ekrandan oluşan, dikey kaydırma gerektirmeyen ilk kurulum akışı.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;
  late final TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _birthDateController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();
    final controller = OnboardingController(context: context, vm: vm);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          const OnboardingBackground(),
          SafeArea(
            child: Column(
              children: [
                OnboardingProgressHeader(
                  currentPage: vm.currentPage,
                  totalPages: vm.totalPages,
                  onBack: _goBack,
                  canGoBack: !vm.isSaving,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: vm.goToPage,
                    children: [
                      IntroductionPage(
                        vm: vm,
                        birthDateController: _birthDateController,
                        onPickBirthDate: () async {
                          await controller.pickBirthDate();
                          if (mounted && vm.birthDate != null) {
                            _birthDateController.text =
                                OnboardingDateUtils.formatDate(vm.birthDate!);
                          }
                        },
                        onBirthDateChanged: (value) {
                          vm.setBirthDate(
                            OnboardingDateUtils.parseBirthDate(value),
                          );
                        },
                      ),
                      WellbeingPage(),
                      HealthProfilePage(vm: vm),
                      CyclePage(
                        vm: vm,
                        onPickLastPeriod: controller.pickLastPeriod,
                        onAddBirthControl: controller.addBirthControl,
                      ),
                      DetailedHealthPage(
                        vm: vm,
                        step: vm.detailStep,
                        forward: vm.detailForward,
                        onOpenLabs: controller.showLabPicker,
                        onOpenDiseases: controller.showDiseasePicker,
                      ),
                    ],
                  ),
                ),
                OnboardingBottomNavigation(
                  vm: vm,
                  onNext: _goNext,
                  onSkip: _goNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goBack() {
    FocusScope.of(context).unfocus();
    final vm = context.read<OnboardingViewModel>();
    if (vm.isDetailedHealthPage && !vm.isFirstDetailStep) {
      vm.previousDetailStep();
      return;
    }
    if (!vm.canGoBack) {
      Navigator.of(context).pushReplacementNamed('/auth');
      return;
    }
    vm.previousPage();
    _animateToPage(vm.currentPage);
  }

  Future<void> _goNext() async {
    FocusScope.of(context).unfocus();
    final vm = context.read<OnboardingViewModel>();
    if (!vm.isDetailedHealthPage) {
      vm.nextPage();
      _animateToPage(vm.currentPage);
      return;
    }
    if (!vm.isLastDetailStep) {
      vm.nextDetailStep();
      return;
    }
    final saved = await vm.saveAndComplete();
    if (saved && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

}