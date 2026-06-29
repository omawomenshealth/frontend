import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../data/models/user_settings_model.dart';
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
    return Consumer<OnboardingViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // İlerleme çubuğu
                _buildProgressBar(vm),
                const SizedBox(height: 8),

                // Sayfa içeriği
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => vm.goToPage(i),
                    children: [
                      _buildGenderPage(vm),
                      _buildBasicInfoPage(vm),
                      _buildGenderSpecificPage(vm),
                      _buildSummaryPage(vm),
                    ],
                  ),
                ),

                // Alt butonlar
                _buildBottomButtons(vm),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── İlerleme Çubuğu ──────────────────────────────────
  Widget _buildProgressBar(OnboardingViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: List.generate(vm.totalPages, (i) {
          final isActive = i <= vm.currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Sayfa 1: Cinsiyet Seçimi ──────────────────────────
  Widget _buildGenderPage(OnboardingViewModel vm) {
    return _pageWrapper(
      title: AppStrings.letsStart,
      subtitle: AppStrings.tellAboutYourself,
      children: [
        const SizedBox(height: 16),

        // İsim girişi
        TextField(
          onChanged: vm.setUserName,
          decoration: const InputDecoration(
            hintText: 'Adınız',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 32),

        // Cinsiyet seçimi
        const Text(
          AppStrings.selectGender,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _genderCard(
                icon: Icons.female_rounded,
                label: AppStrings.female,
                color: AppColors.female,
                isSelected: vm.gender == Gender.female,
                onTap: () => vm.setGender(Gender.female),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _genderCard(
                icon: Icons.male_rounded,
                label: AppStrings.male,
                color: AppColors.male,
                isSelected: vm.gender == Gender.male,
                onTap: () => vm.setGender(Gender.male),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _genderCard({
    required IconData icon,
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.background,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12)]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: isSelected ? color : AppColors.textHint),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sayfa 2: Temel Bilgiler ───────────────────────────
  Widget _buildBasicInfoPage(OnboardingViewModel vm) {
    return _pageWrapper(
      title: 'Temel Bilgiler',
      subtitle: 'Sağlık profilinizi oluşturalım',
      scrollable: true,
      children: [
        // Kilo, Boy, Yaş
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => vm.setWeight(double.tryParse(v)),
                decoration: const InputDecoration(
                  hintText: AppStrings.weight,
                  prefixIcon: Icon(Icons.monitor_weight_outlined, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => vm.setHeight(double.tryParse(v)),
                decoration: const InputDecoration(
                  hintText: AppStrings.height,
                  prefixIcon: Icon(Icons.height_rounded, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (v) => vm.setAge(int.tryParse(v)),
                decoration: const InputDecoration(hintText: AppStrings.age),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Sigara
        _sectionTitle(AppStrings.smokingStatus),
        _yesNoSelector(
          value: vm.isSmoker,
          onChanged: vm.setIsSmoker,
        ),
        if (vm.isSmoker) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Kaç yıldır: ', style: TextStyle(color: AppColors.textSecondary)),
              SizedBox(
                width: 80,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (v) => vm.setSmokingYears(int.tryParse(v) ?? 0),
                  decoration: const InputDecoration(hintText: 'Yıl'),
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
            final isSelected = vm.relationshipStatus == opt;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (_) => vm.setRelationshipStatus(opt),
              selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Çocuk düşünüyor mu
        _sectionTitle(AppStrings.wantsChildrenInYear),
        _yesNoSelector(
          value: vm.wantsChildrenInYear ?? false,
          onChanged: (v) => vm.setWantsChildrenInYear(v),
        ),
        const SizedBox(height: 24),

        // Kan değerleri
        _sectionTitle(AppStrings.bloodTestResults),
        TextField(
          onChanged: vm.setBloodTestResults,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: AppStrings.bloodTestHint,
          ),
        ),
        const SizedBox(height: 24),

        // Kronik hastalıklar
        _sectionTitle(AppStrings.chronicDiseases),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppStrings.chronicDiseasesList.map((disease) {
            final isSelected = vm.chronicDiseases.contains(disease);
            return FilterChip(
              label: Text(disease),
              selected: isSelected,
              onSelected: (_) => vm.toggleChronicDisease(disease),
              selectedColor: AppColors.accent.withValues(alpha: 0.15),
              checkmarkColor: AppColors.accent,
              labelStyle: TextStyle(
                fontSize: 13,
                color: isSelected ? AppColors.accent : AppColors.textPrimary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ── Sayfa 3: Cinsiyete Özel Bilgiler ──────────────────
  Widget _buildGenderSpecificPage(OnboardingViewModel vm) {
    if (vm.gender == Gender.female) {
      return _buildFemaleSpecificPage(vm);
    } else {
      return _buildMaleSpecificPage(vm);
    }
  }

  Widget _buildFemaleSpecificPage(OnboardingViewModel vm) {
    return _pageWrapper(
      title: 'Kadın Sağlığı',
      subtitle: 'Döngü ve sağlık bilgileriniz',
      scrollable: true,
      children: [
        // Regl döngüsü süresi
        _sectionTitle(AppStrings.menstrualCycleLength),
        SwitchListTile(
          title: const Text(
            'Döngü süremi bilmiyorum',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: const Text(
            'Uygulama zamanla hesaplasın',
            style: TextStyle(fontSize: 12),
          ),
          contentPadding: EdgeInsets.zero,
          value: vm.isCycleLengthUnknown,
          activeTrackColor: AppColors.periodPrimary.withValues(alpha: 0.5),
          activeThumbColor: AppColors.periodPrimary,
          onChanged: vm.setIsCycleLengthUnknown,
        ),
        if (!vm.isCycleLengthUnknown) ...[
          Text(
            AppStrings.menstrualCycleHint,
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: vm.averageCycleLength.toDouble(),
                  min: 20,
                  max: 45,
                  divisions: 25,
                  label: '${vm.averageCycleLength} gün',
                  onChanged: (v) => vm.setAverageCycleLength(v.round()),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.periodPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${vm.averageCycleLength} gün',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.periodPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),

        // Son adet tarihi
        _sectionTitle(AppStrings.lastPeriodDate),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: vm.lastPeriodDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 90)),
              lastDate: DateTime.now(),
              locale: const Locale('tr', 'TR'),
            );
            if (picked != null) vm.setLastPeriodDate(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Text(
                  vm.lastPeriodDate != null
                      ? '${vm.lastPeriodDate!.day}.${vm.lastPeriodDate!.month}.${vm.lastPeriodDate!.year}'
                      : 'Tarih seçin',
                  style: TextStyle(
                    color: vm.lastPeriodDate != null
                        ? AppColors.textPrimary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Menopoz durumu
        _sectionTitle(AppStrings.menopauseStatus),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _menopauseChip(AppStrings.noMenopause, MenopauseStatus.none, vm),
            _menopauseChip(AppStrings.preMenopause, MenopauseStatus.pre, vm),
            _menopauseChip(AppStrings.periMenopause, MenopauseStatus.peri, vm),
            _menopauseChip(AppStrings.postMenopause, MenopauseStatus.post, vm),
          ],
        ),
        const SizedBox(height: 24),

        // Doğum kontrol
        _sectionTitle(AppStrings.birthControl),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppStrings.noBirthControl,
            AppStrings.pill,
            AppStrings.iud,
            AppStrings.condom,
            AppStrings.implant,
            AppStrings.otherMethod,
          ].map((method) {
            final isSelected = vm.birthControlMethod == method;
            return ChoiceChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (_) => vm.setBirthControlMethod(method),
              selectedColor: AppColors.periodLight.withValues(alpha: 0.2),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Kadın hastalıkları
        _sectionTitle(AppStrings.womenDiseases),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppStrings.womenDiseasesList.map((disease) {
            final isSelected = vm.womenDiseases.contains(disease);
            return FilterChip(
              label: Text(disease),
              selected: isSelected,
              onSelected: (_) => vm.toggleWomenDisease(disease),
              selectedColor: AppColors.periodPrimary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.periodPrimary,
              labelStyle: TextStyle(
                fontSize: 13,
                color: isSelected ? AppColors.periodPrimary : AppColors.textPrimary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMaleSpecificPage(OnboardingViewModel vm) {
    return _pageWrapper(
      title: 'Erkek Sağlığı',
      subtitle: 'Sağlık bilgileriniz',
      scrollable: true,
      children: [
        // Andropoz durumu
        _sectionTitle(AppStrings.andropauseStatus),
        _yesNoSelector(
          value: vm.andropauseStatus ?? false,
          onChanged: (v) => vm.setAndropauseStatus(v),
        ),
        const SizedBox(height: 24),

        // Erkek hastalıkları
        _sectionTitle(AppStrings.menDiseases),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppStrings.menDiseasesList.map((disease) {
            final isSelected = vm.menDiseases.contains(disease);
            return FilterChip(
              label: Text(disease),
              selected: isSelected,
              onSelected: (_) => vm.toggleMenDisease(disease),
              selectedColor: AppColors.male.withValues(alpha: 0.15),
              checkmarkColor: AppColors.male,
              labelStyle: TextStyle(
                fontSize: 13,
                color: isSelected ? AppColors.male : AppColors.textPrimary,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ── Sayfa 4: Özet ─────────────────────────────────────
  Widget _buildSummaryPage(OnboardingViewModel vm) {
    return _pageWrapper(
      title: 'Harika! 🎉',
      subtitle: 'Profiliniz hazır. Başlayalım mı?',
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
              _summaryRow('İsim', vm.userName.isEmpty ? '-' : vm.userName),
              _summaryRow('Cinsiyet', vm.gender == Gender.female ? '👩 Kadın' : '👨 Erkek'),
              if (vm.weight != null) _summaryRow('Kilo', '${vm.weight} kg'),
              if (vm.height != null) _summaryRow('Boy', '${vm.height} cm'),
              if (vm.age != null) _summaryRow('Yaş', '${vm.age}'),
              _summaryRow('Sigara', vm.isSmoker ? 'Evet (${vm.smokingYears} yıl)' : 'Hayır'),
              if (vm.gender == Gender.female && vm.lastPeriodDate != null)
                _summaryRow('Döngü', '${vm.averageCycleLength} gün'),
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
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
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

  // ── Alt Butonlar ──────────────────────────────────────
  Widget _buildBottomButtons(OnboardingViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Row(
        children: [
          if (vm.canGoBack)
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
          if (vm.canGoBack) const SizedBox(width: 12),
          Expanded(
            flex: vm.canGoBack ? 2 : 1,
            child: vm.currentPage == vm.totalPages - 1
                ? CustomButton(
                    text: AppStrings.finish,
                    isLoading: vm.isSaving,
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

  // ── Yardımcı Widget'lar ───────────────────────────────

  Widget _pageWrapper({
    required String title,
    required String subtitle,
    required List<Widget> children,
    bool scrollable = false,
  }) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ...children,
      ],
    );

    if (scrollable) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: content,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: content,
    );
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

  Widget _yesNoSelector({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        _choiceButton(AppStrings.yes, value, () => onChanged(true)),
        const SizedBox(width: 12),
        _choiceButton(AppStrings.no, !value, () => onChanged(false)),
      ],
    );
  }

  Widget _choiceButton(String label, bool isSelected, VoidCallback onTap) {
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

  Widget _menopauseChip(String label, MenopauseStatus status, OnboardingViewModel vm) {
    final isSelected = vm.menopauseStatus == status;
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
