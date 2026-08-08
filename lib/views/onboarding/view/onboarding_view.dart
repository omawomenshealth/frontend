import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/cycle_rules.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../core/shared_widgets/condition_selector.dart';
import '../../../core/shared_widgets/oma_design_widgets.dart';
import '../../../core/shared_widgets/lab_results_form.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../viewmodel/onboarding_view_model.dart';

/// Onboarding ekranı — adım adım kullanıcı bilgisi toplama.
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final vm = context.read<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            // İlerleme çubuğu — sadece currentPage değiştiğinde rebuild olur
            Selector<OnboardingViewModel, int>(
              selector: (_, vm) => vm.currentPage,
              builder: (context, currentPage, _) {
                return _buildProgressBar(currentPage, vm.totalPages);
              },
            ),
            const SizedBox(height: 8),

            // Sayfa içeriği — PageView içindeki sayfalar kendi state'lerini yönetir
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => vm.goToPage(i),
                children: [
                  _WelcomePage(vm: vm),
                  _BasicInfoPage(vm: vm),
                  _CycleHealthPage(vm: vm),
                  _SummaryPage(vm: vm),
                ],
              ),
            ),

            // Alt butonlar — sayfa ve saving durumu değiştiğinde rebuild olur
            Selector<OnboardingViewModel, ({int page, bool saving})>(
              selector: (_, vm) => (page: vm.currentPage, saving: vm.isSaving),
              builder: (context, state, _) {
                return _buildBottomButtons(vm, state.page, state.saving);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── İlerleme Çubuğu ──────────────────────────────────
  Widget _buildProgressBar(int currentPage, int totalPages) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'OMA',
                style: TextStyle(
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(totalPages, (i) {
              final isActive = i <= currentPage;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.outline,
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

  // ── Alt Butonlar ──────────────────────────────────────
  Widget _buildBottomButtons(
    OnboardingViewModel vm,
    int currentPage,
    bool isSaving,
  ) {
    final canGoBack = currentPage > 0;
    final isLastPage = currentPage == vm.totalPages - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        children: [
          if (canGoBack)
            Expanded(
              child: CustomButton(
                text: AppStrings.back,
                isOutlined: true,
                onPressed: () {
                  vm.previousPage();
                  _animateToPage(vm.currentPage);
                },
              ),
            ),
          if (canGoBack) const SizedBox(width: 12),
          Expanded(
            flex: canGoBack ? 2 : 1,
            child: isLastPage
                ? CustomButton(
                    text: AppStrings.finish,
                    isLoading: isSaving,
                    onPressed: () async {
                      final success = await vm.saveAndComplete();
                      if (success && mounted) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    },
                  )
                : CustomButton(
                    text: AppStrings.next,
                    onPressed: () {
                      vm.nextPage();
                      _animateToPage(vm.currentPage);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Sayfa 1: Karşılama/İsim — kendi state'ini yönetir, rebuild yok
// ══════════════════════════════════════════════════════════════
class _WelcomePage extends StatelessWidget {
  final OnboardingViewModel vm;
  const _WelcomePage({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _PageWrapper(
      title: AppStrings.letsStart,
      subtitle: AppStrings.tellAboutYourself,
      children: [
        const SizedBox(height: 16),
        TextField(
          onChanged: vm.setUserName,
          decoration: InputDecoration(
            hintText: AppStrings.yourName,
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Sayfa 2: Temel Bilgiler — Consumer sadece gerekli alanları izler
// ══════════════════════════════════════════════════════════════
class _BasicInfoPage extends StatelessWidget {
  final OnboardingViewModel vm;
  const _BasicInfoPage({required this.vm});

  @override
  Widget build(BuildContext context) {
    // Sadece UI durumu değişen alanları izle (isSmoker, relationshipStatus, vb.)
    return Selector<
      OnboardingViewModel,
      ({
        bool isSmoker,
        String relationshipStatus,
        bool? wantsChildren,
        List<String> chronicDiseases,
      })
    >(
      selector: (_, vm) => (
        isSmoker: vm.isSmoker,
        relationshipStatus: vm.relationshipStatus,
        wantsChildren: vm.wantsChildrenInYear,
        chronicDiseases: vm.chronicDiseases,
      ),
      builder: (context, state, _) {
        return _PageWrapper(
          title: AppStrings.basicInformation,
          subtitle: AppStrings.createHealthProfile,
          scrollable: true,
          children: [
            // Kilo, Boy, Yaş — TextField'lar kendi state'lerini yönetir
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setWeight(double.tryParse(v)),
                    decoration: InputDecoration(
                      hintText: AppStrings.weight,
                      prefixIcon: const Icon(
                        Icons.monitor_weight_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setHeight(double.tryParse(v)),
                    decoration: InputDecoration(
                      hintText: AppStrings.height,
                      prefixIcon: const Icon(Icons.height_rounded, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setAge(int.tryParse(v)),
                    decoration: InputDecoration(hintText: AppStrings.age),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sigara
            _sectionTitle(AppStrings.smokingStatus),
            _YesNoSelector(value: state.isSmoker, onChanged: vm.setIsSmoker),
            if (state.isSmoker) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '${AppStrings.smokingYears}: ',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (v) =>
                          vm.setSmokingYears(int.tryParse(v) ?? 0),
                      decoration: InputDecoration(hintText: AppStrings.year),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),

            // İlişki durumu
            _sectionTitle(AppStrings.relationshipStatus),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppStrings.relationshipStatusOptions.map((opt) {
                final isSelected =
                    AppStrings.localizeStoredValue(state.relationshipStatus) ==
                    opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  onSelected: (_) => vm.setRelationshipStatus(opt),
                  selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Çocuk düşünüyor mu
            _sectionTitle(AppStrings.wantsChildrenInYear),
            _YesNoSelector(
              value: state.wantsChildren ?? false,
              onChanged: (v) => vm.setWantsChildrenInYear(v),
            ),
            const SizedBox(height: 24),

            // Yapılandırılmış laboratuvar değerleri
            _sectionTitle(
              AppStrings.isTurkish
                  ? 'Laboratuvar değerleri'
                  : 'Laboratory results',
            ),
            LabResultsForm(
              key: const ValueKey('onboarding_lab_results_form'),
              initialResults: vm.labResults,
              initialTestDate: vm.labTestDate,
              initialFasting: vm.labTestFasting,
              onResultsChanged: vm.setLabResults,
              onTestDateChanged: vm.setLabTestDate,
              onFastingChanged: vm.setLabTestFasting,
            ),
            const SizedBox(height: 24),

            // Kronik hastalıklar
            _sectionTitle(AppStrings.chronicDiseases),
            ConditionSelector(
              catalogItems: AppStrings.chronicDiseasesList,
              selectedItems: state.chronicDiseases,
              color: AppColors.accent,
              addDialogTitle: AppStrings.addCustomChronicDisease,
              addButtonKey: 'onboarding_add_chronic_disease',
              onToggle: vm.toggleChronicDisease,
              onAdd: vm.addChronicDisease,
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Sayfa 3: Döngü ve kadın sağlığı bilgileri
// ══════════════════════════════════════════════════════════════
class _CycleHealthPage extends StatelessWidget {
  final OnboardingViewModel vm;
  const _CycleHealthPage({required this.vm});

  @override
  Widget build(BuildContext context) {
    return _PageWrapper(
      title: AppStrings.womenHealth,
      subtitle: AppStrings.cycleAndHealthInformation,
      scrollable: true,
      children: [
        // ── Bölüm 1: Döngü süresi (Switch + Slider) ──────
        _CycleLengthSection(vm: vm),
        const SizedBox(height: 16),

        // ── Bölüm 2: Son adet tarihi ─────────────────────
        _LastPeriodSection(vm: vm),
        const SizedBox(height: 24),

        // ── Bölüm 3: Menopoz durumu ──────────────────────
        _MenopauseSection(vm: vm),
        const SizedBox(height: 24),

        // ── Bölüm 4: Doğum kontrol ──────────────────────
        _BirthControlSection(vm: vm),
        const SizedBox(height: 24),

        // ── Bölüm 5: Kadın hastalıkları ─────────────────
        _WomenDiseasesSection(vm: vm),
        const SizedBox(height: 32),
      ],
    );
  }
}

/// Döngü süresi — sadece isCycleLengthUnknown ve cycleLength izler
class _CycleLengthSection extends StatelessWidget {
  final OnboardingViewModel vm;
  const _CycleLengthSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Selector<OnboardingViewModel, ({bool unknown, int length})>(
      selector: (_, vm) =>
          (unknown: vm.isCycleLengthUnknown, length: vm.averageCycleLength),
      builder: (context, state, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(AppStrings.menstrualCycleLength),
            SwitchListTile(
              title: Text(
                AppStrings.doNotKnowCycleLength,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                AppStrings.calculateCycleOverTime,
                style: const TextStyle(fontSize: 12),
              ),
              contentPadding: EdgeInsets.zero,
              value: state.unknown,
              activeTrackColor: AppColors.periodPrimary.withValues(alpha: 0.5),
              activeThumbColor: AppColors.periodPrimary,
              onChanged: vm.setIsCycleLengthUnknown,
            ),
            if (!state.unknown) ...[
              Text(
                AppStrings.menstrualCycleHint,
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: state.length.toDouble(),
                      min: CycleRules.minCycleLength.toDouble(),
                      max: CycleRules.maxCycleLength.toDouble(),
                      divisions:
                          CycleRules.maxCycleLength - CycleRules.minCycleLength,
                      label: AppStrings.dayCount(state.length),
                      onChanged: (v) => vm.setAverageCycleLength(v.round()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.periodPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppStrings.dayCount(state.length),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.periodPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Son adet tarihi — sadece lastPeriodDate izler
class _LastPeriodSection extends StatelessWidget {
  final OnboardingViewModel vm;
  const _LastPeriodSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Selector<OnboardingViewModel, DateTime?>(
      selector: (_, vm) => vm.lastPeriodDate,
      builder: (context, lastPeriodDate, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(AppStrings.lastPeriodDate),
            GestureDetector(
              onTap: () async {
                final now = AppTime.now;
                final picked = await showDatePicker(
                  context: context,
                  initialDate: lastPeriodDate ?? now,
                  firstDate: now.subtract(const Duration(days: 90)),
                  lastDate: now,
                  locale: AppStrings.resolveLocale(
                    Localizations.localeOf(context),
                  ),
                );
                if (picked != null) vm.setLastPeriodDate(picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      lastPeriodDate != null
                          ? lastPeriodDate.toDotFormat()
                          : AppStrings.selectDate,
                      style: TextStyle(
                        color: lastPeriodDate != null
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Menopoz durumu — sadece menopauseStatus izler
class _MenopauseSection extends StatelessWidget {
  final OnboardingViewModel vm;
  const _MenopauseSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Selector<OnboardingViewModel, MenopauseStatus>(
      selector: (_, vm) => vm.menopauseStatus,
      builder: (context, currentStatus, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(AppStrings.menopauseStatus),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                  AppStrings.noMenopause,
                  MenopauseStatus.none,
                  currentStatus,
                ),
                _chip(
                  AppStrings.preMenopause,
                  MenopauseStatus.pre,
                  currentStatus,
                ),
                _chip(
                  AppStrings.periMenopause,
                  MenopauseStatus.peri,
                  currentStatus,
                ),
                _chip(
                  AppStrings.postMenopause,
                  MenopauseStatus.post,
                  currentStatus,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _chip(String label, MenopauseStatus status, MenopauseStatus current) {
    final isSelected = current == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => vm.setMenopauseStatus(status),
      selectedColor: AppColors.periodPrimary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        fontSize: 13,
        color: isSelected ? AppColors.periodPrimary : AppColors.textPrimary,
      ),
    );
  }
}

/// Doğum kontrol — sadece birthControlMethod izler
class _BirthControlSection extends StatelessWidget {
  final OnboardingViewModel vm;
  const _BirthControlSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Selector<OnboardingViewModel, String?>(
      selector: (_, vm) => vm.birthControlMethod,
      builder: (context, selected, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(AppStrings.birthControl),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                    AppStrings.noBirthControl,
                    AppStrings.pill,
                    AppStrings.iud,
                    AppStrings.condom,
                    AppStrings.implant,
                    AppStrings.otherMethod,
                  ].map((method) {
                    final isSelected =
                        AppStrings.localizeStoredValue(selected ?? '') ==
                        method;
                    return ChoiceChip(
                      label: Text(method),
                      selected: isSelected,
                      onSelected: (_) => vm.setBirthControlMethod(method),
                      selectedColor: AppColors.periodLight.withValues(
                        alpha: 0.2,
                      ),
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
}

/// Kadın hastalıkları — sadece womenDiseases listesini izler
class _WomenDiseasesSection extends StatelessWidget {
  final OnboardingViewModel vm;
  const _WomenDiseasesSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Selector<OnboardingViewModel, List<String>>(
      selector: (_, vm) => vm.womenDiseases,
      builder: (context, diseases, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(AppStrings.womenDiseases),
            ConditionSelector(
              catalogItems: AppStrings.womenDiseasesList,
              selectedItems: diseases,
              color: AppColors.periodPrimary,
              addDialogTitle: AppStrings.addCustomWomenDisease,
              addButtonKey: 'onboarding_add_women_disease',
              onToggle: vm.toggleWomenDisease,
              onAdd: vm.addWomenDisease,
            ),
          ],
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Sayfa 4: Özet — ViewModel'den güncel verileri okur
// ══════════════════════════════════════════════════════════════
class _SummaryPage extends StatelessWidget {
  final OnboardingViewModel vm;
  const _SummaryPage({required this.vm});

  @override
  Widget build(BuildContext context) {
    // Summary sayfası tüm veriyi gösterir, ama sadece sayfa görünür olduğunda build olur
    return _PageWrapper(
      title: AppStrings.great,
      subtitle: AppStrings.profileReady,
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _summaryRow(
                AppStrings.name,
                vm.userName.isEmpty ? '-' : vm.userName,
              ),
              if (vm.weight != null)
                _summaryRow(AppStrings.weight, '${vm.weight} kg'),
              if (vm.height != null)
                _summaryRow(AppStrings.height, '${vm.height} cm'),
              if (vm.age != null) _summaryRow(AppStrings.age, '${vm.age}'),
              _summaryRow(
                AppStrings.smoking,
                vm.isSmoker
                    ? '${AppStrings.yes} (${AppStrings.yearsSmoking(vm.smokingYears)})'
                    : AppStrings.no,
              ),
              if (vm.lastPeriodDate != null)
                _summaryRow(
                  AppStrings.menstrualCycleLength,
                  AppStrings.dayCount(vm.averageCycleLength),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Yardımcı Widget'lar — top-level private, her sayfada kullanılır
// ══════════════════════════════════════════════════════════════

class _PageWrapper extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool scrollable;

  const _PageWrapper({
    required this.title,
    required this.subtitle,
    required this.children,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        ...children,
      ],
    );

    final card = OmaSoftCard(
      padding: const EdgeInsets.all(24),
      color: AppColors.surface,
      child: content,
    );

    if (scrollable) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: card,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Align(alignment: Alignment.topCenter, child: card),
    );
  }
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
  );
}

class _YesNoSelector extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _YesNoSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ChoiceButton(
          label: AppStrings.yes,
          isSelected: value,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 12),
        _ChoiceButton(
          label: AppStrings.no,
          isSelected: !value,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
