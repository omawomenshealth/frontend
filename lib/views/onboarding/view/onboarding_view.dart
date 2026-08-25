import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/cycle_rules.dart';
import '../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';
import 'pages/index.dart';
import 'sheets/index.dart';

/// Üç ana ekrandan oluşan, dikey kaydırma gerektirmeyen ilk kurulum akışı.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  final _birthDateController = TextEditingController();
  var _detailStep = 0;
  var _detailForward = true;

  static const _detailStepCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final vm = context.watch<OnboardingViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          const Positioned(
            top: -74,
            right: -58,
            child: OnboardingSoftOrb(color: AppColors.accent, size: 190),
          ),
          const Positioned(
            top: 172,
            left: -72,
            child: OnboardingSoftOrb(color: AppColors.primary, size: 150),
          ),
          const Positioned(
            bottom: 104,
            right: -58,
            child: OnboardingSoftOrb(color: AppColors.secondary, size: 142),
          ),
          const Positioned(
            bottom: -62,
            left: 38,
            child: OnboardingSoftOrb(color: AppColors.lutealDark, size: 126),
          ),
          SafeArea(
            child: Column(
              children: [
                OnboardingProgressHeader(
                  currentPage: vm.currentPage,
                  totalPages: vm.totalPages,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: vm.goToPage,
                    children: [
                      MeetYouPage(
                        vm: vm,
                        birthDateController: _birthDateController,
                        onPickBirthDate: () => _pickBirthDate(vm),
                        onBirthDateChanged: (value) =>
                            _readBirthDate(value, vm),
                      ),
                      BasicHealthPage(vm: vm),
                      DetailedHealthPage(
                        vm: vm,
                        step: _detailStep,
                        forward: _detailForward,
                        onOpenLabs: () => _showLabPicker(vm),
                        onOpenDiseases: () => _showDiseasePicker(vm),
                        onPickLastPeriod: () => _pickLastPeriod(vm),
                        onAddBirthControl: () => _addBirthControl(vm),
                        detailStepCount: _detailStepCount,
                      ),
                    ],
                  ),
                ),
                OnboardingBottomNavigation(
                  vm: vm,
                  detailStep: _detailStep,
                  detailStepCount: _detailStepCount,
                  onBack: () => _goBack(vm),
                  onNext: () => _goNext(vm),
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

  void _goBack(OnboardingViewModel vm) {
    FocusScope.of(context).unfocus();
    if (vm.currentPage == 2 && _detailStep > 0) {
      setState(() {
        _detailForward = false;
        _detailStep--;
      });
      return;
    }
    if (!vm.canGoBack) return;
    vm.previousPage();
    _animateToPage(vm.currentPage);
  }

  Future<void> _goNext(OnboardingViewModel vm) async {
    FocusScope.of(context).unfocus();
    if (vm.currentPage < 2) {
      vm.nextPage();
      _animateToPage(vm.currentPage);
      return;
    }
    if (_detailStep < _detailStepCount - 1) {
      setState(() {
        _detailForward = true;
        _detailStep++;
      });
      return;
    }
    final saved = await vm.saveAndComplete();
    if (saved && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _pickBirthDate(OnboardingViewModel vm) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: vm.birthDate ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      helpText: AppStrings.selectBirthDate,
    );
    if (selected == null || !mounted) return;
    vm.setBirthDate(selected);
    _birthDateController.text = _formatDate(selected);
  }

  void _readBirthDate(String value, OnboardingViewModel vm) {
    if (value.length != 10) {
      vm.setBirthDate(null);
      return;
    }
    final parts = value.split('/');
    if (parts.length != 3) return;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return;
    final candidate = DateTime(year, month, day);
    if (candidate.year != year ||
        candidate.month != month ||
        candidate.day != day ||
        candidate.isAfter(DateTime.now())) {
      vm.setBirthDate(null);
      return;
    }
    vm.setBirthDate(candidate);
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  Future<void> _showLabPicker(OnboardingViewModel vm) async {
    final data = await showLabResultsSheet(context, vm);
    if (data == null || !mounted) return;
    vm.setLabResults(data.results);
    vm.setLabTestDate(data.testDate);
    vm.setLabTestFasting(data.fasting);
    setState(() {});
  }

  Future<void> _showDiseasePicker(OnboardingViewModel vm) async {
    await showDiseaseSelectionSheet(context, vm);
    if (mounted) setState(() {});
  }

  Future<void> _pickLastPeriod(OnboardingViewModel vm) async {
    final now = DateTime.now();
    final selectedDays = vm.lastPeriodDays;
    final initialStart = selectedDays.isEmpty ? now : selectedDays.first;
    final initialEnd = selectedDays.isEmpty ? now : selectedDays.last;
    final selected = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      helpText: AppStrings.lastPeriodDaysQuestion,
      saveText: AppStrings.save,
    );
    if (selected == null || !mounted) return;
    final dayCount = selected.duration.inDays + 1;
    if (dayCount > CycleRules.maxPeriodLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.periodDaySelectionLimit(CycleRules.maxPeriodLength),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    vm.setLastPeriodDays(
      List.generate(
        dayCount,
        (index) => selected.start.add(Duration(days: index)),
      ),
    );
  }

  Future<void> _addBirthControl(OnboardingViewModel vm) async {
    final value = await showOnboardingTextInputDialog(
      context,
      AppStrings.addBirthControlMethod,
    );
    if (value != null && value.isNotEmpty) vm.addBirthControlMethod(value);
  }
}