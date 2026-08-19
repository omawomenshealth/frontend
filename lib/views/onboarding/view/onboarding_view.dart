import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../core/shared_widgets/lab_results_form.dart';
import '../../../core/utils/cycle_rules.dart';
import '../../../data/models/lab_result_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../viewmodel/onboarding_view_model.dart';

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
            child: _SoftOrb(color: AppColors.accent, size: 190),
          ),
          const Positioned(
            top: 172,
            left: -72,
            child: _SoftOrb(color: AppColors.primary, size: 150),
          ),
          const Positioned(
            bottom: 104,
            right: -58,
            child: _SoftOrb(color: AppColors.secondary, size: 142),
          ),
          const Positioned(
            bottom: -62,
            left: 38,
            child: _SoftOrb(color: AppColors.lutealDark, size: 126),
          ),
          SafeArea(
            child: Column(
              children: [
                _ProgressHeader(
                  currentPage: vm.currentPage,
                  totalPages: vm.totalPages,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: vm.goToPage,
                    children: [
                      _MeetYouPage(
                        vm: vm,
                        birthDateController: _birthDateController,
                        onPickBirthDate: () => _pickBirthDate(vm),
                        onBirthDateChanged: (value) =>
                            _readBirthDate(value, vm),
                      ),
                      _BasicHealthPage(vm: vm),
                      _DetailedHealthPage(
                        vm: vm,
                        step: _detailStep,
                        forward: _detailForward,
                        onOpenLabs: () => _showLabPicker(vm),
                        onOpenDiseases: () => _showDiseasePicker(vm),
                        onPickLastPeriod: () => _pickLastPeriod(vm),
                        onAddBirthControl: () => _addBirthControl(vm),
                      ),
                    ],
                  ),
                ),
                _BottomNavigation(
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
    var results = Map<String, LabResult>.from(vm.labResults);
    var testDate = vm.labTestDate;
    var fasting = vm.labTestFasting;
    final save = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _SelectionSheet(
        title: AppStrings.bloodResults,
        icon: Icons.science_outlined,
        accent: AppColors.secondary,
        onSave: () => Navigator.pop(sheetContext, true),
        child: LabResultsForm(
          initialResults: results,
          initialTestDate: testDate,
          initialFasting: fasting,
          accent: AppColors.secondary,
          onResultsChanged: (value) => results = value,
          onTestDateChanged: (value) => testDate = value,
          onFastingChanged: (value) => fasting = value,
        ),
      ),
    );
    if (save != true || !mounted) return;
    vm.setLabResults(results);
    vm.setLabTestDate(testDate);
    vm.setLabTestFasting(fasting);
    setState(() {});
  }

  Future<void> _showDiseasePicker(OnboardingViewModel vm) async {
    final catalog = _uniqueReusableLabels([
      ...AppStrings.chronicDiseasesList,
      ...AppStrings.womenDiseasesList,
      ...vm.customConditions,
    ]);
    var query = '';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final normalizedQuery = query.trim().toLowerCase();
          final visible = {
            ...catalog.where(
              (item) => item.toLowerCase().contains(normalizedQuery),
            ),
            ...vm.knownDiseases.where(
              (item) => item.toLowerCase().contains(normalizedQuery),
            ),
          }.toList(growable: false);
          return _SelectionSheet(
            title: AppStrings.conditions,
            icon: Icons.health_and_safety_outlined,
            accent: AppColors.accent,
            onSave: () => Navigator.pop(sheetContext),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  key: const ValueKey('onboarding_disease_search'),
                  onChanged: (value) => setSheetState(() => query = value),
                  decoration: InputDecoration(
                    hintText: AppStrings.searchConditions,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final disease in visible)
                      FilterChip(
                        label: Text(disease),
                        selected: vm.knownDiseases.any(
                          (value) =>
                              AppStrings.localizeStoredValue(
                                value,
                              ).toLowerCase() ==
                              disease.toLowerCase(),
                        ),
                        selectedColor: AppColors.accent.withValues(alpha: 0.14),
                        onSelected: (_) {
                          vm.toggleKnownDisease(disease);
                          setSheetState(() {});
                        },
                      ),
                    ActionChip(
                      key: const ValueKey('onboarding_add_known_disease'),
                      avatar: const Icon(Icons.add_rounded, size: 17),
                      label: Text(AppStrings.add),
                      onPressed: () async {
                        final value = await _promptText(
                          sheetContext,
                          AppStrings.addCondition,
                        );
                        if (value == null || value.isEmpty) return;
                        vm.addKnownDisease(value);
                        setSheetState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _pickLastPeriod(OnboardingViewModel vm) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: vm.lastPeriodDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      helpText: AppStrings.lastPeriodDate,
    );
    if (selected != null) vm.setLastPeriodDate(selected);
  }

  Future<void> _addBirthControl(OnboardingViewModel vm) async {
    final value = await _promptText(context, AppStrings.addBirthControlMethod);
    if (value != null && value.isNotEmpty) vm.addBirthControlMethod(value);
  }

  Future<String?> _promptText(BuildContext context, String title) {
    var value = '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          maxLength: 80,
          onChanged: (text) => value = text,
          onSubmitted: (text) => Navigator.pop(dialogContext, text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, value.trim()),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _ProgressHeader({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 6),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                ),
              ),
              const Spacer(),
              Text(
                '${currentPage + 1} / $totalPages',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(totalPages, (index) {
              final colors = [
                AppColors.accent,
                AppColors.primary,
                AppColors.secondary,
              ];
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: index <= currentPage
                        ? colors[index % colors.length]
                        : AppColors.outline,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MeetYouPage extends StatelessWidget {
  final OnboardingViewModel vm;
  final TextEditingController birthDateController;
  final VoidCallback onPickBirthDate;
  final ValueChanged<String> onBirthDateChanged;

  const _MeetYouPage({
    required this.vm,
    required this.birthDateController,
    required this.onPickBirthDate,
    required this.onBirthDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _OnboardingCard(
      title: AppStrings.meetYouTitle,
      subtitle: AppStrings.meetYouSubtitle,
      accent: AppColors.accent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FieldLabel(AppStrings.name),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 310),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: TextField(
                key: const ValueKey('onboarding_name'),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
                onChanged: vm.setUserName,
                decoration: InputDecoration(
                  hintText: AppStrings.nameAddressHint,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          _FieldLabel(AppStrings.age),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 310),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: TextField(
                key: const ValueKey('onboarding_birth_date'),
                controller: birthDateController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                  LengthLimitingTextInputFormatter(10),
                  const _DateSlashFormatter(),
                ],
                onChanged: onBirthDateChanged,
                decoration: InputDecoration(
                  hintText: AppStrings.birthDateInputHint,
                  prefixIcon: const Icon(Icons.cake_outlined),
                  suffixIcon: IconButton(
                    key: const ValueKey('onboarding_birth_date_picker'),
                    tooltip: AppStrings.chooseFromCalendar,
                    onPressed: onPickBirthDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: vm.age == null
                ? Text(
                    AppStrings.birthDateManualEntryHint,
                    key: const ValueKey('age_help'),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  )
                : Text(
                    AppStrings.ageYears(vm.age!),
                    key: const ValueKey('age_value'),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BasicHealthPage extends StatelessWidget {
  final OnboardingViewModel vm;

  const _BasicHealthPage({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _OnboardingCard(
      title: AppStrings.basicHealthInformationTitle,
      subtitle: AppStrings.basicHealthInformationSubtitle,
      accent: AppColors.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel(AppStrings.smokingUsage),
          const SizedBox(height: 7),
          _YesNoSelector(value: vm.isSmoker, onChanged: vm.setIsSmoker),
          const SizedBox(height: 16),
          _FieldLabel(AppStrings.relationshipStatus),
          const SizedBox(height: 7),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final status in AppStrings.relationshipStatusOptions)
                ChoiceChip(
                  label: Text(status),
                  selected:
                      AppStrings.localizeStoredValue(vm.relationshipStatus) ==
                      status,
                  selectedColor: AppColors.primary.withValues(alpha: 0.14),
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) => vm.setRelationshipStatus(status),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('onboarding_height'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) => vm.setHeight(double.tryParse(value)),
                  decoration: InputDecoration(
                    labelText: AppStrings.height,
                    suffixText: AppStrings.centimeterUnit,
                    prefixIcon: const Icon(Icons.height_rounded, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: TextField(
                  key: const ValueKey('onboarding_weight'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) => vm.setWeight(double.tryParse(value)),
                  decoration: InputDecoration(
                    labelText: AppStrings.weight,
                    suffixText: AppStrings.kilogramUnit,
                    prefixIcon: const Icon(
                      Icons.monitor_weight_outlined,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailedHealthPage extends StatelessWidget {
  final OnboardingViewModel vm;
  final int step;
  final bool forward;
  final VoidCallback onOpenLabs;
  final VoidCallback onOpenDiseases;
  final VoidCallback onPickLastPeriod;
  final VoidCallback onAddBirthControl;

  const _DetailedHealthPage({
    required this.vm,
    required this.step,
    required this.forward,
    required this.onOpenLabs,
    required this.onOpenDiseases,
    required this.onPickLastPeriod,
    required this.onAddBirthControl,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      _LabStep(vm: vm, onOpen: onOpenLabs),
      _DiseaseStep(vm: vm, onOpen: onOpenDiseases),
      _CycleStep(vm: vm, onPickLastPeriod: onPickLastPeriod),
      _ReproductiveStep(vm: vm, onAddBirthControl: onAddBirthControl),
    ];
    return _OnboardingCard(
      title: AppStrings.detailedHealthInformationTitle,
      subtitle: AppStrings.detailedHealthInformationSubtitle,
      accent: AppColors.secondary,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _OnboardingViewState._detailStepCount,
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

class _LabStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onOpen;

  const _LabStep({required this.vm, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return _CompactPrompt(
      icon: Icons.science_outlined,
      accent: AppColors.secondary,
      title: AppStrings.bloodResults,
      description: AppStrings.bloodResultsDescription,
      summary: vm.labResults.isEmpty
          ? AppStrings.noBloodResultsAdded
          : AppStrings.bloodResultsAdded(vm.labResults.length),
      buttonLabel: AppStrings.searchBloodTests,
      onPressed: onOpen,
    );
  }
}

class _DiseaseStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onOpen;

  const _DiseaseStep({required this.vm, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return _CompactPrompt(
      icon: Icons.health_and_safety_outlined,
      accent: AppColors.accent,
      title: AppStrings.knownConditionQuestion,
      description: AppStrings.combinedConditionsDescription,
      summary: vm.knownDiseases.isEmpty
          ? AppStrings.noConditionSelected
          : vm.knownDiseases.map(AppStrings.localizeStoredValue).join(', '),
      buttonLabel: AppStrings.searchConditions,
      onPressed: onOpen,
    );
  }
}

class _CycleStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onPickLastPeriod;

  const _CycleStep({required this.vm, required this.onPickLastPeriod});

  @override
  Widget build(BuildContext context) {
    final lastPeriod = vm.lastPeriodDate;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(AppStrings.cycleInformation),
        Material(
          color: Colors.transparent,
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(AppStrings.doNotKnowCycleLength),
            subtitle: Text(AppStrings.calculateCycleOverTime),
            value: vm.isCycleLengthUnknown,
            activeThumbColor: AppColors.accent,
            onChanged: vm.setIsCycleLengthUnknown,
          ),
        ),
        if (!vm.isCycleLengthUnknown) ...[
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: vm.averageCycleLength.toDouble(),
                  min: CycleRules.minCycleLength.toDouble(),
                  max: CycleRules.maxCycleLength.toDouble(),
                  divisions:
                      CycleRules.maxCycleLength - CycleRules.minCycleLength,
                  activeColor: AppColors.accent,
                  onChanged: (value) => vm.setAverageCycleLength(value.round()),
                ),
              ),
              Text(
                AppStrings.dayCount(vm.averageCycleLength),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onPickLastPeriod,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              lastPeriod == null
                  ? AppStrings.lastPeriodDate
                  : '${lastPeriod.day.toString().padLeft(2, '0')}/'
                        '${lastPeriod.month.toString().padLeft(2, '0')}/'
                        '${lastPeriod.year}',
            ),
          ),
        ),
      ],
    );
  }
}

class _ReproductiveStep extends StatelessWidget {
  final OnboardingViewModel vm;
  final VoidCallback onAddBirthControl;

  const _ReproductiveStep({required this.vm, required this.onAddBirthControl});

  @override
  Widget build(BuildContext context) {
    final menopauseOptions = <(String, MenopauseStatus)>[
      (AppStrings.none, MenopauseStatus.none),
      (AppStrings.preMenopause, MenopauseStatus.pre),
      (AppStrings.periMenopause, MenopauseStatus.peri),
      (AppStrings.postMenopause, MenopauseStatus.post),
    ];
    final birthControlOptions = _uniqueReusableLabels([
      AppStrings.noBirthControl,
      AppStrings.pill,
      AppStrings.iud,
      AppStrings.condom,
      AppStrings.implant,
      ...vm.customBirthControlMethods,
    ]);
    final selectedMethod = AppStrings.localizeStoredValue(
      vm.birthControlMethod ?? '',
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(AppStrings.menopauseStatus),
        const SizedBox(height: 7),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final option in menopauseOptions)
              ChoiceChip(
                label: Text(option.$1),
                selected: vm.menopauseStatus == option.$2,
                selectedColor: AppColors.secondary.withValues(alpha: 0.14),
                visualDensity: VisualDensity.compact,
                onSelected: (_) => vm.setMenopauseStatus(option.$2),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _FieldLabel(AppStrings.birthControl),
        const SizedBox(height: 7),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final method in birthControlOptions)
              ChoiceChip(
                label: Text(method),
                selected: selectedMethod == method,
                selectedColor: AppColors.accent.withValues(alpha: 0.14),
                visualDensity: VisualDensity.compact,
                onSelected: (_) => vm.setBirthControlMethod(method),
              ),
            ActionChip(
              key: const ValueKey('onboarding_add_birth_control'),
              avatar: const Icon(
                Icons.add_rounded,
                size: 17,
                color: AppColors.accent,
              ),
              label: Text(AppStrings.add),
              visualDensity: VisualDensity.compact,
              side: BorderSide(color: AppColors.accent.withValues(alpha: 0.42)),
              onPressed: onAddBirthControl,
            ),
          ],
        ),
      ],
    );
  }
}

List<String> _uniqueReusableLabels(Iterable<String> values) {
  final result = <String>[];
  final seen = <String>{};
  for (final raw in values) {
    final value = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.isEmpty) continue;
    final normalized = value.replaceAll(RegExp('[İIı]'), 'i').toLowerCase();
    if (seen.add(normalized)) result.add(value);
  }
  return result;
}

class _CompactPrompt extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String description;
  final String summary;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _CompactPrompt({
    required this.icon,
    required this.accent,
    required this.title,
    required this.description,
    required this.summary,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accent, size: 30),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            color: AppColors.textPrimary,
            fontSize: 21,
            height: 1.08,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11.5,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 13),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(backgroundColor: accent),
            icon: const Icon(Icons.search_rounded, size: 18),
            label: Text(buttonLabel),
          ),
        ),
      ],
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;
  final Widget child;
  final Widget? footer;

  const _OnboardingCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.88)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                color: AppColors.textPrimary,
                fontSize: 27,
                height: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: 480,
                    child: child,
                  ),
                ),
              ),
            ),
            if (footer != null) ...[const SizedBox(height: 8), footer!],
          ],
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final OnboardingViewModel vm;
  final int detailStep;
  final int detailStepCount;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _BottomNavigation({
    required this.vm,
    required this.detailStep,
    required this.detailStepCount,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = vm.currentPage > 0 || detailStep > 0;
    final isLast =
        vm.currentPage == vm.totalPages - 1 &&
        detailStep == detailStepCount - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Row(
        children: [
          if (canGoBack)
            Expanded(
              child: CustomButton(
                text: AppStrings.back,
                isOutlined: true,
                onPressed: onBack,
              ),
            ),
          if (canGoBack) const SizedBox(width: 10),
          Expanded(
            flex: canGoBack ? 2 : 1,
            child: CustomButton(
              text: isLast ? AppStrings.finish : AppStrings.next,
              isLoading: vm.isSaving,
              onPressed: onNext,
              gradient: isLast
                  ? const LinearGradient(
                      colors: [AppColors.secondary, AppColors.accent],
                    )
                  : AppColors.primaryGradient,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;
  final VoidCallback onSave;

  const _SelectionSheet({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: accent, size: 20),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('onboarding_selection_close'),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                children: [child],
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSave,
                  style: FilledButton.styleFrom(backgroundColor: accent),
                  child: Text(AppStrings.save),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _YesNoSelector extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _YesNoSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: Center(child: Text(AppStrings.yes)),
            selected: value,
            selectedColor: AppColors.primary.withValues(alpha: 0.14),
            onSelected: (_) => onChanged(true),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: ChoiceChip(
            label: Center(child: Text(AppStrings.no)),
            selected: !value,
            selectedColor: AppColors.primary.withValues(alpha: 0.14),
            onSelected: (_) => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _SoftOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _SoftOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.075),
          border: Border.all(color: color.withValues(alpha: 0.08), width: 12),
        ),
      ),
    );
  }
}

class _DateSlashFormatter extends TextInputFormatter {
  const _DateSlashFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length && index < 8; index++) {
      if (index == 2 || index == 4) buffer.write('/');
      buffer.write(digits[index]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
