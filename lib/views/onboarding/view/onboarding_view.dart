import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/widgets/oma_background.dart';
import '../../../localization/generated/strings.g.dart';
import '../controller/onboarding_controller.dart';
import '../utils/onboarding_date_utils.dart';
import '../viewmodel/onboarding_view_model.dart';
import 'pages/index.dart';
import 'widgets/index.dart';

/// Onboarding akışını yöneten ana ekran.
///
/// Akış:
/// Introduction → Wellbeing → Health Profile → Cycle → Preview
///
/// Preview sonrasında footer'daki Finish butonu onboarding'i tamamlar.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;
  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _nameController = TextEditingController();
    _birthDateController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    final controller = OnboardingController(context: context, vm: vm);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.scaffoldBackground,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          _goBack();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: OmaBackground(
                key: ValueKey('onboarding_background_${vm.currentPage}'),
                seed: vm.currentPage,
                spotCount: 10,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    if (!vm.isPreviewPage) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: OnboardingHeader(
                          onBack: _goBack,
                          index: vm.currentPage,
                          total: vm.totalPages,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: OnboardingPrompt(
                          message: _promptForPage(context, vm.currentPage),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: vm.goToPage,
                        children: [
                          IntroductionPage(
                            vm: vm,
                            nameController: _nameController,
                            birthDateController: _birthDateController,
                            onPickBirthDate: () async {
                              await controller.pickBirthDate();

                              if (mounted && vm.birthDate != null) {
                                _birthDateController.text =
                                    OnboardingDateUtils.formatDate(
                                      vm.birthDate!,
                                    );
                              }
                            },
                            onBirthDateChanged: (value) {
                              vm.setBirthDate(
                                OnboardingDateUtils.parseBirthDate(value),
                              );
                            },
                          ),

                          WellbeingPage(vm: vm),

                          HealthProfilePage(
                            vm: vm,
                            heightController: _heightController,
                            weightController: _weightController,
                            onOpenDiseases: controller.showDiseasePicker,
                          ),

                          CyclePage(
                            vm: vm,
                            onPickLastPeriod: controller.pickLastPeriod,
                            onAddBirthControl: controller.addBirthControl,
                          ),

                          OnboardingPreviewPage(vm: vm),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: OnboardingFooter(
                        canContinue: vm.isPreviewPage
                            ? !vm.isSaving
                            : vm.canGoNext,
                        onContinue: _goNext,
                        onSkip: _goNext,
                        isFirst: vm.currentPage == 0,
                        isLast: vm.isPreviewPage,
                        isSkippable: !vm.isPreviewPage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  String _promptForPage(BuildContext context, int page) {
    final prompts = context.t.onboarding.prompt;

    switch (page) {
      case 0:
        return prompts.introduction;

      case 1:
        return prompts.wellbeing;

      case 2:
        return prompts.healthProfile;

      case 3:
        return prompts.cycle;

      default:
        return '';
    }
  }

  void _goBack() {
    FocusScope.of(context).unfocus();

    final vm = context.read<OnboardingViewModel>();

    // Preview → Cycle
    if (vm.isPreviewPage) {
      vm.previousPage();
      _animateToPage(vm.currentPage);
      return;
    }

    // İlk onboarding sayfasından Auth'a dön.
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

    // Normal onboarding sayfaları.
    if (!vm.isPreviewPage) {
      vm.nextPage();
      _animateToPage(vm.currentPage);
      return;
    }

    // Preview → Finish → Home
    if (vm.isSaving) return;

    final saved = await vm.saveAndComplete();

    if (saved && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
