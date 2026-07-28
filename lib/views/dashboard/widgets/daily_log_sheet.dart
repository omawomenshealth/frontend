import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/medication_reminder_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/notification_service.dart';
import 'medication_reminder_section.dart';

class DailyLogSheet extends StatefulWidget {
  final DailyLog initialLog;
  final UserSettings settings;
  final Future<bool> Function(DailyLog) onSave;
  final Future<void> Function()? onSettingsChanged;
  final int initialTabIndex;
  final bool isSingleTab;

  const DailyLogSheet({
    super.key,
    required this.initialLog,
    required this.settings,
    required this.onSave,
    this.onSettingsChanged,
    this.initialTabIndex = 0,
    this.isSingleTab = false,
  });

  @override
  State<DailyLogSheet> createState() => _DailyLogSheetState();
}

class _DailyLogSheetState extends State<DailyLogSheet> {
  late DailyLog _log;
  late int _logType;
  var _isSaving = false;

  late int _flowIndex;
  late Set<String> _periodSymptoms;

  late int _waterGlasses;
  late Set<String> _meals;
  late Map<String, int> _mealQualityIndices;
  late Map<String, Set<String>> _mealFoodGroups;
  late Set<String> _postMealFeelings;
  late Set<String> _cravings;

  final _symptomSearchController = TextEditingController();
  late Set<String> _symptoms;
  late Map<String, int> _symptomSeverities;
  late bool? _sexualActivity;
  late Set<SexualActivityType> _sexualActivityTypes;
  late bool? _vaginalDischargePresent;
  late VaginalDischargeColor? _vaginalDischargeColor;
  late VaginalDischargeConsistency? _vaginalDischargeConsistency;
  late VaginalDischargeAmount? _vaginalDischargeAmount;
  late Set<VaginalDischargeSymptom> _vaginalDischargeSymptoms;
  late bool? _dreamRemembered;
  final _dreamNoteController = TextEditingController();

  late List<MedicationEntry> _medications;
  late List<MedicationEntry> _supplements;
  var _medicationSectionExpanded = false;
  String? _expandedMedicationEntry;

  late int _moodIndex;
  var _moodStep = 1;
  late Set<String> _moodCompanions;
  late Set<String> _moodPlaces;

  @override
  void initState() {
    super.initState();
    _log = widget.initialLog;
    _logType = widget.initialTabIndex.clamp(0, 3);

    _flowIndex = _localizedIndex(
      AppStrings.flowOptions,
      _log.flowIntensity,
      fallback: 2,
    );
    _periodSymptoms = _localizedSet(
      _log.symptoms,
      AppStrings.periodSymptomOptions,
    );

    _waterGlasses = _log.waterIntakeMl == null
        ? 0
        : (_log.waterIntakeMl! / 250).round().clamp(0, 12);
    _meals = _localizedSet(_log.mealTypes, AppStrings.nutritionMealOptions);
    _mealQualityIndices = {
      for (final entry in _log.mealQualities.entries)
        AppStrings.localizeStoredValue(entry.key): _localizedIndex(
          AppStrings.nutritionQualityOptions,
          entry.value,
          fallback: 1,
        ),
    };
    if (_mealQualityIndices.isEmpty && _log.nutritionQuality != null) {
      final legacyIndex = _localizedIndex(
        AppStrings.nutritionQualityOptions,
        _log.nutritionQuality,
        fallback: 1,
      );
      for (final meal in _meals.where(_supportsMealQuality)) {
        _mealQualityIndices[meal] = legacyIndex;
      }
    }
    _mealFoodGroups = {
      for (final entry in _log.mealFoodGroups.entries)
        AppStrings.localizeStoredValue(entry.key): entry.value
            .map(AppStrings.localizeStoredValue)
            .toSet(),
    };
    _postMealFeelings = _localizedSet(
      _log.postMealFeelings,
      AppStrings.postMealFeelingOptions,
    );
    _cravings = _localizedSet(
      _log.cravings,
      AppStrings.nutritionCravingOptions,
    );

    _symptoms = _localizedSet(_log.symptoms, _allSymptomOptions);
    _symptomSeverities = {
      for (final rawSymptom in _log.symptoms)
        AppStrings.localizeStoredValue(rawSymptom):
            _log.symptomSeverities[rawSymptom] ??
            _log.symptomSeverities[AppStrings.localizeStoredValue(
              rawSymptom,
            )] ??
            _log.symptomSeverity ??
            2,
    };
    _sexualActivity = _log.sexualActivity;
    _sexualActivityTypes = {..._log.sexualActivityTypes};
    if (_sexualActivity == false && _sexualActivityTypes.isEmpty) {
      _sexualActivityTypes.add(SexualActivityType.none);
    }
    _vaginalDischargePresent = _log.vaginalDischargePresent;
    _vaginalDischargeColor = _log.vaginalDischargeColor;
    _vaginalDischargeConsistency = _log.vaginalDischargeConsistency;
    _vaginalDischargeAmount = _log.vaginalDischargeAmount;
    _vaginalDischargeSymptoms = {..._log.vaginalDischargeSymptoms};
    _dreamRemembered = _log.dreamRemembered;
    _dreamNoteController.text = _log.dreamNote ?? '';

    _medications = _initialMedicationEntries(
      _log.medications,
      widget.settings.dailyMedications,
    );
    _supplements = _initialMedicationEntries(
      _log.supplements,
      widget.settings.dailySupplements,
    );

    _moodIndex = _localizedIndex(
      AppStrings.moodCheckInOptions,
      _log.mood,
      fallback: 1,
    );
    _moodCompanions = _localizedSet(
      _log.moodCompanions,
      AppStrings.moodCompanionOptions,
    );
    _moodPlaces = _localizedSet(_log.moodPlaces, AppStrings.moodPlaceOptions);
  }

  @override
  void dispose() {
    _symptomSearchController.dispose();
    _dreamNoteController.dispose();
    super.dispose();
  }

  List<String> get _allSymptomOptions => [
    ...AppStrings.symptomOverallOptions,
    ...AppStrings.symptomBodyOptions,
    ...AppStrings.symptomSkinHairOptions,
    ...AppStrings.symptomEnergyOptions,
    ...AppStrings.symptomSleepOptions,
    ...AppStrings.symptomDigestionOptions,
  ];

  int _localizedIndex(
    List<String> options,
    String? value, {
    required int fallback,
  }) {
    if (value == null) return fallback;
    final localized = AppStrings.localizeStoredValue(value);
    final index = options.indexOf(localized);
    return index < 0 ? fallback : index;
  }

  Set<String> _localizedSet(List<String> values, List<String> options) {
    final result = <String>{};
    for (final value in values) {
      final localized = AppStrings.localizeStoredValue(value);
      if (options.contains(localized)) result.add(localized);
    }
    return result;
  }

  List<MedicationEntry> _initialMedicationEntries(
    List<MedicationEntry> saved,
    List<String> configuredNames,
  ) {
    final entries = <String, MedicationEntry>{};
    for (final entry in saved) {
      entries[entry.name] = entry.copyWith(
        times: entry.times.map(AppStrings.localizeStoredValue).toSet(),
        stomachState: AppStrings.localizeStoredValue(entry.stomachState),
      );
    }
    for (final rawName in configuredNames) {
      final name = rawName.trim();
      if (name.isEmpty) continue;
      entries.putIfAbsent(
        name,
        () => MedicationEntry(
          name: name,
          time: AppStrings.medicationTimes.first,
          stomachState: AppStrings.stomachStates.first,
          doseCount: 1,
        ),
      );
    }
    return entries.values.toList();
  }

  int get _cycleDay {
    final lastPeriod = widget.settings.lastPeriodDate;
    final length = widget.settings.averageCycleLength;
    if (lastPeriod == null || length <= 0) return 0;
    final difference = _log.date.dateOnly
        .difference(lastPeriod.dateOnly)
        .inDays;
    return ((difference % length) + length) % length + 1;
  }

  Color get _tone => switch (_logType) {
    0 => AppColors.periodPrimary,
    1 => AppColors.secondary,
    2 => AppColors.secondary,
    _ => AppColors.primary,
  };

  bool get _isMoodContext => _logType == 3 && _moodStep == 2;

  String get _actionLabel {
    if (_logType == 3 && _moodStep == 1) return AppStrings.continueAction;
    return switch (_logType) {
      0 => AppStrings.savePeriod,
      1 => AppStrings.saveNutrition,
      2 => AppStrings.save,
      _ => AppStrings.saveMoment,
    };
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.98,
      minChildSize: 0.72,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              const _SheetHandle(),
              _buildTopBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: ListView(
                    key: ValueKey('$_logType-$_moodStep'),
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 104),
                    children: [_buildContent()],
                  ),
                ),
              ),
              _buildBottomAction(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    final meta = _cycleDay > 0
        ? '${AppStrings.today.toUpperCase()} · '
              '${AppStrings.cycleDayLabel.toUpperCase()} $_cycleDay'
        : AppStrings.today.toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: _isMoodContext
                ? IconButton(
                    tooltip: AppStrings.back,
                    onPressed: () => setState(() => _moodStep = 1),
                    icon: const Icon(Icons.chevron_left_rounded, size: 24),
                  )
                : null,
          ),
          Expanded(
            child: Text(
              meta,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
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
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return switch (_logType) {
      0 => _buildPeriodPage(),
      1 => _buildNutritionPage(),
      2 => _buildSymptomPage(),
      _ => _moodStep == 1 ? _buildMoodPage() : _buildMoodContextPage(),
    };
  }

  Widget _buildIntro({
    required String title,
    required String subtitle,
    bool centered = false,
  }) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 29,
            height: 1.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 12,
            height: 1.45,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodPage() {
    final flowTones = [
      const Color(0xFFE8BAC0),
      const Color(0xFFD9959E),
      const Color(0xFFD97179),
      const Color(0xFF9E3F4D),
    ];
    final tone = flowTones[_flowIndex];

    return Column(
      children: [
        _buildIntro(
          title: AppStrings.logPeriodQuestion,
          subtitle: AppStrings.logPeriodHint,
          centered: true,
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: 196,
          height: 196,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tone.withValues(alpha: 0.28)),
                ),
              ),
              Container(
                width: 172,
                height: 172,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tone.withValues(alpha: 0.45)),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 144,
                height: 144,
                decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _flowIndex + 1,
                    (_) => const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppStrings.flowOptions[_flowIndex],
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.insightRose,
          ),
        ),
        const SizedBox(height: 20),
        _StepSelector(
          labels: AppStrings.flowOptions,
          selectedIndex: _flowIndex,
          color: AppColors.periodPrimary,
          onChanged: (index) => setState(() => _flowIndex = index),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(child: _SectionTitle(AppStrings.logAnythingElse)),
            IconButton.filled(
              key: const ValueKey('period_open_symptoms'),
              tooltip: AppStrings.symptom,
              onPressed: _promptSavePeriodAndOpenSymptoms,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.periodPrimary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildSimpleChoices(
            options: AppStrings.periodSymptomOptions,
            selected: _periodSymptoms,
            color: AppColors.periodPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntro(
          title: AppStrings.logNutritionQuestion,
          subtitle: AppStrings.logNutritionHint,
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
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
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          AppStrings.hydrationGlasses(_waterGlasses, 8),
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _RoundButton(
                    key: const ValueKey('water_decrement'),
                    icon: Icons.remove_rounded,
                    color: AppColors.secondary,
                    filled: false,
                    enabled: _waterGlasses > 0,
                    onTap: () =>
                        setState(() => _waterGlasses = _waterGlasses - 1),
                  ),
                  const SizedBox(width: 9),
                  _RoundButton(
                    key: const ValueKey('water_increment'),
                    icon: Icons.add_rounded,
                    color: AppColors.secondary,
                    filled: true,
                    enabled: _waterGlasses < 12,
                    onTap: () =>
                        setState(() => _waterGlasses = _waterGlasses + 1),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: List.generate(8, (index) {
                  final filled = index < _waterGlasses;
                  return Expanded(
                    child: Container(
                      height: 41,
                      margin: EdgeInsets.only(right: index == 7 ? 0 : 6),
                      decoration: BoxDecoration(
                        color: filled
                            ? AppColors.secondaryLight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: filled
                              ? AppColors.secondary
                              : AppColors.outline,
                        ),
                      ),
                      child: Icon(
                        Icons.local_drink_outlined,
                        size: 16,
                        color: filled
                            ? AppColors.secondary
                            : AppColors.textHint,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.mealsToday),
        const SizedBox(height: 11),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final meal in AppStrings.nutritionMealOptions)
              _PillChoice(
                label: meal,
                selected: _meals.contains(meal),
                color: AppColors.secondary,
                onTap: () => _toggleMeal(meal),
              ),
          ],
        ),
        const SizedBox(height: 24),
        _SectionTitle(AppStrings.mealsFeel),
        for (final meal in AppStrings.nutritionMealOptions.where(
          _meals.contains,
        )) ...[const SizedBox(height: 11), _buildMealDetails(meal)],
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.howFeltAfterEating),
        const SizedBox(height: 11),
        _buildSimpleChoices(
          options: AppStrings.postMealFeelingOptions,
          selected: _postMealFeelings,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.cravingsQuestion),
        const SizedBox(height: 11),
        _buildSimpleChoices(
          options: AppStrings.nutritionCravingOptions,
          selected: _cravings,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 28),
        _buildNutritionMedicationSection(),
      ],
    );
  }

  Widget _buildSymptomPage() {
    final groups = _symptomGroups;
    final query = _symptomSearchController.text.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIntro(
          title: AppStrings.symptomQuestion,
          subtitle: AppStrings.symptomHint,
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _symptomSearchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: AppStrings.searchSymptoms,
            prefixIcon: const Icon(Icons.search_rounded, size: 19),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.outline),
            ),
          ),
        ),
        for (final group in groups)
          if (query.isEmpty ||
              group.items.any(
                (item) => item.label.toLowerCase().contains(query),
              )) ...[
            const SizedBox(height: 20),
            Text(
              group.title,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 9),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                final tileWidth = (constraints.maxWidth - spacing) / 2;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final item in group.items)
                      if (query.isEmpty ||
                          item.label.toLowerCase().contains(query))
                        SizedBox(
                          width: tileWidth,
                          child: _SymptomTile(
                            item: item,
                            selected: _symptoms.contains(item.label),
                            severity: _symptomSeverities[item.label] ?? 2,
                            onTap: () => _toggleSymptom(item.label),
                            onSeverityChanged: (severity) => setState(
                              () => _symptomSeverities[item.label] = severity,
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),
          ],
        const SizedBox(height: 22),
        _buildDreamCard(),
        const SizedBox(height: 26),
        _buildBodyTrackingCard(),
      ],
    );
  }

  Widget _buildDreamCard() {
    return Container(
      key: const ValueKey('dream_card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(AppStrings.dreamQuestion),
          const SizedBox(height: 11),
          _buildTrackingChoices(
            options: [AppStrings.yes, AppStrings.no],
            icons: const [Icons.nightlight_round, Icons.bedtime_outlined],
            selectedIndices: {
              if (_dreamRemembered == true) 0,
              if (_dreamRemembered == false) 1,
            },
            color: AppColors.secondaryDark,
            keyPrefix: 'dream',
            onSelected: (index) => setState(() {
              _dreamRemembered = index == 0;
              if (_dreamRemembered != true) _dreamNoteController.clear();
            }),
          ),
          if (_dreamRemembered == true) ...[
            const SizedBox(height: 16),
            Text(
              AppStrings.dreamNoteQuestion,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dreamNoteController,
              minLines: 2,
              maxLines: 4,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: AppStrings.dreamNoteHint,
                filled: true,
                fillColor: AppColors.scaffoldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.outline),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBodyTrackingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(AppStrings.sexualActivity),
          const SizedBox(height: 5),
          Text(
            AppStrings.sexualActivityQuestion,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 11),
          _buildTrackingChoices(
            options: AppStrings.sexualActivityOptions,
            icons: const [
              Icons.favorite_outline_rounded,
              Icons.self_improvement_rounded,
              Icons.health_and_safety_outlined,
              Icons.shield_outlined,
              Icons.block_rounded,
            ],
            selectedIndices: _sexualActivityTypes
                .map((type) => type.index)
                .toSet(),
            color: AppColors.primary,
            onSelected: _toggleSexualActivityType,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 19),
            child: Divider(height: 1, color: AppColors.outline),
          ),
          _SectionTitle(AppStrings.vaginalDischarge),
          const SizedBox(height: 5),
          Text(
            AppStrings.dischargePresent,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 11),
          _buildTrackingChoices(
            options: AppStrings.dischargePresenceOptions,
            icons: const [Icons.water_drop_outlined, Icons.water_drop_outlined],
            selectedIndices: {
              if (_vaginalDischargePresent == true) 0,
              if (_vaginalDischargePresent == false) 1,
            },
            color: AppColors.secondaryDark,
            onSelected: (index) {
              final value = index == 0;
              setState(() {
                _vaginalDischargePresent = value;
                if (!value) {
                  _vaginalDischargeColor = null;
                  _vaginalDischargeConsistency = null;
                  _vaginalDischargeAmount = null;
                  _vaginalDischargeSymptoms.clear();
                }
              });
            },
          ),
          if (_vaginalDischargePresent == true) ...[
            const SizedBox(height: 20),
            _buildDischargeChoiceSection(
              title: AppStrings.dischargeColor,
              options: AppStrings.dischargeColorOptions,
              selectedIndex: _vaginalDischargeColor?.index,
              onSelected: (index) => setState(
                () => _vaginalDischargeColor =
                    VaginalDischargeColor.values[index],
              ),
            ),
            const SizedBox(height: 18),
            _buildDischargeChoiceSection(
              title: AppStrings.dischargeConsistency,
              options: AppStrings.dischargeConsistencyOptions,
              selectedIndex: _vaginalDischargeConsistency?.index,
              onSelected: (index) => setState(
                () => _vaginalDischargeConsistency =
                    VaginalDischargeConsistency.values[index],
              ),
            ),
            const SizedBox(height: 18),
            _buildDischargeChoiceSection(
              title: AppStrings.dischargeAmount,
              options: AppStrings.dischargeAmountOptions,
              selectedIndex: _vaginalDischargeAmount?.index,
              onSelected: (index) => setState(
                () => _vaginalDischargeAmount =
                    VaginalDischargeAmount.values[index],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              AppStrings.dischargeSymptoms.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (
                  var index = 0;
                  index < AppStrings.dischargeSymptomOptions.length;
                  index++
                )
                  _PillChoice(
                    label: AppStrings.dischargeSymptomOptions[index],
                    selected: _vaginalDischargeSymptoms.contains(
                      VaginalDischargeSymptom.values[index],
                    ),
                    color: AppColors.secondaryDark,
                    onTap: () {
                      final symptom = VaginalDischargeSymptom.values[index];
                      setState(() {
                        if (_vaginalDischargeSymptoms.contains(symptom)) {
                          _vaginalDischargeSymptoms.remove(symptom);
                        } else {
                          _vaginalDischargeSymptoms.add(symptom);
                        }
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              AppStrings.dischargeTrackingHint,
              style: const TextStyle(
                fontSize: 11,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              AppStrings.dischargeMedicalDisclaimer,
              style: const TextStyle(
                fontSize: 10,
                height: 1.4,
                color: AppColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingChoices({
    required List<String> options,
    required List<IconData> icons,
    required Set<int> selectedIndices,
    required Color color,
    String? keyPrefix,
    required ValueChanged<int> onSelected,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final width = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var index = 0; index < options.length; index++)
              SizedBox(
                width: width,
                child: _TrackingChoiceTile(
                  key: keyPrefix == null
                      ? null
                      : ValueKey('${keyPrefix}_choice_$index'),
                  label: options[index],
                  icon: icons[index],
                  selected: selectedIndices.contains(index),
                  color: color,
                  onTap: () => onSelected(index),
                ),
              ),
          ],
        );
      },
    );
  }

  void _toggleSexualActivityType(int index) {
    final type = SexualActivityType.values[index];
    setState(() {
      if (type == SexualActivityType.none) {
        _sexualActivityTypes
          ..clear()
          ..add(SexualActivityType.none);
        _sexualActivity = false;
        return;
      }

      _sexualActivityTypes.remove(SexualActivityType.none);
      if (_sexualActivityTypes.contains(type)) {
        _sexualActivityTypes.remove(type);
      } else {
        _sexualActivityTypes.add(type);
      }
      _sexualActivity = _sexualActivityTypes.isEmpty ? null : true;
    });
  }

  Widget _buildDischargeChoiceSection({
    required String title,
    required List<String> options,
    required int? selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var index = 0; index < options.length; index++)
              _PillChoice(
                label: options[index],
                selected: selectedIndex == index,
                color: AppColors.secondaryDark,
                onTap: () => onSelected(index),
              ),
          ],
        ),
      ],
    );
  }

  List<_SymptomGroup> get _symptomGroups {
    List<_SymptomItem> items(
      List<String> labels,
      List<IconData> icons,
      List<Color> colors,
    ) {
      return [
        for (var index = 0; index < labels.length; index++)
          _SymptomItem(
            label: labels[index],
            icon: icons[index % icons.length],
            color: colors[index % colors.length],
          ),
      ];
    }

    return [
      _SymptomGroup(
        title: AppStrings.symptomOverall,
        items: items(
          AppStrings.symptomOverallOptions,
          [Icons.thumb_up_alt_outlined],
          [const Color(0xFFB8A6C9)],
        ),
      ),
      _SymptomGroup(
        title: AppStrings.symptomBody,
        items: items(
          AppStrings.symptomBodyOptions,
          [
            Icons.radio_button_checked_rounded,
            Icons.psychology_outlined,
            Icons.local_fire_department_outlined,
            Icons.air_rounded,
            Icons.auto_awesome_outlined,
            Icons.waves_rounded,
          ],
          [
            const Color(0xFFC0606E),
            const Color(0xFF8A72B0),
            const Color(0xFFD4835C),
            const Color(0xFF89986D),
            const Color(0xFFC48AA8),
            const Color(0xFF8FA88A),
          ],
        ),
      ),
      _SymptomGroup(
        title: AppStrings.symptomSkinHair,
        items: items(
          AppStrings.symptomSkinHairOptions,
          [
            Icons.water_drop_outlined,
            Icons.cloud_outlined,
            Icons.water_drop_outlined,
            Icons.content_cut_rounded,
          ],
          [
            const Color(0xFFC0606E),
            const Color(0xFFB8A6C9),
            const Color(0xFF89986D),
            const Color(0xFFA87960),
          ],
        ),
      ),
      _SymptomGroup(
        title: AppStrings.symptomEnergy,
        items: items(
          AppStrings.symptomEnergyOptions,
          [
            Icons.battery_2_bar_rounded,
            Icons.bolt_rounded,
            Icons.center_focus_strong_outlined,
            Icons.cloud_outlined,
          ],
          [
            const Color(0xFFC0606E),
            const Color(0xFFD4A15C),
            const Color(0xFF89986D),
            const Color(0xFF8A72B0),
          ],
        ),
      ),
      _SymptomGroup(
        title: AppStrings.symptomSleep,
        items: items(
          AppStrings.symptomSleepOptions,
          [Icons.dark_mode_outlined],
          [const Color(0xFF8A72B0)],
        ),
      ),
      _SymptomGroup(
        title: AppStrings.symptomDigestion,
        items: items(
          AppStrings.symptomDigestionOptions,
          [
            Icons.cookie_outlined,
            Icons.restaurant_outlined,
            Icons.waves_rounded,
            Icons.local_fire_department_outlined,
          ],
          [
            const Color(0xFFD4A15C),
            const Color(0xFFA87960),
            const Color(0xFF89986D),
            const Color(0xFFC0606E),
          ],
        ),
      ),
    ];
  }

  void _toggleSymptom(String label) {
    setState(() {
      if (_symptoms.contains(label)) {
        _symptoms.remove(label);
        _symptomSeverities.remove(label);
      } else {
        _symptoms.add(label);
        _symptomSeverities[label] = 2;
      }
    });
  }

  Widget _buildNutritionMedicationSection() {
    final summary =
        '${AppStrings.medications}: ${_medications.length}  •  '
        '${AppStrings.supplements}: ${_supplements.length}';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Color.lerp(AppColors.surface, _tone, 0.035),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _tone.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const ValueKey('medication_section_toggle'),
                    onTap: () => setState(
                      () => _medicationSectionExpanded =
                          !_medicationSectionExpanded,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 11, 8, 11),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: _tone.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.medication_outlined,
                              color: _tone,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.medicationAndSupplement,
                                  style: const TextStyle(
                                    fontFamily: 'CormorantGaramond',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  summary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: _medicationSectionExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _tone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 9),
                child: IconButton.filled(
                  tooltip: AppStrings.add,
                  onPressed: _showMedicationActions,
                  style: IconButton.styleFrom(
                    backgroundColor: _tone,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add_rounded),
                ),
              ),
            ],
          ),
          if (_medicationSectionExpanded) ...[
            Divider(height: 1, color: _tone.withValues(alpha: 0.18)),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: _buildNutritionMedicationDetails(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionMedicationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_medications.isEmpty && _supplements.isEmpty)
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: _tone, size: 19),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  AppStrings.medicationLogEmptyHint,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          )
        else ...[
          if (_medications.isNotEmpty)
            _buildMedicationGroup(
              title: AppStrings.medications,
              entries: _medications,
              icon: Icons.medication_outlined,
              groupKey: 'medication',
              itemType: MedicationPlanItemType.medication,
            ),
          if (_medications.isNotEmpty && _supplements.isNotEmpty)
            const SizedBox(height: 20),
          if (_supplements.isNotEmpty)
            _buildMedicationGroup(
              title: AppStrings.supplements,
              entries: _supplements,
              icon: Icons.spa_outlined,
              groupKey: 'supplement',
              itemType: MedicationPlanItemType.supplement,
            ),
          const SizedBox(height: 14),
          Text(
            AppStrings.medicationDisclaimer,
            style: const TextStyle(
              fontSize: 10,
              height: 1.4,
              color: AppColors.textHint,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showMedicationActions() async {
    final tone = _tone;
    final action = await showModalBottomSheet<_MedicationNutritionAction>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                child: _SectionTitle(AppStrings.medicationAndSupplement),
              ),
              ListTile(
                leading: Icon(Icons.medication_outlined, color: tone),
                title: Text(AppStrings.newMedication),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _MedicationNutritionAction.addMedication,
                ),
              ),
              ListTile(
                leading: Icon(Icons.spa_outlined, color: tone),
                title: Text(AppStrings.newSupplement),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _MedicationNutritionAction.addSupplement,
                ),
              ),
              ListTile(
                leading: Icon(Icons.add_alarm_rounded, color: tone),
                title: Text(AppStrings.createReminder),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _MedicationNutritionAction.manageReminders,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == null || !mounted) return;
    switch (action) {
      case _MedicationNutritionAction.addMedication:
        await _addMedicationOrSupplement(medication: true);
      case _MedicationNutritionAction.addSupplement:
        await _addMedicationOrSupplement(medication: false);
      case _MedicationNutritionAction.manageReminders:
        await _openReminderManager();
    }
  }

  Future<void> _addMedicationOrSupplement({required bool medication}) async {
    var customValue = '';
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          medication ? AppStrings.newMedication : AppStrings.newSupplement,
        ),
        content: TextField(
          autofocus: true,
          maxLength: 200,
          decoration: InputDecoration(
            labelText: medication
                ? AppStrings.medications
                : AppStrings.supplements,
            hintText: medication
                ? AppStrings.medicationExample
                : AppStrings.supplementExample,
          ),
          onChanged: (value) => customValue = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, customValue.trim()),
            style: FilledButton.styleFrom(backgroundColor: _tone),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty || !mounted) return;

    final entries = medication ? _medications : _supplements;
    final alreadyExists = entries.any(
      (entry) => entry.name.toLowerCase() == name.toLowerCase(),
    );
    if (alreadyExists) return;

    final storage = context.read<LocalStorageService>();
    final settings = storage.loadSettings() ?? widget.settings;
    if (medication) {
      await storage.saveCustomMedication(name);
      await storage.saveSettings(
        settings.copyWith(
          dailyMedications: {...settings.dailyMedications, name}.toList(),
        ),
      );
    } else {
      await storage.saveCustomSupplement(name);
      await storage.saveSettings(
        settings.copyWith(
          dailySupplements: {...settings.dailySupplements, name}.toList(),
        ),
      );
    }
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    setState(() {
      entries.add(
        MedicationEntry(
          name: name,
          time: AppStrings.medicationTimes.first,
          stomachState: AppStrings.stomachStates.first,
          doseCount: 1,
        ),
      );
      _medicationSectionExpanded = true;
    });
  }

  Future<void> _openReminderManager() {
    final storage = context.read<LocalStorageService>();
    final medicationNames = {
      ...widget.settings.dailyMedications,
      ...storage.getCustomMedications(),
      ..._medications.map((entry) => entry.name),
    }.toList();
    final supplementNames = {
      ...widget.settings.dailySupplements,
      ...storage.getCustomSupplements(),
      ..._supplements.map((entry) => entry.name),
    }.toList();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.6,
        maxChildSize: 0.96,
        expand: false,
        builder: (sheetContext, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
            children: [
              const _SheetHandle(),
              const SizedBox(height: 16),
              _SectionTitle(AppStrings.reminderPlans),
              const SizedBox(height: 16),
              _SectionTitle(AppStrings.medications),
              MedicationReminderSection(
                itemType: MedicationPlanItemType.medication,
                availableItems: medicationNames,
                color: _tone,
              ),
              const SizedBox(height: 24),
              _SectionTitle(AppStrings.supplements),
              MedicationReminderSection(
                itemType: MedicationPlanItemType.supplement,
                availableItems: supplementNames,
                color: _tone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationGroup({
    required String title,
    required List<MedicationEntry> entries,
    required IconData icon,
    required String groupKey,
    required MedicationPlanItemType itemType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        for (var index = 0; index < entries.length; index++) ...[
          _buildMedicationEntryCard(
            entry: entries[index],
            icon: icon,
            entryKey: '$groupKey:${entries[index].name.toLowerCase()}',
            itemType: itemType,
            onChanged: (updated) => setState(() => entries[index] = updated),
          ),
          if (index != entries.length - 1) const SizedBox(height: 7),
        ],
      ],
    );
  }

  Widget _buildMedicationEntryCard({
    required MedicationEntry entry,
    required IconData icon,
    required String entryKey,
    required MedicationPlanItemType itemType,
    required ValueChanged<MedicationEntry> onChanged,
  }) {
    final expanded = _expandedMedicationEntry == entryKey;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: expanded || entry.taken
              ? _tone.withValues(alpha: 0.55)
              : AppColors.outline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: ValueKey('medication_entry_$entryKey'),
                    onTap: () => setState(
                      () =>
                          _expandedMedicationEntry = expanded ? null : entryKey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(9, 8, 4, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _tone.withValues(alpha: 0.11),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 16, color: _tone),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'CormorantGaramond',
                                    fontSize: 16,
                                    height: 1.05,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${entry.time} · ${entry.dosage} · '
                                  '${entry.stomachState}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: _tone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                key: ValueKey('medication_reminder_$entryKey'),
                tooltip: AppStrings.createReminder,
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    _openItemReminder(entry: entry, itemType: itemType),
                icon: Icon(Icons.add_alarm_rounded, size: 19, color: _tone),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _tone.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${entry.takenDoseCount}/${entry.doseCount}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _tone,
                  ),
                ),
              ),
              const SizedBox(width: 7),
            ],
          ),
          if (expanded) ...[
            Divider(height: 1, color: _tone.withValues(alpha: 0.14)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.medicationTime.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      for (final time in AppStrings.medicationTimes)
                        _PillChoice(
                          key: ValueKey(
                            'medication_time_${entryKey}_${time.toLowerCase()}',
                          ),
                          label: time,
                          selected: entry.times.contains(time),
                          color: _tone,
                          onTap: () {
                            final times = {...entry.times};
                            if (!times.remove(time)) times.add(time);
                            if (times.isEmpty) times.add(time);
                            onChanged(entry.copyWith(times: times));
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.medicationDose,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _RoundButton(
                        key: ValueKey('dose_decrement_$entryKey'),
                        icon: Icons.remove_rounded,
                        color: _tone,
                        filled: false,
                        enabled: entry.doseCount > 1,
                        onTap: () => onChanged(
                          entry.copyWith(doseCount: entry.doseCount - 1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppStrings.dosageCount(entry.doseCount),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: _tone,
                          ),
                        ),
                      ),
                      _RoundButton(
                        key: ValueKey('dose_increment_$entryKey'),
                        icon: Icons.add_rounded,
                        color: _tone,
                        filled: true,
                        enabled: entry.doseCount < 12,
                        onTap: () => onChanged(
                          entry.copyWith(doseCount: entry.doseCount + 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDoseCircles(entry, onChanged),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.medicationStomachState.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    children: [
                      for (final state in AppStrings.stomachStates)
                        _PillChoice(
                          label: state,
                          selected: entry.stomachState == state,
                          color: _tone,
                          onTap: () =>
                              onChanged(entry.copyWith(stomachState: state)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDoseCircles(
    MedicationEntry entry,
    ValueChanged<MedicationEntry> onChanged,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < entry.doseCount; index++)
          Tooltip(
            message: AppStrings.dosageCount(index + 1),
            child: InkWell(
              key: ValueKey('dose_circle_${entry.name}_$index'),
              customBorder: const CircleBorder(),
              onTap: () {
                final next = index < entry.takenDoseCount ? index : index + 1;
                onChanged(entry.copyWith(takenDoseCount: next));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < entry.takenDoseCount
                      ? _tone
                      : _tone.withValues(alpha: 0.08),
                  border: Border.all(
                    color: _tone.withValues(
                      alpha: index < entry.takenDoseCount ? 1 : 0.42,
                    ),
                  ),
                ),
                child: index < entry.takenDoseCount
                    ? const Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openItemReminder({
    required MedicationEntry entry,
    required MedicationPlanItemType itemType,
  }) async {
    final baseTheme = Theme.of(context);
    final plan = await showModalBottomSheet<MedicationReminderPlan>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      builder: (_) => Theme(
        data: baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(primary: _tone),
        ),
        child: MedicationReminderFormSheet(
          itemType: itemType,
          availableItems: [entry.name],
          initialItemName: entry.name,
          initialDosage: entry.dosage,
        ),
      ),
    );
    if (plan == null || !mounted) return;

    final message = await saveMedicationReminderPlan(
      storage: context.read<LocalStorageService>(),
      notifications: context.read<NotificationService>(),
      plan: plan,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildMoodPage() {
    final tone = _moodColors[_moodIndex];
    return Column(
      children: [
        _buildIntro(
          title: AppStrings.logMoodQuestion,
          subtitle: AppStrings.logMoodHint,
          centered: true,
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: 236,
          height: 236,
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
                    border: Border.all(color: tone.withValues(alpha: 0.48)),
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
                    border: Border.all(color: tone.withValues(alpha: 0.6)),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 164,
                height: 164,
                decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    AppStrings.moodCheckInEmojis[_moodIndex],
                    style: const TextStyle(fontSize: 58),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.moodCheckInOptions[_moodIndex],
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 29,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 28),
        _StepSelector(
          labels: AppStrings.moodCheckInOptions,
          selectedIndex: _moodIndex,
          color: tone,
          onChanged: (index) => setState(() => _moodIndex = index),
        ),
      ],
    );
  }

  List<Color> get _moodColors => const [
    Color(0xFFB7A5C9),
    Color(0xFFE1A6A8),
    Color(0xFFC8BFAE),
    Color(0xFFA8B892),
    Color(0xFF8FA982),
  ];

  Widget _buildMoodContextPage() {
    final mood = AppStrings.moodCheckInOptions[_moodIndex].toLowerCase();
    return Column(
      children: [
        _buildIntro(
          title: AppStrings.moodBehindQuestion(mood),
          subtitle: AppStrings.moodContextHint,
          centered: true,
        ),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: AppColors.primaryLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.omaNote,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.moodGentleTitle,
                style: const TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppStrings.moodGentleBody,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: _SectionTitle(AppStrings.moodWhoWith),
        ),
        const SizedBox(height: 11),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildContextChoices(
            options: AppStrings.moodCompanionOptions,
            selected: _moodCompanions,
            companion: true,
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: _SectionTitle(AppStrings.moodWhere),
        ),
        const SizedBox(height: 11),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildContextChoices(
            options: AppStrings.moodPlaceOptions,
            selected: _moodPlaces,
            companion: false,
          ),
        ),
      ],
    );
  }

  Widget _buildContextChoices({
    required List<String> options,
    required Set<String> selected,
    required bool companion,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          _PillChoice(
            label: option,
            selected: selected.contains(option),
            color: AppColors.primary,
            onTap: () => _toggleChoice(selected, option),
          ),
        for (final option in selected.where(
          (value) => !options.contains(value),
        ))
          _PillChoice(
            label: option,
            selected: true,
            color: AppColors.primary,
            onTap: () => _toggleChoice(selected, option),
          ),
        _RoundButton(
          key: ValueKey(companion ? 'mood_companion_add' : 'mood_place_add'),
          icon: Icons.add_rounded,
          color: AppColors.primary,
          filled: false,
          enabled: true,
          onTap: () => _addCustomContext(companion),
        ),
      ],
    );
  }

  Future<void> _addCustomContext(bool companion) async {
    var customValue = '';
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          companion ? AppStrings.moodWhoWith : AppStrings.moodWhere,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          autofocus: true,
          maxLength: 120,
          onChanged: (value) => customValue = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, customValue.trim()),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
    if (!mounted || value == null || value.isEmpty) return;
    setState(() {
      (companion ? _moodCompanions : _moodPlaces).add(value);
    });
  }

  Widget _buildSimpleChoices({
    required List<String> options,
    required Set<String> selected,
    required Color color,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          _PillChoice(
            label: option,
            selected: selected.contains(option),
            color: color,
            onTap: () => _toggleChoice(selected, option),
          ),
      ],
    );
  }

  void _toggleChoice(Set<String> values, String value) {
    setState(() {
      if (values.contains(value)) {
        values.remove(value);
      } else {
        values.add(value);
      }
    });
  }

  bool _supportsMealQuality(String meal) =>
      AppStrings.nutritionMealOptions.take(3).contains(meal);

  void _toggleMeal(String meal) {
    setState(() {
      if (_meals.remove(meal)) {
        _mealQualityIndices.remove(meal);
        _mealFoodGroups.remove(meal);
      } else {
        _meals.add(meal);
      }
    });
  }

  String? get _legacyNutritionQuality {
    final selectedValues = _mealQualityIndices.entries
        .where((entry) => _meals.contains(entry.key))
        .map((entry) => entry.value)
        .toSet();
    if (selectedValues.length != 1) return null;
    return AppStrings.nutritionQualityOptions[selectedValues.single];
  }

  Widget _buildMealDetails(String meal) {
    final mealIndex = AppStrings.nutritionMealOptions.indexOf(meal);
    final selectedFoods = _mealFoodGroups.putIfAbsent(meal, () => <String>{});
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          if (_supportsMealQuality(meal)) ...[
            const SizedBox(height: 9),
            Row(
              children: [
                for (final quality
                    in AppStrings.nutritionQualityOptions.asMap().entries) ...[
                  if (quality.key > 0) const SizedBox(width: 5),
                  Expanded(
                    child: _PillChoice(
                      key: ValueKey('meal_quality_${mealIndex}_${quality.key}'),
                      label: quality.value,
                      selected: _mealQualityIndices[meal] == quality.key,
                      color: AppColors.secondary,
                      onTap: () => setState(() {
                        if (_mealQualityIndices[meal] == quality.key) {
                          _mealQualityIndices.remove(meal);
                        } else {
                          _mealQualityIndices[meal] = quality.key;
                        }
                      }),
                    ),
                  ),
                ],
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 11),
            child: Divider(height: 1, color: AppColors.outline),
          ),
          Text(
            AppStrings.whatDidYouEat.toUpperCase(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final food
                  in AppStrings.nutritionFoodGroupOptions.asMap().entries)
                _PillChoice(
                  key: ValueKey('meal_food_${mealIndex}_${food.key}'),
                  label: food.value,
                  selected: selectedFoods.contains(food.value),
                  color: AppColors.secondary,
                  onTap: () => _toggleChoice(selectedFoods, food.value),
                ),
              for (final food in selectedFoods.where(
                (value) =>
                    !AppStrings.nutritionFoodGroupOptions.contains(value),
              ))
                _PillChoice(
                  label: food,
                  selected: true,
                  color: AppColors.secondary,
                  onTap: () => _toggleChoice(selectedFoods, food),
                ),
              _RoundButton(
                key: ValueKey('meal_food_add_$mealIndex'),
                icon: Icons.add_rounded,
                color: AppColors.secondary,
                filled: false,
                enabled: true,
                onTap: () => _addCustomFoodGroup(meal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addCustomFoodGroup(String meal) async {
    var customValue = '';
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.whatDidYouEat),
        content: TextField(
          autofocus: true,
          maxLength: 120,
          onChanged: (text) => customValue = text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, customValue.trim()),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
    if (!mounted || value == null || value.isEmpty) return;
    setState(() {
      _mealFoodGroups.putIfAbsent(meal, () => <String>{}).add(value);
    });
  }

  Widget _buildBottomAction() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 9),
        color: AppColors.scaffoldBackground.withValues(alpha: 0.97),
        child: SizedBox(
          width: double.infinity,
          height: 57,
          child: FilledButton(
            onPressed: _isSaving ? null : _handleAction,
            style: FilledButton.styleFrom(
              backgroundColor: _tone,
              foregroundColor: Colors.white,
              disabledBackgroundColor: _tone.withValues(alpha: 0.6),
              shape: const StadiumBorder(),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.3,
                    ),
                  )
                : Text(
                    _actionLabel,
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAction() async {
    if (_logType == 3 && _moodStep == 1) {
      setState(() => _moodStep = 2);
      return;
    }
    await _saveLog();
  }

  Future<void> _promptSavePeriodAndOpenSymptoms() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.savePeriodBeforeSymptomsTitle),
        content: Text(AppStrings.savePeriodBeforeSymptomsBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.saveAndContinue),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final saved = await _saveLog(closeSheet: false);
    if (!saved || !mounted) return;
    setState(() => _logType = 2);
  }

  DailyLog _preparedLog(DateTime finalDate, {required bool hasExplicitTime}) {
    final observed = <DailyLogObservedSection>{
      ..._log.observedSections,
      switch (_logType) {
        0 => DailyLogObservedSection.period,
        1 => DailyLogObservedSection.nutrition,
        2 => DailyLogObservedSection.symptom,
        _ => DailyLogObservedSection.wellbeing,
      },
    };
    if (_logType == 1 && (_medications.isNotEmpty || _supplements.isNotEmpty)) {
      observed.add(DailyLogObservedSection.medication);
    }
    final selectedSymptomSeverities = {
      for (final symptom in _symptoms)
        symptom: _symptomSeverities[symptom] ?? 2,
    };
    final overallSymptomSeverity = selectedSymptomSeverities.isEmpty
        ? null
        : (selectedSymptomSeverities.values.reduce((a, b) => a + b) /
                  selectedSymptomSeverities.length)
              .round();

    return switch (_logType) {
      0 => _log.copyWith(
        date: finalDate,
        hasExplicitTime: hasExplicitTime,
        flowIntensity: AppStrings.flowOptions[_flowIndex],
        symptoms: _periodSymptoms.toList(),
        painLocations: _matchingPainLocations(_periodSymptoms),
        observedSections: observed,
      ),
      1 => _log.copyWith(
        date: finalDate,
        hasExplicitTime: hasExplicitTime,
        waterIntakeMl: _waterGlasses * 250,
        mealTypes: _meals.toList(),
        mealQualities: {
          for (final entry in _mealQualityIndices.entries)
            if (_meals.contains(entry.key))
              entry.key: AppStrings.nutritionQualityOptions[entry.value],
        },
        mealFoodGroups: {
          for (final entry in _mealFoodGroups.entries)
            if (_meals.contains(entry.key) && entry.value.isNotEmpty)
              entry.key: entry.value.toList(),
        },
        postMealFeelings: _postMealFeelings.toList(),
        nutritionQuality: _legacyNutritionQuality,
        clearNutritionQuality: _legacyNutritionQuality == null,
        cravings: _cravings.toList(),
        medications: _medications,
        supplements: _supplements,
        observedSections: observed,
      ),
      2 => _log.copyWith(
        date: finalDate,
        hasExplicitTime: hasExplicitTime,
        symptoms: _symptoms.toList(),
        symptomSeverity: overallSymptomSeverity,
        clearSymptomSeverity: overallSymptomSeverity == null,
        symptomSeverities: selectedSymptomSeverities,
        painLocations: _matchingPainLocations(_symptoms),
        sexualActivity: _sexualActivity,
        clearSexualActivity: _sexualActivity == null,
        sexualActivityTypes: _sexualActivityTypes,
        vaginalDischargePresent: _vaginalDischargePresent,
        vaginalDischargeColor: _vaginalDischargeColor,
        clearVaginalDischargeColor: _vaginalDischargePresent != true,
        vaginalDischargeConsistency: _vaginalDischargeConsistency,
        clearVaginalDischargeConsistency: _vaginalDischargePresent != true,
        vaginalDischargeAmount: _vaginalDischargeAmount,
        clearVaginalDischargeAmount: _vaginalDischargePresent != true,
        vaginalDischargeSymptoms: _vaginalDischargePresent == true
            ? _vaginalDischargeSymptoms
            : const {},
        dreamRemembered: _dreamRemembered,
        clearDreamRemembered: _dreamRemembered == null,
        dreamNote: _dreamNoteController.text.trim().isEmpty
            ? null
            : _dreamNoteController.text.trim(),
        clearDreamNote:
            _dreamRemembered != true ||
            _dreamNoteController.text.trim().isEmpty,
        observedSections: observed,
      ),
      _ => _log.copyWith(
        date: finalDate,
        hasExplicitTime: hasExplicitTime,
        mood: AppStrings.moodCheckInOptions[_moodIndex],
        moodEmoji: AppStrings.moodCheckInEmojis[_moodIndex],
        moodCompanions: _moodCompanions.toList(),
        moodPlaces: _moodPlaces.toList(),
        observedSections: observed,
      ),
    };
  }

  List<String> _matchingPainLocations(Set<String> selected) {
    final painOptions = AppStrings.painLocations;
    return selected.where((value) {
      final canonical = AppStrings.canonicalizeStoredValue(value);
      return painOptions.any(
        (pain) => AppStrings.canonicalizeStoredValue(pain) == canonical,
      );
    }).toList();
  }

  Future<bool> _saveLog({bool closeSheet = true}) async {
    final today = AppTime.now.dateOnly;
    if (_log.date.dateOnly.isAfter(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.futureLogNotAllowed),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    var finalDate = _log.date;
    var hasExplicitTime = _log.hasExplicitTime;
    if (_log.date.dateOnly.isBefore(today)) {
      final choice = await _choosePastLogTime();
      if (choice == null) return false;
      if (choice == _PastLogTimeChoice.withTime) {
        if (!mounted) return false;
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_log.date),
          helpText: AppStrings.selectLogTime,
        );
        if (pickedTime == null) return false;
        finalDate = DateTime(
          _log.date.year,
          _log.date.month,
          _log.date.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        hasExplicitTime = true;
      } else {
        if (!_log.hasData) {
          finalDate = _log.date.dateOnly;
        }
        hasExplicitTime = false;
      }
    }

    setState(() => _isSaving = true);
    final preparedLog = _preparedLog(
      finalDate,
      hasExplicitTime: hasExplicitTime,
    );
    var success = false;
    try {
      success = await widget.onSave(preparedLog);
    } catch (_) {
      success = false;
    }
    if (!mounted) return false;
    setState(() => _isSaving = false);

    if (success) {
      _log = preparedLog;
      final messenger = ScaffoldMessenger.of(context);
      if (closeSheet) Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(AppStrings.saved),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.logSaveFailed),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
  }

  Future<_PastLogTimeChoice?> _choosePastLogTime() {
    return showDialog<_PastLogTimeChoice>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.pastLogTimeQuestion),
        content: Text(AppStrings.pastLogTimeHint),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, _PastLogTimeChoice.withoutTime),
            child: Text(AppStrings.saveWithoutTime),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, _PastLogTimeChoice.withTime),
            child: Text(AppStrings.addTime),
          ),
        ],
      ),
    );
  }
}

enum _PastLogTimeChoice { withTime, withoutTime }

enum _MedicationNutritionAction {
  addMedication,
  addSupplement,
  manageReminders,
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.outline,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'CormorantGaramond',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _PillChoice extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _PillChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color : AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: selected ? color : AppColors.outline),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool filled;
  final bool enabled;
  final VoidCallback onTap;

  const _RoundButton({
    super.key,
    required this.icon,
    required this.color,
    required this.filled,
    required this.enabled,
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
              size: 18,
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
    return Column(
      children: [
        Row(
          children: labels.asMap().entries.map((entry) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(entry.key),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: entry.key == selectedIndex
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color: entry.key == selectedIndex
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.18),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.1),
            trackHeight: 7,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
          ),
          child: Slider(
            value: selectedIndex.toDouble(),
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

class _SymptomGroup {
  final String title;
  final List<_SymptomItem> items;

  const _SymptomGroup({required this.title, required this.items});
}

class _SymptomItem {
  final String label;
  final IconData icon;
  final Color color;

  const _SymptomItem({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class _SymptomTile extends StatelessWidget {
  final _SymptomItem item;
  final bool selected;
  final int severity;
  final VoidCallback onTap;
  final ValueChanged<int> onSeverityChanged;

  const _SymptomTile({
    required this.item,
    required this.selected,
    required this.severity,
    required this.onTap,
    required this.onSeverityChanged,
  });

  @override
  Widget build(BuildContext context) {
    const tone = AppColors.secondaryDark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 44,
          decoration: BoxDecoration(
            color: selected
                ? tone.withValues(alpha: 0.13)
                : AppColors.scaffoldBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? tone : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 4, 8, 4),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: selected
                            ? tone.withValues(alpha: 0.15)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: selected ? tone : AppColors.textHint,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle_rounded, color: tone, size: 17),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (selected)
          SizedBox(
            height: 29,
            child: Semantics(
              label: '${item.label} · ${AppStrings.symptomStrength}',
              value: AppStrings.symptomSeverityOptions[severity - 1],
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  activeTrackColor: tone,
                  inactiveTrackColor: tone.withValues(alpha: 0.18),
                  thumbColor: tone,
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 5.5,
                  ),
                  activeTickMarkColor: Colors.white,
                  inactiveTickMarkColor: tone.withValues(alpha: 0.42),
                ),
                child: Slider(
                  key: ValueKey('symptom_severity_${item.label}'),
                  value: severity.toDouble(),
                  min: 1,
                  max: 3,
                  divisions: 2,
                  label: AppStrings.symptomSeverityOptions[severity - 1],
                  onChanged: (value) => onSeverityChanged(value.round()),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TrackingChoiceTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TrackingChoiceTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 46,
      decoration: BoxDecoration(
        color: selected
            ? color.withValues(alpha: 0.13)
            : AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? color : AppColors.outline,
          width: selected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? color : AppColors.textHint,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: selected ? color : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (selected) Icon(Icons.check_rounded, size: 16, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
