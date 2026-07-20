import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../data/models/medication_reminder_model.dart';
import 'medication_reminder_section.dart';

/// Günlük kayıt BottomSheet — tüm modüllerin detaylı giriş ekranı.
class DailyLogSheet extends StatefulWidget {
  final DailyLog initialLog;
  final UserSettings settings;
  final Future<bool> Function(DailyLog) onSave;
  final int initialTabIndex;

  final bool isSingleTab;

  const DailyLogSheet({
    super.key,
    required this.initialLog,
    required this.settings,
    required this.onSave,
    this.initialTabIndex = 0,
    this.isSingleTab = false,
  });

  @override
  State<DailyLogSheet> createState() => _DailyLogSheetState();
}

class _DailyLogSheetState extends State<DailyLogSheet> {
  late DailyLog _log;
  final _notesController = TextEditingController();
  final _moodNoteController = TextEditingController();
  final _customMedController = TextEditingController();
  final _customSupController = TextEditingController();
  late int _selectedTabIndex;
  late Set<DailyLogObservedSection> _visitedSections;
  List<String> _previouslyAddedMeds = [];
  List<String> _previouslyAddedSups = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _log = widget.initialLog;
    _notesController.text = _log.notes ?? '';
    _moodNoteController.text = _log.moodNote ?? '';
    _selectedTabIndex = widget.initialTabIndex;
    _visitedSections = {
      ..._log.observedSections,
      _observedSectionForIndex(_selectedTabIndex),
    };
    _loadPreviouslyAddedItems();
  }

  void _loadPreviouslyAddedItems() {
    try {
      final storage = Provider.of<LocalStorageService>(context, listen: false);
      final allMeds = storage.getCustomMedications();
      final allSups = storage.getCustomSupplements();

      final medsSet = AppStrings.defaultMedications.toSet()..addAll(allMeds);
      final supsSet = AppStrings.defaultSupplements.toSet()..addAll(allSups);

      // Default daily settings list items should be excluded
      medsSet.removeAll(widget.settings.dailyMedications);
      supsSet.removeAll(widget.settings.dailySupplements);

      setState(() {
        _previouslyAddedMeds = medsSet.toList();
        _previouslyAddedSups = supsSet.toList();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _notesController.dispose();
    _moodNoteController.dispose();
    _customMedController.dispose();
    _customSupController.dispose();
    super.dispose();
  }

  List<String> get _tabTitles => [
    '🩸 ${AppStrings.period}',
    '🍽️ ${AppStrings.nutrition}',
    '💊 ${AppStrings.medications}',
    '🌟 ${AppStrings.mood}',
  ];

  bool _isSectionVisible(int categoryIndex) {
    final idx = _selectedTabIndex < _tabTitles.length ? _selectedTabIndex : 0;
    return idx == categoryIndex;
  }

  DailyLogObservedSection get _activeObservedSection {
    return _observedSectionForIndex(_selectedTabIndex);
  }

  DailyLogObservedSection _observedSectionForIndex(int index) {
    return switch (index) {
      0 => DailyLogObservedSection.period,
      1 => DailyLogObservedSection.nutrition,
      2 => DailyLogObservedSection.medication,
      _ => DailyLogObservedSection.wellbeing,
    };
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Tutamaç
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Başlık
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      AppStrings.dailyLog,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Yatay Kaydırılabilir Sekmeler (Tab Bar)
              if (!widget.isSingleTab) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  child: Row(
                    children: _tabTitles.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final title = entry.value;
                      final isSelected = _selectedTabIndex == idx;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = idx;
                            _visitedSections.add(_observedSectionForIndex(idx));
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textHint.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
              ],

              // İçerik
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // 0. Ruh Hali
                    if (_isSectionVisible(3))
                      _buildSection(
                        title: '🌟 ${AppStrings.mood}',
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: AppStrings.moodOptions.entries.map((entry) {
                            final isSelected =
                                AppStrings.localizeStoredValue(
                                  _log.mood ?? '',
                                ) ==
                                entry.key;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _log = _log.copyWith(
                                    mood: entry.key,
                                    moodEmoji: entry.value,
                                  );
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(
                                          alpha: 0.15,
                                        )
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      entry.value,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    // 1. Hareket Durumu
                    if (_isSectionVisible(3))
                      _buildSection(
                        title: '🏃 ${AppStrings.activityStatus}',
                        child: _buildChipSelector(
                          options: AppStrings.activityOptions,
                          selected: _log.activities,
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(activities: list),
                          ),
                          color: AppColors.secondary,
                        ),
                      ),

                    if (_isSectionVisible(3))
                      _buildSection(
                        title: '🌙 ${AppStrings.dailyFactors}',
                        subtitle: AppStrings.dailyFactorsHint,
                        child: Column(
                          children: [
                            _buildOptionalSliderMetric(
                              icon: Icons.bedtime_outlined,
                              title: AppStrings.sleepDuration,
                              value: _log.sleepDurationMinutes,
                              minimum: 30,
                              maximum: 960,
                              step: 30,
                              initialValue: 480,
                              color: AppColors.primary,
                              valueText: AppStrings.hoursMinutes,
                              onChanged: (value) => setState(() {
                                _log = value == null
                                    ? _log.copyWith(clearSleepDuration: true)
                                    : _log.copyWith(
                                        sleepDurationMinutes: value,
                                      );
                              }),
                            ),
                            const SizedBox(height: 10),
                            _buildOptionalSliderMetric(
                              icon: Icons.hotel_class_outlined,
                              title: AppStrings.sleepQuality,
                              value: _log.sleepQuality,
                              minimum: 1,
                              maximum: 5,
                              step: 1,
                              initialValue: 3,
                              color: AppColors.primary,
                              valueText: AppStrings.levelOutOfFive,
                              onChanged: (value) => setState(() {
                                _log = value == null
                                    ? _log.copyWith(clearSleepQuality: true)
                                    : _log.copyWith(sleepQuality: value);
                              }),
                            ),
                            const SizedBox(height: 10),
                            _buildOptionalSliderMetric(
                              icon: Icons.psychology_alt_outlined,
                              title: AppStrings.stressLevel,
                              value: _log.stressLevel,
                              minimum: 1,
                              maximum: 5,
                              step: 1,
                              initialValue: 3,
                              color: AppColors.accent,
                              valueText: AppStrings.levelOutOfFive,
                              onChanged: (value) => setState(() {
                                _log = value == null
                                    ? _log.copyWith(clearStressLevel: true)
                                    : _log.copyWith(stressLevel: value);
                              }),
                            ),
                            const SizedBox(height: 10),
                            _buildOptionalSliderMetric(
                              icon: Icons.bolt_outlined,
                              title: AppStrings.energyLevel,
                              value: _log.energyLevel,
                              minimum: 1,
                              maximum: 5,
                              step: 1,
                              initialValue: 3,
                              color: AppColors.warning,
                              valueText: AppStrings.levelOutOfFive,
                              onChanged: (value) => setState(() {
                                _log = value == null
                                    ? _log.copyWith(clearEnergyLevel: true)
                                    : _log.copyWith(energyLevel: value);
                              }),
                            ),
                          ],
                        ),
                      ),

                    // 2. Beslenme Durumu
                    if (_isSectionVisible(1))
                      _buildSection(
                        title: '🍽️ ${AppStrings.nutritionStatus}',
                        child: _buildChipSelector(
                          options: AppStrings.nutritionTags,
                          selected: _log.nutritionTags,
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(nutritionTags: list),
                          ),
                          color: AppColors.warning,
                        ),
                      ),

                    if (_isSectionVisible(1))
                      _buildSection(
                        title: '💧 ${AppStrings.dailyFactors}',
                        subtitle: AppStrings.dailyFactorsHint,
                        child: Column(
                          children: [
                            _buildOptionalCounterMetric(
                              icon: Icons.water_drop_outlined,
                              title: AppStrings.waterIntake,
                              value: _log.waterIntakeMl,
                              minimum: 0,
                              maximum: 6000,
                              step: 250,
                              initialValue: 0,
                              color: AppColors.info,
                              valueText: AppStrings.milliliters,
                              onChanged: (value) => setState(() {
                                _log = value == null
                                    ? _log.copyWith(clearWaterIntake: true)
                                    : _log.copyWith(waterIntakeMl: value);
                              }),
                            ),
                            const SizedBox(height: 10),
                            _buildOptionalCounterMetric(
                              icon: Icons.coffee_outlined,
                              title: AppStrings.caffeineIntake,
                              subtitle: AppStrings.caffeineServingHint,
                              value: _log.caffeineServings,
                              minimum: 0,
                              maximum: 12,
                              step: 1,
                              initialValue: 0,
                              color: AppColors.warning,
                              valueText: AppStrings.servingCount,
                              onChanged: (value) => setState(() {
                                _log = value == null
                                    ? _log.copyWith(clearCaffeineServings: true)
                                    : _log.copyWith(caffeineServings: value);
                              }),
                            ),
                          ],
                        ),
                      ),

                    // 3. Takviyeler
                    if (_isSectionVisible(2))
                      _buildSection(
                        title: '🌿 ${AppStrings.supplements}',
                        child: Column(
                          children: [
                            _buildMedicationList(
                              items: widget.settings.dailySupplements,
                              entries: _log.supplements,
                              color: AppColors.success,
                              customController: _customSupController,
                              customHint: AppStrings.supplementExample,
                              suggestions: _previouslyAddedSups,
                              onChanged: (entries) => setState(
                                () =>
                                    _log = _log.copyWith(supplements: entries),
                              ),
                            ),
                            MedicationReminderSection(
                              itemType: MedicationPlanItemType.supplement,
                              availableItems: {
                                ...widget.settings.dailySupplements,
                                ..._log.supplements.map((entry) => entry.name),
                                ..._previouslyAddedSups,
                              }.toList(),
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ),

                    // 4. İlaçlar
                    if (_isSectionVisible(2))
                      _buildSection(
                        title: '💊 ${AppStrings.medications}',
                        subtitle: AppStrings.medicationDisclaimer,
                        child: Column(
                          children: [
                            _buildMedicationList(
                              items: widget.settings.dailyMedications,
                              entries: _log.medications,
                              color: AppColors.medicationPrimary,
                              customController: _customMedController,
                              customHint: AppStrings.medicationExample,
                              suggestions: _previouslyAddedMeds,
                              onChanged: (entries) => setState(
                                () =>
                                    _log = _log.copyWith(medications: entries),
                              ),
                            ),
                            MedicationReminderSection(
                              itemType: MedicationPlanItemType.medication,
                              availableItems: {
                                ...widget.settings.dailyMedications,
                                ..._log.medications.map((entry) => entry.name),
                                ..._previouslyAddedMeds,
                              }.toList(),
                              color: AppColors.medicationPrimary,
                            ),
                          ],
                        ),
                      ),

                    // 5. Cinsel Aktivite
                    if (_isSectionVisible(3))
                      _buildSection(
                        title: '💕 ${AppStrings.sexualActivity}',
                        child: Row(
                          children: [
                            _toggleButton(
                              AppStrings.yes,
                              _log.sexualActivity == true,
                              () {
                                setState(
                                  () => _log = _log.copyWith(
                                    sexualActivity: true,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _toggleButton(
                              AppStrings.no,
                              _log.sexualActivity == false,
                              () {
                                setState(
                                  () => _log = _log.copyWith(
                                    sexualActivity: false,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                    // 6. Bağırsak Aktivitesi
                    if (_isSectionVisible(1))
                      _buildSection(
                        title: '🔄 ${AppStrings.bowelActivity}',
                        child: _buildChipSelector(
                          options: AppStrings.bowelActivityOptions,
                          selected: _log.bowelActivity,
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(bowelActivity: list),
                          ),
                          color: AppColors.info,
                        ),
                      ),

                    // 7. Hisler & Ağrılar
                    if (_isSectionVisible(3))
                      _buildSection(
                        title: '🩹 ${AppStrings.sensations}',
                        child: _buildChipSelector(
                          options: AppStrings.painLocations,
                          selected: _log.painLocations,
                          onChanged: (list) => setState(
                            () => _log = _log.copyWith(painLocations: list),
                          ),
                          color: AppColors.accent,
                        ),
                      ),

                    // 8. Regl
                    if (_isSectionVisible(0)) ...[
                      _buildSection(
                        title: AppStrings.periodBleeding,
                        child: _buildSingleChipSelector(
                          options: AppStrings.flowOptions,
                          selected: _log.flowIntensity,
                          onChanged: (val) => setState(
                            () => _log = _log.copyWith(flowIntensity: val),
                          ),
                          color: AppColors.periodPrimary,
                        ),
                      ),
                      _buildSection(
                        title: '💧 ${AppStrings.vaginalDischarge}',
                        subtitle: AppStrings.dischargeTrackingHint,
                        child: _buildVaginalDischargeInput(),
                      ),
                    ],

                    // 9. Notlar
                    if (_isSectionVisible(3))
                      _buildSection(
                        title: '📝 ${AppStrings.notes}',
                        child: TextField(
                          controller: _notesController,
                          maxLines: 3,
                          onChanged: (v) => _log = _log.copyWith(notes: v),
                          decoration: InputDecoration(
                            hintText: AppStrings.notesHint,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Kaydet butonu
                    CustomButton(
                      text: AppStrings.save,
                      icon: Icons.check_circle_outline,
                      isLoading: _isSaving,
                      onPressed: () async {
                        if (_isSaving) return;
                        final today = AppTime.now.dateOnly;
                        DateTime finalDate = _log.date;

                        if (_log.date.dateOnly.isBefore(today)) {
                          // Geçmiş bir gün için saat sor
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: _log.date.hour,
                              minute: _log.date.minute,
                            ),
                            helpText: AppStrings.selectLogTime,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    surface: AppColors.surface,
                                    onSurface: AppColors.textPrimary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime == null) {
                            // Kullanıcı iptal ettiyse kaydetme işlemini durdur
                            return;
                          }
                          finalDate = DateTime(
                            _log.date.year,
                            _log.date.month,
                            _log.date.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        }

                        setState(() => _isSaving = true);
                        var success = false;
                        try {
                          success = await widget.onSave(
                            _log.copyWith(
                              date: finalDate,
                              observedSections: {
                                ..._log.observedSections,
                                ..._visitedSections,
                                _activeObservedSection,
                              },
                            ),
                          );
                        } catch (_) {
                          success = false;
                        }
                        if (!mounted || !context.mounted) return;
                        setState(() => _isSaving = false);

                        if (success) {
                          final messenger = ScaffoldMessenger.of(context);
                          Navigator.pop(context);
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(AppStrings.saved),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppStrings.logSaveFailed),
                              backgroundColor: AppColors.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 32 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Yardımcı Widget'lar ───────────────────────────────

  Widget _buildSection({
    required String title,
    required Widget child,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ],
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildOptionalSliderMetric({
    required IconData icon,
    required String title,
    required int? value,
    required int minimum,
    required int maximum,
    required int step,
    required int initialValue,
    required Color color,
    required String Function(int) valueText,
    required ValueChanged<int?> onChanged,
  }) {
    if (value == null) {
      return _buildMetricAddRow(
        icon: icon,
        title: title,
        color: color,
        onAdd: () => onChanged(initialValue),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 6, 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                valueText(value),
                style: TextStyle(fontWeight: FontWeight.w700, color: color),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: AppStrings.delete,
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: minimum.toDouble(),
            max: maximum.toDouble(),
            divisions: (maximum - minimum) ~/ step,
            activeColor: color,
            label: valueText(value),
            onChanged: (next) {
              final stepped =
                  ((next - minimum) / step).round() * step + minimum;
              onChanged(stepped.clamp(minimum, maximum).toInt());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalCounterMetric({
    required IconData icon,
    required String title,
    String? subtitle,
    required int? value,
    required int minimum,
    required int maximum,
    required int step,
    required int initialValue,
    required Color color,
    required String Function(int) valueText,
    required ValueChanged<int?> onChanged,
  }) {
    if (value == null) {
      return _buildMetricAddRow(
        icon: icon,
        title: title,
        subtitle: subtitle,
        color: color,
        onAdd: () => onChanged(initialValue),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value <= minimum
                ? null
                : () =>
                      onChanged((value - step).clamp(minimum, maximum).toInt()),
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 72,
            child: Text(
              valueText(value),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: value >= maximum
                ? null
                : () =>
                      onChanged((value + step).clamp(minimum, maximum).toInt()),
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: AppStrings.delete,
            onPressed: () => onChanged(null),
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricAddRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color color,
    required VoidCallback onAdd,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: Text(AppStrings.add),
          ),
        ],
      ),
    );
  }

  Widget _buildVaginalDischargeInput() {
    final present = _log.vaginalDischargePresent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.dischargePresent,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (present != null)
              IconButton(
                tooltip: AppStrings.delete,
                onPressed: () => setState(() {
                  _log = _log.copyWith(
                    clearVaginalDischargePresent: true,
                    clearVaginalDischargeColor: true,
                    clearVaginalDischargeConsistency: true,
                    clearVaginalDischargeAmount: true,
                    vaginalDischargeSymptoms: const {},
                  );
                }),
                icon: const Icon(Icons.close, size: 18),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _toggleButton(
              AppStrings.yes,
              present == true,
              () => setState(
                () => _log = _log.copyWith(vaginalDischargePresent: true),
              ),
            ),
            const SizedBox(width: 8),
            _toggleButton(
              AppStrings.no,
              present == false,
              () => setState(() {
                _log = _log.copyWith(
                  vaginalDischargePresent: false,
                  clearVaginalDischargeColor: true,
                  clearVaginalDischargeConsistency: true,
                  clearVaginalDischargeAmount: true,
                  vaginalDischargeSymptoms: const {},
                );
              }),
            ),
          ],
        ),
        if (present == true) ...[
          const SizedBox(height: 18),
          Text(
            AppStrings.dischargeColor,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDischargeColorSelector(),
          const SizedBox(height: 18),
          Text(
            AppStrings.dischargeConsistency,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildSingleChipSelector(
            options: AppStrings.dischargeConsistencyOptions,
            selected: _log.vaginalDischargeConsistency == null
                ? null
                : AppStrings.dischargeConsistencyOptions[_log
                      .vaginalDischargeConsistency!
                      .index],
            onChanged: (value) => setState(() {
              _log = value == null
                  ? _log.copyWith(clearVaginalDischargeConsistency: true)
                  : _log.copyWith(
                      vaginalDischargeConsistency:
                          VaginalDischargeConsistency.values[AppStrings
                              .dischargeConsistencyOptions
                              .indexOf(value)],
                    );
            }),
            color: AppColors.primary,
          ),
          const SizedBox(height: 18),
          Text(
            AppStrings.dischargeAmount,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildSingleChipSelector(
            options: AppStrings.dischargeAmountOptions,
            selected: _log.vaginalDischargeAmount == null
                ? null
                : AppStrings.dischargeAmountOptions[_log
                      .vaginalDischargeAmount!
                      .index],
            onChanged: (value) => setState(() {
              _log = value == null
                  ? _log.copyWith(clearVaginalDischargeAmount: true)
                  : _log.copyWith(
                      vaginalDischargeAmount:
                          VaginalDischargeAmount.values[AppStrings
                              .dischargeAmountOptions
                              .indexOf(value)],
                    );
            }),
            color: AppColors.secondaryDark,
          ),
          const SizedBox(height: 18),
          Text(
            AppStrings.dischargeSymptoms,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildChipSelector(
            options: AppStrings.dischargeSymptomOptions,
            selected: _log.vaginalDischargeSymptoms
                .map(
                  (symptom) =>
                      AppStrings.dischargeSymptomOptions[symptom.index],
                )
                .toList(),
            onChanged: (values) => setState(() {
              _log = _log.copyWith(
                vaginalDischargeSymptoms: values
                    .map(
                      (value) =>
                          VaginalDischargeSymptom.values[AppStrings
                              .dischargeSymptomOptions
                              .indexOf(value)],
                    )
                    .toSet(),
              );
            }),
            color: AppColors.accent,
          ),
        ],
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            AppStrings.dischargeMedicalDisclaimer,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDischargeColorSelector() {
    const swatches = <Color>[
      Color(0xFFE7F7FC),
      Colors.white,
      Color(0xFFFFF2CC),
      Color(0xFFFFD54F),
      Color(0xFF66BB6A),
      Color(0xFF9E9E9E),
      Color(0xFF8D6E63),
      Color(0xFFF48FB1),
      Color(0xFFE57373),
      Color(0xFFB39DDB),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: VaginalDischargeColor.values.map((colorValue) {
        final isSelected = _log.vaginalDischargeColor == colorValue;
        final swatch = swatches[colorValue.index];
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => setState(() {
            _log = isSelected
                ? _log.copyWith(clearVaginalDischargeColor: true)
                : _log.copyWith(vaginalDischargeColor: colorValue);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.09)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: swatch,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.textHint),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  AppStrings.dischargeColorOptions[colorValue.index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
    required Color color,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected.any(
          (value) => AppStrings.localizeStoredValue(value) == opt,
        );
        return GestureDetector(
          onTap: () {
            final newList = List<String>.from(selected);
            if (isSelected) {
              newList.removeWhere(
                (value) => AppStrings.localizeStoredValue(value) == opt,
              );
            } else {
              newList.add(opt);
            }
            onChanged(newList);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.12)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleChipSelector({
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onChanged,
    required Color color,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected =
            AppStrings.localizeStoredValue(selected ?? '') == opt;
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              onChanged(null);
            } else {
              onChanged(opt);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicationList({
    required List<String> items,
    required List<MedicationEntry> entries,
    required Color color,
    required TextEditingController customController,
    required String customHint,
    required List<String> suggestions,
    required ValueChanged<List<MedicationEntry>> onChanged,
  }) {
    // 1. Ayarlardan gelenleri topla
    final allEntries = <MedicationEntry>[];
    for (var name in items) {
      final existing = entries.firstWhere(
        (e) => e.name == name,
        orElse: () => MedicationEntry(
          name: name,
          time: AppStrings.medicationTimes.first,
          stomachState: AppStrings.stomachStates.first,
        ),
      );
      allEntries.add(existing);
    }

    // 2. Sadece bu günlük için eklenenleri ekle
    for (var e in entries) {
      if (!items.contains(e.name)) {
        allEntries.add(e);
      }
    }

    // 3. Önceden eklenenlerden bugün eklenmemiş olanları bul
    final suggestedItems = suggestions
        .where((s) => !allEntries.any((e) => e.name == s))
        .toList();

    return Column(
      children: [
        ...allEntries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: entry.taken
                    ? color.withValues(alpha: 0.08)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () {
                      final newEntries = allEntries.map((e) {
                        if (e.name == entry.name) {
                          return e.copyWith(taken: !e.taken);
                        }
                        return e;
                      }).toList();
                      onChanged(newEntries);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: entry.taken ? color : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: entry.taken ? color : AppColors.textHint,
                          width: 1.5,
                        ),
                      ),
                      child: entry.taken
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

                  // Zaman seçici
                  _miniDropdown(
                    value: AppStrings.localizeStoredValue(entry.time),
                    items: AppStrings.medicationTimes,
                    onChanged: (val) {
                      final newEntries = allEntries.map((e) {
                        if (e.name == entry.name) return e.copyWith(time: val);
                        return e;
                      }).toList();
                      onChanged(newEntries);
                    },
                  ),
                  const SizedBox(width: 4),

                  // Aç/Tok
                  _miniDropdown(
                    value: AppStrings.localizeStoredValue(entry.stomachState),
                    items: AppStrings.stomachStates,
                    onChanged: (val) {
                      final newEntries = allEntries.map((e) {
                        if (e.name == entry.name) {
                          return e.copyWith(stomachState: val);
                        }
                        return e;
                      }).toList();
                      onChanged(newEntries);
                    },
                  ),
                  const SizedBox(width: 4),

                  // Miktar seçici
                  Builder(
                    builder: (ctx) {
                      final dosageItems = List<String>.from(
                        AppStrings.dosageOptions,
                      );
                      final localizedDosage = AppStrings.localizeStoredValue(
                        entry.dosage,
                      );
                      if (!dosageItems.contains(localizedDosage)) {
                        dosageItems.add(localizedDosage);
                      }
                      dosageItems.add(AppStrings.custom);

                      return _miniDropdown(
                        value: localizedDosage,
                        items: dosageItems,
                        onChanged: (val) {
                          if (val == AppStrings.custom) {
                            _showCustomDosageDialog(
                              context,
                              entry,
                              allEntries,
                              onChanged,
                            );
                          } else {
                            final newEntries = allEntries.map((e) {
                              if (e.name == entry.name) {
                                return e.copyWith(dosage: val);
                              }
                              return e;
                            }).toList();
                            onChanged(newEntries);
                          }
                        },
                      );
                    },
                  ),

                  // Özel Eklenenler İçin Silme Butonu
                  if (!items.contains(entry.name))
                    GestureDetector(
                      onTap: () {
                        final newEntries = allEntries
                            .where((e) => e.name != entry.name)
                            .toList();
                        onChanged(newEntries);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        if (suggestedItems.isNotEmpty) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.previouslyAdded,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: suggestedItems.map((name) {
                return GestureDetector(
                  onTap: () {
                    final newEntries = List<MedicationEntry>.from(allEntries);
                    newEntries.add(
                      MedicationEntry(
                        name: name,
                        time: AppStrings.medicationTimes.first,
                        stomachState: AppStrings.stomachStates.first,
                        taken: true,
                      ),
                    );
                    onChanged(newEntries);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 12, color: color),
                        const SizedBox(width: 2),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: customController,
                decoration: InputDecoration(
                  hintText: customHint,
                  hintStyle: const TextStyle(fontSize: 13),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.textHint.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final txt = customController.text.trim();
                if (txt.isNotEmpty) {
                  final newEntries = List<MedicationEntry>.from(allEntries);
                  if (!newEntries.any((e) => e.name == txt)) {
                    newEntries.add(
                      MedicationEntry(
                        name: txt,
                        time: AppStrings.medicationTimes.first,
                        stomachState: AppStrings.stomachStates.first,
                        taken: true,
                      ),
                    );
                    onChanged(newEntries);
                  }
                  customController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              child: Text(AppStrings.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _miniDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 11)),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        underline: const SizedBox(),
        isDense: true,
        style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _toggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  void _showCustomDosageDialog(
    BuildContext context,
    MedicationEntry entry,
    List<MedicationEntry> allEntries,
    ValueChanged<List<MedicationEntry>> onChanged,
  ) {
    final textCtrl = TextEditingController(text: entry.dosage);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          AppStrings.customDosage,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: textCtrl,
          decoration: InputDecoration(
            hintText: AppStrings.customDosageHint,
            isDense: true,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final val = textCtrl.text.trim();
              if (val.isNotEmpty) {
                final newEntries = allEntries.map((e) {
                  if (e.name == entry.name) return e.copyWith(dosage: val);
                  return e;
                }).toList();
                onChanged(newEntries);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(AppStrings.save),
          ),
        ],
      ),
    );
  }
}
