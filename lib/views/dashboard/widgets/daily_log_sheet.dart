import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../data/models/medication_reminder_model.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import 'medication_reminder_section.dart';

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
  late int _selectedTabIndex;
  late Set<DailyLogObservedSection> _visitedSections;

  final _notesController = TextEditingController();
  final _moodNoteController = TextEditingController();
  final _nutritionNotesController = TextEditingController();
  final _customMedController = TextEditingController();
  final _customSupController = TextEditingController();

  List<String> _previouslyAddedMeds = [];
  List<String> _previouslyAddedSups = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _log = widget.initialLog;
    _selectedTabIndex = widget.initialTabIndex.clamp(0, 3);
    _visitedSections = {
      ..._log.observedSections,
      _observedSectionForIndex(_selectedTabIndex),
    };
    _notesController.text = _log.notes ?? '';
    _moodNoteController.text = _log.moodNote ?? '';
    _nutritionNotesController.text = _log.nutritionNotes ?? '';
    _loadPreviouslyAddedItems();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _moodNoteController.dispose();
    _nutritionNotesController.dispose();
    _customMedController.dispose();
    _customSupController.dispose();
    super.dispose();
  }

  List<_LogTabItem> get _tabs => [
    _LogTabItem(
      label: AppStrings.period,
      icon: Icons.water_drop_outlined,
      color: AppColors.periodPrimary,
    ),
    _LogTabItem(
      label: AppStrings.nutrition,
      icon: Icons.local_dining_outlined,
      color: AppColors.primary,
    ),
    _LogTabItem(
      label: AppStrings.medications,
      icon: Icons.medication_outlined,
      color: AppColors.medicationPrimary,
    ),
    _LogTabItem(
      label: AppStrings.mood,
      icon: Icons.sentiment_satisfied_alt_outlined,
      color: AppColors.secondary,
    ),
  ];

  Color get _activeColor => _tabs[_selectedTabIndex].color;

  String get _pageTitle => switch (_selectedTabIndex) {
    0 => AppStrings.logPeriodQuestion,
    1 => AppStrings.logNutritionQuestion,
    2 => AppStrings.logMedicationQuestion,
    _ => AppStrings.logMoodQuestion,
  };

  String get _pageSubtitle => switch (_selectedTabIndex) {
    0 => AppStrings.logPeriodHint,
    1 => AppStrings.logNutritionHint,
    2 => AppStrings.logMedicationHint,
    _ => AppStrings.logMoodHint,
  };

  String get _saveLabel => switch (_selectedTabIndex) {
    0 => AppStrings.savePeriod,
    1 => AppStrings.saveNutrition,
    2 => AppStrings.saveMedication,
    _ => AppStrings.saveMoment,
  };

  DailyLogObservedSection get _activeObservedSection =>
      _observedSectionForIndex(_selectedTabIndex);

  DailyLogObservedSection _observedSectionForIndex(int index) {
    return switch (index) {
      0 => DailyLogObservedSection.period,
      1 => DailyLogObservedSection.nutrition,
      2 => DailyLogObservedSection.medication,
      _ => DailyLogObservedSection.wellbeing,
    };
  }

  int get _cycleDay {
    final lastPeriod = widget.settings.lastPeriodDate;
    if (lastPeriod == null) return 0;
    final length = widget.settings.averageCycleLength;
    if (length <= 0) return 0;
    final difference = _log.date.dateOnly
        .difference(lastPeriod.dateOnly)
        .inDays;
    return ((difference % length) + length) % length + 1;
  }

  void _loadPreviouslyAddedItems() {
    try {
      final storage = Provider.of<LocalStorageService>(context, listen: false);
      final medications = AppStrings.defaultMedications.toSet()
        ..addAll(storage.getCustomMedications())
        ..removeAll(widget.settings.dailyMedications);
      final supplements = AppStrings.defaultSupplements.toSet()
        ..addAll(storage.getCustomSupplements())
        ..removeAll(widget.settings.dailySupplements);

      _previouslyAddedMeds = medications.toList();
      _previouslyAddedSups = supplements.toList();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.96,
      minChildSize: 0.62,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                const _SheetHandle(),
                _buildHeader(),
                if (!widget.isSingleTab) _buildTabBar(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: ListView(
                      key: ValueKey(_selectedTabIndex),
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                      children: [_buildActiveContent()],
                    ),
                  ),
                ),
                _buildSaveArea(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final cycleMeta = _cycleDay > 0
        ? '${AppStrings.today.toUpperCase()} · '
              '${AppStrings.cycleDayLabel.toUpperCase()} $_cycleDay'
        : AppStrings.today.toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 42),
              Expanded(
                child: Text(
                  cycleMeta,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outline),
                ),
                child: IconButton(
                  tooltip: AppStrings.close,
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, size: 19),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              _pageTitle,
              key: ValueKey(_pageTitle),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 35,
                height: 1.02,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 9),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              _pageSubtitle,
              key: ValueKey(_pageSubtitle),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final selected = index == _selectedTabIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: selected ? tab.color : AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                    _visitedSections.add(_observedSectionForIndex(index));
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: selected ? tab.color : AppColors.outline,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: tab.color.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 17,
                        color: selected ? Colors.white : tab.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveContent() {
    return switch (_selectedTabIndex) {
      0 => _buildPeriodContent(),
      1 => _buildNutritionContent(),
      2 => _buildMedicationContent(),
      _ => _buildWellbeingContent(),
    };
  }

  Widget _buildPeriodContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFlowHero(),
        const SizedBox(height: 24),
        _buildSection(
          title: AppStrings.periodBleeding,
          child: _StepSelector(
            labels: AppStrings.flowOptions,
            selectedIndex: _flowIndex,
            color: AppColors.periodPrimary,
            onChanged: (index) => setState(() {
              _log = _log.copyWith(
                flowIntensity: AppStrings.flowOptions[index],
              );
            }),
          ),
        ),
        _buildSection(
          title: AppStrings.periodPain,
          child: _buildOptionalSliderMetric(
            icon: Icons.bolt_outlined,
            title: AppStrings.periodPain,
            value: _log.periodPainLevel,
            minimum: 0,
            maximum: 5,
            step: 1,
            initialValue: 2,
            color: AppColors.periodPrimary,
            valueText: AppStrings.levelOutOfFive,
            onChanged: (value) => setState(() {
              _log = value == null
                  ? _log.copyWith(clearPeriodPainLevel: true)
                  : _log.copyWith(periodPainLevel: value);
            }),
          ),
        ),
        _buildSection(
          title: AppStrings.logAnythingElse,
          child: _buildChipSelector(
            options: AppStrings.painLocations,
            selected: _log.painLocations,
            onChanged: (values) =>
                setState(() => _log = _log.copyWith(painLocations: values)),
            color: AppColors.periodPrimary,
          ),
        ),
        _buildSection(
          title: AppStrings.vaginalDischarge,
          subtitle: AppStrings.dischargeTrackingHint,
          child: _buildVaginalDischargeInput(),
        ),
      ],
    );
  }

  int get _flowIndex {
    final selected = AppStrings.localizeStoredValue(_log.flowIntensity ?? '');
    return AppStrings.flowOptions.indexOf(selected);
  }

  Widget _buildFlowHero() {
    final index = _flowIndex;
    final selected = index >= 0;
    final tones = [
      const Color(0xFFE8BAC0),
      const Color(0xFFD9959E),
      AppColors.periodPrimary,
      const Color(0xFF9E3F4D),
    ];
    final tone = selected ? tones[index] : AppColors.outline;
    final label = selected ? AppStrings.flowOptions[index] : AppStrings.noData;

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: tone.withValues(alpha: 0.32)),
                  ),
                ),
                Container(
                  width: 184,
                  height: 184,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: tone.withValues(alpha: 0.48)),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: selected
                        ? tone
                        : AppColors.surface.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                    border: selected
                        ? null
                        : Border.all(color: AppColors.outline),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: tone.withValues(alpha: 0.22),
                              blurRadius: 24,
                              offset: const Offset(0, 9),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        selected ? index + 1 : 1,
                        (_) => Icon(
                          Icons.water_drop_rounded,
                          size: 29,
                          color: selected ? Colors.white : AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.insightRose : AppColors.textSecondary,
            ),
          ),
          if (selected)
            TextButton(
              onPressed: () => setState(
                () => _log = _log.copyWith(clearFlowIntensity: true),
              ),
              child: Text(AppStrings.delete),
            ),
        ],
      ),
    );
  }

  Widget _buildNutritionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHydrationCard(),
        const SizedBox(height: 24),
        _buildSection(
          title: AppStrings.nutritionStatus,
          child: _buildChipSelector(
            options: AppStrings.nutritionTags,
            selected: _log.nutritionTags,
            onChanged: (values) =>
                setState(() => _log = _log.copyWith(nutritionTags: values)),
            color: AppColors.primary,
          ),
        ),
        _buildSection(
          title: AppStrings.caffeineIntake,
          subtitle: AppStrings.caffeineServingHint,
          child: _buildOptionalCounterMetric(
            icon: Icons.coffee_outlined,
            title: AppStrings.caffeineIntake,
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
        ),
        _buildSection(
          title: AppStrings.bowelActivity,
          child: _buildChipSelector(
            options: AppStrings.bowelActivityOptions,
            selected: _log.bowelActivity,
            onChanged: (values) =>
                setState(() => _log = _log.copyWith(bowelActivity: values)),
            color: AppColors.info,
          ),
        ),
        _buildSection(
          title: AppStrings.notes,
          child: TextField(
            controller: _nutritionNotesController,
            maxLines: 3,
            onChanged: (value) => _log = _log.copyWith(nutritionNotes: value),
            decoration: _fieldDecoration(AppStrings.notesHint),
          ),
        ),
      ],
    );
  }

  Widget _buildHydrationCard() {
    final milliliters = _log.waterIntakeMl ?? 0;
    final glasses = (milliliters / 250).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.logHydration.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.milliliters(milliliters),
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              _RoundActionButton(
                icon: Icons.remove_rounded,
                enabled: milliliters > 0,
                color: AppColors.primary,
                filled: false,
                onTap: () => setState(() {
                  final next = (milliliters - 250).clamp(0, 6000);
                  _log = _log.copyWith(waterIntakeMl: next);
                }),
              ),
              const SizedBox(width: 8),
              _RoundActionButton(
                icon: Icons.add_rounded,
                enabled: milliliters < 6000,
                color: AppColors.primary,
                filled: true,
                onTap: () => setState(() {
                  final next = (milliliters + 250).clamp(0, 6000);
                  _log = _log.copyWith(waterIntakeMl: next);
                }),
              ),
              if (_log.waterIntakeMl != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  tooltip: AppStrings.delete,
                  onPressed: () => setState(
                    () => _log = _log.copyWith(clearWaterIntake: true),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(8, (index) {
              final filled = index < glasses;
              return Expanded(
                child: Container(
                  height: 45,
                  margin: EdgeInsets.only(right: index == 7 ? 0 : 5),
                  decoration: BoxDecoration(
                    color: filled ? AppColors.primaryLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: filled ? AppColors.primary : AppColors.outline,
                    ),
                  ),
                  child: Icon(
                    Icons.local_drink_outlined,
                    size: 17,
                    color: filled ? AppColors.primary : AppColors.textHint,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: AppStrings.medications,
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
                onChanged: (entries) =>
                    setState(() => _log = _log.copyWith(medications: entries)),
              ),
              const SizedBox(height: 16),
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
        _buildSection(
          title: AppStrings.supplements,
          child: Column(
            children: [
              _buildMedicationList(
                items: widget.settings.dailySupplements,
                entries: _log.supplements,
                color: AppColors.success,
                customController: _customSupController,
                customHint: AppStrings.supplementExample,
                suggestions: _previouslyAddedSups,
                onChanged: (entries) =>
                    setState(() => _log = _log.copyWith(supplements: entries)),
              ),
              const SizedBox(height: 16),
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
      ],
    );
  }

  Widget _buildWellbeingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMoodHero(),
        const SizedBox(height: 24),
        _buildSection(
          title: AppStrings.mood,
          child: _StepSelector(
            labels: AppStrings.moodOptions.keys.toList(),
            selectedIndex: _moodIndex,
            color: _activeMoodColor,
            onChanged: (index) {
              final entry = AppStrings.moodOptions.entries.elementAt(index);
              setState(() {
                _log = _log.copyWith(mood: entry.key, moodEmoji: entry.value);
              });
            },
          ),
        ),
        _buildSection(
          title: AppStrings.activityStatus,
          child: _buildChipSelector(
            options: AppStrings.activityOptions,
            selected: _log.activities,
            onChanged: (values) =>
                setState(() => _log = _log.copyWith(activities: values)),
            color: AppColors.secondary,
          ),
        ),
        _buildSection(
          title: AppStrings.dailyFactors,
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
                      : _log.copyWith(sleepDurationMinutes: value);
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
        _buildSection(
          title: AppStrings.sexualActivity,
          child: Row(
            children: [
              _toggleButton(
                AppStrings.yes,
                _log.sexualActivity == true,
                () =>
                    setState(() => _log = _log.copyWith(sexualActivity: true)),
              ),
              const SizedBox(width: 8),
              _toggleButton(
                AppStrings.no,
                _log.sexualActivity == false,
                () =>
                    setState(() => _log = _log.copyWith(sexualActivity: false)),
              ),
            ],
          ),
        ),
        _buildSection(
          title: AppStrings.sensations,
          child: _buildChipSelector(
            options: AppStrings.painLocations,
            selected: _log.painLocations,
            onChanged: (values) =>
                setState(() => _log = _log.copyWith(painLocations: values)),
            color: AppColors.accent,
          ),
        ),
        _buildSection(
          title: AppStrings.moodNote,
          child: TextField(
            controller: _moodNoteController,
            maxLines: 3,
            onChanged: (value) => _log = _log.copyWith(moodNote: value),
            decoration: _fieldDecoration(AppStrings.notesHint),
          ),
        ),
        _buildSection(
          title: AppStrings.notes,
          child: TextField(
            controller: _notesController,
            maxLines: 3,
            onChanged: (value) => _log = _log.copyWith(notes: value),
            decoration: _fieldDecoration(AppStrings.notesHint),
          ),
        ),
      ],
    );
  }

  int get _moodIndex {
    final selected = AppStrings.localizeStoredValue(_log.mood ?? '');
    return AppStrings.moodOptions.keys.toList().indexOf(selected);
  }

  List<Color> get _moodColors => const [
    AppColors.moodAngry,
    AppColors.moodGood,
    AppColors.moodSad,
    AppColors.moodHappy,
    AppColors.moodPeaceful,
    AppColors.moodNeutral,
    AppColors.warning,
  ];

  Color get _activeMoodColor =>
      _moodIndex < 0 ? AppColors.secondary : _moodColors[_moodIndex];

  Widget _buildMoodHero() {
    final index = _moodIndex;
    final selected = index >= 0;
    final entry = selected
        ? AppStrings.moodOptions.entries.elementAt(index)
        : null;
    final tone = selected ? _moodColors[index] : AppColors.outline;

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 230,
            height: 230,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(-7, -5),
                  child: Container(
                    width: 218,
                    height: 218,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: tone.withValues(alpha: 0.45),
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(9, 5),
                  child: Container(
                    width: 218,
                    height: 218,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: tone.withValues(alpha: 0.55),
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 166,
                  height: 166,
                  decoration: BoxDecoration(
                    color: selected ? tone : AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: tone.withValues(alpha: 0.18),
                        blurRadius: 26,
                        offset: const Offset(0, 9),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      entry?.value ?? '—',
                      style: TextStyle(
                        fontSize: selected ? 60 : 42,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            entry?.key ?? AppStrings.noData,
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 21,
              height: 1.1,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 13),
          child,
        ],
      ),
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
      runSpacing: 9,
      children: options.map((option) {
        final active = selected.any(
          (value) => AppStrings.localizeStoredValue(value) == option,
        );
        return _ChoiceChip(
          label: option,
          active: active,
          color: color,
          onTap: () {
            final next = List<String>.from(selected);
            if (active) {
              next.removeWhere(
                (value) => AppStrings.localizeStoredValue(value) == option,
              );
            } else {
              next.add(option);
            }
            onChanged(next);
          },
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
      runSpacing: 9,
      children: options.map((option) {
        final active = AppStrings.localizeStoredValue(selected ?? '') == option;
        return _ChoiceChip(
          label: option,
          active: active,
          color: color,
          onTap: () => onChanged(active ? null : option),
        );
      }).toList(),
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
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                valueText(value),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              IconButton(
                tooltip: AppStrings.delete,
                visualDensity: VisualDensity.compact,
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.close_rounded, size: 17),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.14),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
              trackHeight: 7,
            ),
            child: Slider(
              value: value.toDouble(),
              min: minimum.toDouble(),
              max: maximum.toDouble(),
              divisions: (maximum - minimum) ~/ step,
              onChanged: (next) {
                final stepped =
                    ((next - minimum) / step).round() * step + minimum;
                onChanged(stepped.clamp(minimum, maximum));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalCounterMetric({
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              valueText(value),
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _RoundActionButton(
            icon: Icons.remove_rounded,
            enabled: value > minimum,
            color: color,
            filled: false,
            onTap: () => onChanged((value - step).clamp(minimum, maximum)),
          ),
          const SizedBox(width: 7),
          _RoundActionButton(
            icon: Icons.add_rounded,
            enabled: value < maximum,
            color: color,
            filled: true,
            onTap: () => onChanged((value + step).clamp(minimum, maximum)),
          ),
          IconButton(
            tooltip: AppStrings.delete,
            visualDensity: VisualDensity.compact,
            onPressed: () => onChanged(null),
            icon: const Icon(Icons.close_rounded, size: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricAddRow({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onAdd,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.add_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleButton(String label, bool selected, VoidCallback onTap) {
    return _ChoiceChip(
      label: label,
      active: selected,
      color: _activeColor,
      onTap: onTap,
    );
  }

  Widget _buildVaginalDischargeInput() {
    final present = _log.vaginalDischargePresent;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.dischargePresent,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (present != null)
                IconButton(
                  tooltip: AppStrings.delete,
                  onPressed: _clearDischarge,
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 10),
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
            const SizedBox(height: 22),
            _smallSectionLabel(AppStrings.dischargeColor),
            const SizedBox(height: 9),
            _buildDischargeColorSelector(),
            const SizedBox(height: 20),
            _smallSectionLabel(AppStrings.dischargeConsistency),
            const SizedBox(height: 9),
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
            const SizedBox(height: 20),
            _smallSectionLabel(AppStrings.dischargeAmount),
            const SizedBox(height: 9),
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
              color: AppColors.secondary,
            ),
            const SizedBox(height: 20),
            _smallSectionLabel(AppStrings.dischargeSymptoms),
            const SizedBox(height: 9),
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
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              AppStrings.dischargeMedicalDisclaimer,
              style: const TextStyle(
                fontSize: 11,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallSectionLabel(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  void _clearDischarge() {
    setState(() {
      _log = _log.copyWith(
        clearVaginalDischargePresent: true,
        clearVaginalDischargeColor: true,
        clearVaginalDischargeConsistency: true,
        clearVaginalDischargeAmount: true,
        vaginalDischargeSymptoms: const {},
      );
    });
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
      children: VaginalDischargeColor.values.map((value) {
        final selected = _log.vaginalDischargeColor == value;
        return InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => setState(() {
            _log = selected
                ? _log.copyWith(clearVaginalDischargeColor: true)
                : _log.copyWith(vaginalDischargeColor: value);
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryLight : AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.outline,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: swatches[value.index],
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.textHint),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  AppStrings.dischargeColorOptions[value.index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
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
    final allEntries = <MedicationEntry>[];
    for (final name in items) {
      allEntries.add(
        entries.firstWhere(
          (entry) => entry.name == name,
          orElse: () => MedicationEntry(
            name: name,
            time: AppStrings.medicationTimes.first,
            stomachState: AppStrings.stomachStates.first,
          ),
        ),
      );
    }
    for (final entry in entries) {
      if (!items.contains(entry.name)) allEntries.add(entry);
    }
    final suggestedItems = suggestions
        .where((name) => !allEntries.any((entry) => entry.name == name))
        .toList();

    return Column(
      children: [
        for (final entry in allEntries)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: entry.taken
                      ? color.withValues(alpha: 0.45)
                      : AppColors.outline,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(9),
                        onTap: () {
                          onChanged(
                            allEntries
                                .map(
                                  (item) => item.name == entry.name
                                      ? item.copyWith(taken: !item.taken)
                                      : item,
                                )
                                .toList(),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: entry.taken ? color : Colors.transparent,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: entry.taken ? color : AppColors.outline,
                              width: 1.5,
                            ),
                          ),
                          child: entry.taken
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          entry.name,
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!items.contains(entry.name))
                        IconButton(
                          tooltip: AppStrings.delete,
                          onPressed: () => onChanged(
                            allEntries
                                .where((item) => item.name != entry.name)
                                .toList(),
                          ),
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: AppColors.error,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        _miniDropdown(
                          value: AppStrings.localizeStoredValue(entry.time),
                          items: AppStrings.medicationTimes,
                          color: color,
                          onChanged: (value) => onChanged(
                            allEntries
                                .map(
                                  (item) => item.name == entry.name
                                      ? item.copyWith(time: value)
                                      : item,
                                )
                                .toList(),
                          ),
                        ),
                        _miniDropdown(
                          value: AppStrings.localizeStoredValue(
                            entry.stomachState,
                          ),
                          items: AppStrings.stomachStates,
                          color: color,
                          onChanged: (value) => onChanged(
                            allEntries
                                .map(
                                  (item) => item.name == entry.name
                                      ? item.copyWith(stomachState: value)
                                      : item,
                                )
                                .toList(),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final dosages = [...AppStrings.dosageOptions];
                            final current = AppStrings.localizeStoredValue(
                              entry.dosage,
                            );
                            if (!dosages.contains(current)) {
                              dosages.add(current);
                            }
                            dosages.add(AppStrings.custom);
                            return _miniDropdown(
                              value: current,
                              items: dosages,
                              color: color,
                              onChanged: (value) {
                                if (value == AppStrings.custom) {
                                  _showCustomDosageDialog(
                                    entry,
                                    allEntries,
                                    onChanged,
                                    color,
                                  );
                                } else {
                                  onChanged(
                                    allEntries
                                        .map(
                                          (item) => item.name == entry.name
                                              ? item.copyWith(dosage: value)
                                              : item,
                                        )
                                        .toList(),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (suggestedItems.isNotEmpty) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.previouslyAdded,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: suggestedItems
                  .map(
                    (name) => _ChoiceChip(
                      label: name,
                      active: false,
                      color: color,
                      leading: Icons.add_rounded,
                      onTap: () {
                        onChanged([
                          ...allEntries,
                          MedicationEntry(
                            name: name,
                            time: AppStrings.medicationTimes.first,
                            stomachState: AppStrings.stomachStates.first,
                            taken: true,
                          ),
                        ]);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
        ],
        Container(
          padding: const EdgeInsets.fromLTRB(13, 5, 6, 5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: customController,
                  decoration: InputDecoration(
                    hintText: customHint,
                    hintStyle: const TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () {
                  final name = customController.text.trim();
                  if (name.isEmpty ||
                      allEntries.any((entry) => entry.name == name)) {
                    return;
                  }
                  onChanged([
                    ...allEntries,
                    MedicationEntry(
                      name: name,
                      time: AppStrings.medicationTimes.first,
                      stomachState: AppStrings.stomachStates.first,
                      taken: true,
                    ),
                  ]);
                  customController.clear();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: const StadiumBorder(),
                ),
                child: Text(AppStrings.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _miniDropdown({
    required String value,
    required List<String> items,
    required Color color,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(18),
        icon: Icon(Icons.expand_more_rounded, size: 18, color: color),
        isDense: true,
      ),
    );
  }

  void _showCustomDosageDialog(
    MedicationEntry entry,
    List<MedicationEntry> allEntries,
    ValueChanged<List<MedicationEntry>> onChanged,
    Color color,
  ) {
    final controller = TextEditingController(text: entry.dosage);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          AppStrings.customDosage,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: _fieldDecoration(AppStrings.customDosageHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              final dosage = controller.text.trim();
              if (dosage.isNotEmpty) {
                onChanged(
                  allEntries
                      .map(
                        (item) => item.name == entry.name
                            ? item.copyWith(dosage: dosage)
                            : item,
                      )
                      .toList(),
                );
              }
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(backgroundColor: color),
            child: Text(AppStrings.save),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _activeColor, width: 1.5),
      ),
    );
  }

  Widget _buildSaveArea() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 14),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground.withValues(alpha: 0.96),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.07),
              blurRadius: 20,
              offset: const Offset(0, -7),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: FilledButton(
            onPressed: _isSaving ? null : _saveLog,
            style: FilledButton.styleFrom(
              backgroundColor: _activeColor,
              disabledBackgroundColor: _activeColor.withValues(alpha: 0.62),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              elevation: 0,
              shadowColor: _activeColor.withValues(alpha: 0.45),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 23,
                    height: 23,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4,
                    ),
                  )
                : Text(
                    _saveLabel,
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveLog() async {
    if (_isSaving) return;
    final today = AppTime.now.dateOnly;
    var finalDate = _log.date;

    if (_log.date.dateOnly.isBefore(today)) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _log.date.hour, minute: _log.date.minute),
        helpText: AppStrings.selectLogTime,
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        ),
      );
      if (pickedTime == null) return;
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
    if (!mounted) return;
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
            borderRadius: BorderRadius.circular(14),
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
  }
}

class _LogTabItem {
  final String label;
  final IconData icon;
  final Color color;

  const _LogTabItem({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;
  final IconData? leading;

  const _ChoiceChip({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? color : AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: active ? color : AppColors.outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                Icon(leading, size: 15, color: active ? Colors.white : color),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _RoundActionButton({
    required this.icon,
    required this.enabled,
    required this.color,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: Material(
        color: filled ? color : AppColors.surface,
        shape: CircleBorder(
          side: BorderSide(color: filled ? color : AppColors.outline),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              icon,
              size: 19,
              color: filled ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepSelector extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Color color;
  final ValueChanged<int> onChanged;

  const _StepSelector({
    required this.labels,
    required this.selectedIndex,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex < 0 ? 0 : selectedIndex;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: labels.asMap().entries.map((entry) {
            final active = entry.key == selectedIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(entry.key),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    entry.value,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.15,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                      color: active
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.16),
            thumbColor: selectedIndex < 0 ? AppColors.surface : color,
            overlayColor: color.withValues(alpha: 0.1),
            trackHeight: 10,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 11,
              elevation: 3,
            ),
          ),
          child: Slider(
            value: safeIndex.toDouble(),
            min: 0,
            max: (labels.length - 1).toDouble(),
            divisions: labels.length - 1,
            onChanged: (value) => onChanged(value.round()),
          ),
        ),
      ],
    );
  }
}
