import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/core/utils/app_time.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/core/utils/pregnancy_calculator.dart';
import 'package:app_proje_a/features/tracking/domain/models/daily_log.dart';
import 'package:app_proje_a/features/tracking/domain/models/tracking_section.dart';
import 'package:app_proje_a/features/tracking/application/daily_log_draft.dart';
import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/models/medication_identity_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/notification_service.dart';
import 'package:app_proje_a/core/widgets/oma_toast.dart';
import 'widgets/medication_reminder_section.dart';
import 'widgets/tracking_catalog_selector.dart';
import 'package:app_proje_a/views/articles/widgets/premium_paywall.dart';

part 'sections/period_section.dart';
part 'sections/nutrition_section.dart';
part 'sections/symptoms_section.dart';
part 'sections/wellbeing_section.dart';
part 'sections/medication_section.dart';
part 'sections/skincare_section.dart';

class DailyLogSheet extends StatefulWidget {
  final DailyLog initialLog;
  final UserSettings settings;
  final Future<bool> Function(DailyLog) onSave;
  final Future<bool> Function(DateTime)? onDeletePeriod;
  final Future<void> Function()? onSettingsChanged;
  final int initialTabIndex;
  final TrackingSection? initialSection;
  final bool isSingleTab;
  final Color themeColor;

  const DailyLogSheet({
    super.key,
    required this.initialLog,
    required this.settings,
    required this.onSave,
    this.onDeletePeriod,
    this.onSettingsChanged,
    this.initialTabIndex = 0,
    this.initialSection,
    this.isSingleTab = false,
    this.themeColor = AppColors.primary,
  });

  @override
  State<DailyLogSheet> createState() => _DailyLogSheetState();
}

class _DailyLogSheetState extends State<DailyLogSheet> {
  void _mutate(VoidCallback change) => setState(change);

  late DailyLog _log;
  late TrackingSection _section;
  var _isSaving = false;

  late int _flowIndex;

  late int _waterGlasses;
  late Set<String> _meals;
  late List<String> _mealSlots;
  late Set<String> _expandedMeals;
  late Map<String, int> _mealQualityIndices;
  late Map<String, Set<String>> _mealFoodGroups;
  late Map<String, Set<String>> _mealPostFeelings;
  late Set<String> _cravings;
  late List<String> _customCravings;

  final _symptomSearchController = TextEditingController();
  late Set<String> _symptoms;
  late Map<String, int> _symptomSeverities;
  late Map<CustomSymptomGroup, List<String>> _customSymptoms;
  late bool? _sexualActivity;
  late Set<SexualActivityType> _sexualActivityTypes;
  late Set<SexualAfterFeeling> _sexualAfterFeelings;
  late bool? _vaginalDischargePresent;
  late VaginalDischargeColor? _vaginalDischargeColor;
  late VaginalDischargeConsistency? _vaginalDischargeConsistency;
  late VaginalDischargeAmount? _vaginalDischargeAmount;
  late Set<VaginalDischargeSymptom> _vaginalDischargeSymptoms;
  late bool? _dreamRemembered;
  late DreamType? _dreamType;
  final _dreamNoteController = TextEditingController();

  late List<MedicationEntry> _medications;
  late List<MedicationEntry> _supplements;
  late Set<String> _skincare;
  late List<String> _skincareSuggestions;
  var _medicationSectionExpanded = false;
  String? _expandedMedicationEntry;

  late int _moodIndex;
  var _moodStep = 1;
  late Set<String> _moodCompanions;
  late Set<String> _moodPlaces;
  late List<String> _customMoodCompanions;
  late List<String> _customMoodPlaces;

  @override
  void initState() {
    super.initState();
    _log = widget.initialLog;
    _section =
        widget.initialSection ??
        TrackingSection.fromTabIndex(widget.initialTabIndex);
    final persistedSettings =
        context.read<LocalStorageService>().loadSettings() ?? widget.settings;

    _flowIndex = _localizedIndex(
      AppStrings.flowOptions,
      _log.flowIntensity,
      fallback: 2,
    );
    _waterGlasses = _log.waterIntakeMl == null
        ? 0
        : (_log.waterIntakeMl! / 250).round().clamp(0, 12);
    _meals = _localizedSet(_log.mealTypes, AppStrings.nutritionMealOptions);
    _meals.addAll(
      _log.mealTypes.where(
        (meal) => !AppStrings.nutritionMealOptions.contains(meal),
      ),
    );
    _mealSlots = [
      ...AppStrings.nutritionMealOptions,
      ..._meals.where(
        (meal) => !AppStrings.nutritionMealOptions.contains(meal),
      ),
    ];
    _expandedMeals = <String>{};
    _mealQualityIndices = {
      for (final entry in _log.mealQualities.entries)
        AppStrings.localizeStoredValue(entry.key): _localizedIndex(
          AppStrings.nutritionQualityOptions,
          entry.value,
          fallback: 1,
        ),
    };
    _mealFoodGroups = {
      for (final entry in _log.mealFoodGroups.entries)
        AppStrings.localizeStoredValue(entry.key): entry.value
            .map(AppStrings.localizeStoredValue)
            .toSet(),
    };
    _mealPostFeelings = {
      for (final entry in _log.mealPostFeelings.entries)
        AppStrings.localizeStoredValue(entry.key): entry.value
            .map(AppStrings.localizeStoredValue)
            .toSet(),
    };
    _cravings = _localizedSetPreservingCustom(
      _log.cravings,
      AppStrings.nutritionCravingOptions,
    );
    _customCravings = List<String>.from(persistedSettings.customCravings);

    _customSymptoms = {
      for (final group in CustomSymptomGroup.values)
        group: _uniqueCustomLabels(persistedSettings.customSymptomsFor(group)),
    };
    _symptoms = _localizedSetPreservingCustom(
      _log.symptoms,
      _allSymptomOptions,
    );
    final knownCustomSymptoms = _customSymptoms.values
        .expand((values) => values)
        .toList(growable: false);
    final uncategorizedSymptoms = _symptoms.where(
      (value) =>
          !_allSymptomOptions.any(
            (option) => _sameCustomLabel(option, value),
          ) &&
          !knownCustomSymptoms.any((option) => _sameCustomLabel(option, value)),
    );
    _customSymptoms[CustomSymptomGroup.body] = _uniqueCustomLabels([
      ..._customSymptoms[CustomSymptomGroup.body]!,
      ...uncategorizedSymptoms,
    ]);
    _symptomSeverities = {
      for (final rawSymptom in _log.symptoms)
        AppStrings.localizeStoredValue(rawSymptom):
            _log.symptomSeverities[rawSymptom] ??
            _log.symptomSeverities[AppStrings.localizeStoredValue(
              rawSymptom,
            )] ??
            2,
    };
    _sexualActivity = _log.sexualActivity;
    _sexualActivityTypes = {..._log.sexualActivityTypes};
    _sexualAfterFeelings = {..._log.sexualAfterFeelings};
    if (_sexualActivity == false && _sexualActivityTypes.isEmpty) {
      _sexualActivityTypes.add(SexualActivityType.none);
    }
    _vaginalDischargePresent = _log.vaginalDischargePresent;
    _vaginalDischargeColor = _log.vaginalDischargeColor;
    _vaginalDischargeConsistency = _log.vaginalDischargeConsistency;
    _vaginalDischargeAmount = _log.vaginalDischargeAmount;
    _vaginalDischargeSymptoms = {..._log.vaginalDischargeSymptoms};
    _dreamRemembered = _log.dreamRemembered;
    _dreamType = _log.dreamType;
    _dreamNoteController.text = _log.dreamNote ?? '';

    _medications = _initialMedicationEntries(_log.medications);
    _supplements = _initialMedicationEntries(_log.supplements);
    final storage = context.read<LocalStorageService>();
    _skincare = _uniqueCustomLabels(
      _log.skincare.map(AppStrings.localizeStoredValue),
    ).toSet();
    _skincareSuggestions = _uniqueCustomLabels([
      for (final log in storage.loadAllLogs())
        ...log.skincare.map(AppStrings.localizeStoredValue),
      ...persistedSettings.dailySkincare.map(AppStrings.localizeStoredValue),
      ...storage.getCustomSkincare().map(AppStrings.localizeStoredValue),
    ]);

    _moodIndex = _localizedIndex(
      AppStrings.moodCheckInOptions,
      _log.mood,
      fallback: 1,
    );
    _moodCompanions = _localizedSetPreservingCustom(
      _log.moodCompanions,
      AppStrings.moodCompanionOptions,
    );
    _moodPlaces = _localizedSetPreservingCustom(
      _log.moodPlaces,
      AppStrings.moodPlaceOptions,
    );
    _customMoodCompanions = List<String>.from(
      persistedSettings.customMoodCompanions,
    );
    _customMoodPlaces = List<String>.from(persistedSettings.customMoodPlaces);
  }

  @override
  void dispose() {
    _symptomSearchController.dispose();
    _dreamNoteController.dispose();
    super.dispose();
  }

  List<String> get _allSymptomOptions => AppStrings.allSymptomOptions;

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

  Set<String> _localizedSetPreservingCustom(
    List<String> values,
    List<String> options,
  ) {
    final result = <String>{};
    for (final value in values) {
      final localized = AppStrings.localizeStoredValue(value).trim();
      if (localized.isNotEmpty) result.add(localized);
    }
    return result;
  }

  List<MedicationEntry> _initialMedicationEntries(List<MedicationEntry> saved) {
    final entries = <String, MedicationEntry>{};
    for (final entry in saved) {
      final displayName = AppStrings.localizeStoredValue(entry.displayName);
      entries[AppStrings.canonicalizeStoredValue(displayName)] = entry.copyWith(
        displayName: displayName,
        mainGroup: AppStrings.localizeStoredValue(entry.mainGroup),
        activeIngredient: entry.activeIngredient == null
            ? null
            : AppStrings.localizeStoredValue(entry.activeIngredient!),
        times: entry.times.map(AppStrings.localizeStoredValue).toSet(),
        stomachState: AppStrings.localizeStoredValue(entry.stomachState),
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

  Color get _tone => switch (_section) {
    TrackingSection.period => AppColors.periodPrimary,
    _ => widget.themeColor,
  };

  bool get _isMoodContext =>
      _section == TrackingSection.wellbeing && _moodStep == 2;

  String get _actionLabel {
    if (_section == TrackingSection.wellbeing && _moodStep == 1) {
      return AppStrings.continueAction;
    }
    return switch (_section) {
      TrackingSection.period => AppStrings.savePeriod,
      TrackingSection.nutrition => AppStrings.saveNutrition,
      TrackingSection.symptoms => AppStrings.save,
      TrackingSection.wellbeing => AppStrings.saveMoment,
      TrackingSection.medication => AppStrings.saveMedicationAndSupplement,
      TrackingSection.skincare => AppStrings.saveSkincare,
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
                    key: ValueKey('${_section.name}-$_moodStep'),
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
              '${AppStrings.cycleDay(_cycleDay).toUpperCase()}'
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
    return switch (_section) {
      TrackingSection.period => _buildPeriodPage(),
      TrackingSection.nutrition => _buildNutritionPage(),
      TrackingSection.symptoms => _buildSymptomPage(),
      TrackingSection.wellbeing =>
        _moodStep == 1 ? _buildMoodPage() : _buildMoodContextPage(),
      TrackingSection.medication => _buildMedicationAndSupplementCatalogPage(),
      TrackingSection.skincare => _buildSkincarePage(),
    };
  }

  Widget _buildIntro({
    required String title,
    String? subtitle,
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
        if (subtitle != null) ...[
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
      ],
    );
  }

  Future<String?> _promptCustomCatalogItem(String title, {String? hintText}) {
    var value = '';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          maxLength: 120,
          decoration: InputDecoration(hintText: hintText),
          onChanged: (text) => value = text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, value.trim()),
            style: FilledButton.styleFrom(backgroundColor: _tone),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element

  // Kept only to migrate drafts created by pre-catalog app versions.
  // ignore: unused_element

  TimeOfDay _suggestMedicationClockTime(Set<String> times) {
    final parsed = times
        .map(_reminderTimeForMedicationValue)
        .whereType<TimeOfDay>()
        .toList();
    if (parsed.isEmpty) return const TimeOfDay(hour: 9, minute: 0);
    final last = parsed.last;
    return TimeOfDay(hour: (last.hour + 6) % 24, minute: last.minute);
  }

  TimeOfDay? _parseClockTime(String value) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(value);
    if (match == null) return null;
    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || minute == null || hour > 23 || minute > 59) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay? _reminderTimeForMedicationValue(String value) {
    final parsed = _parseClockTime(value);
    if (parsed != null) return parsed;
    final index = AppStrings.medicationTimes.indexOf(value);
    return switch (index) {
      0 => const TimeOfDay(hour: 9, minute: 0),
      1 => const TimeOfDay(hour: 13, minute: 0),
      2 => const TimeOfDay(hour: 20, minute: 0),
      _ => null,
    };
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
    if (_section == TrackingSection.wellbeing && _moodStep == 1) {
      setState(() => _moodStep = 2);
      return;
    }
    await _saveLog();
  }

  DailyLog _preparedLog(DateTime finalDate, {required bool hasExplicitTime}) {
    return _currentDraft().apply(
      _log,
      date: finalDate,
      hasExplicitTime: hasExplicitTime,
    );
  }

  DailyLogDraft _currentDraft() {
    final selectedSymptomSeverities = {
      for (final symptom in _symptoms)
        symptom: _symptomSeverities[symptom] ?? 2,
    };
    return switch (_section) {
      TrackingSection.period => PeriodLogDraft(
        flowIntensity: AppStrings.flowOptions[_flowIndex],
        symptoms: _symptoms.toList(),
        symptomSeverities: selectedSymptomSeverities,
      ),
      TrackingSection.nutrition => NutritionLogDraft(
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
        mealPostFeelings: {
          for (final entry in _mealPostFeelings.entries)
            if (_meals.contains(entry.key) && entry.value.isNotEmpty)
              entry.key: entry.value.toList(),
        },
        cravings: _cravings.toList(),
      ),
      TrackingSection.symptoms => SymptomsLogDraft(
        symptoms: _symptoms.toList(),
        symptomSeverities: selectedSymptomSeverities,
        sexualActivity: _sexualActivity,
        sexualActivityTypes: _sexualActivityTypes,
        sexualAfterFeelings: _sexualAfterFeelings,
        vaginalDischargePresent: _vaginalDischargePresent,
        vaginalDischargeColor: _vaginalDischargeColor,
        vaginalDischargeConsistency: _vaginalDischargeConsistency,
        vaginalDischargeAmount: _vaginalDischargeAmount,
        vaginalDischargeSymptoms: _vaginalDischargeSymptoms,
        dreamRemembered: _dreamRemembered,
        dreamType: _dreamType,
        dreamNote: _dreamNoteController.text.trim().isEmpty
            ? null
            : _dreamNoteController.text.trim(),
      ),
      TrackingSection.wellbeing => WellbeingLogDraft(
        mood: AppStrings.moodCheckInOptions[_moodIndex],
        moodEmoji: AppStrings.moodCheckInEmojis[_moodIndex],
        moodCompanions: _moodCompanions.toList(),
        moodPlaces: _moodPlaces.toList(),
      ),
      TrackingSection.medication => MedicationLogDraft(
        medications: _medications,
        supplements: _supplements,
      ),
      TrackingSection.skincare => SkincareLogDraft(
        skincare: _skincare.toList(),
      ),
    };
  }

  Future<bool> _saveLog({bool closeSheet = true}) async {
    final today = AppTime.now.dateOnly;
    if (_log.date.dateOnly.isAfter(today)) {
      OmaToast.show(
        context,
        title: AppStrings.error,
        description: AppStrings.futureLogNotAllowed,
        icon: Icons.error_outline_rounded,
      );
      return false;
    }
    var finalDate = _log.date;
    var hasExplicitTime = _log.hasExplicitTime;
    if (_log.date.dateOnly.isBefore(today)) {
      // Geçmiş gün için yeni kayıtlar saat sormadan gün başlangıcına yazılır.
      // Eski sürümden kalan saatli bir kayıt düzenleniyorsa farklı timestamp'te
      // kopya oluşturmamak için mevcut anahtar korunur.
      if (!_log.hasData) finalDate = _log.date.dateOnly;
      hasExplicitTime = false;
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
      if (_section == TrackingSection.medication) {
        await _persistStructuredMedicationSelections();
        if (!mounted) return true;
      }
      OmaToast.show(context, title: AppStrings.dailyLogSaved);
      final savedDream =
          _section == TrackingSection.symptoms &&
          _dreamRemembered == true &&
          _dreamNoteController.text.trim().isNotEmpty;
      if (savedDream) {
        await _showDreamPremiumOffer();
        if (!mounted) return true;
      }
      if (closeSheet) Navigator.pop(context);
      return true;
    } else {
      OmaToast.show(
        context,
        title: AppStrings.error,
        description: AppStrings.logSaveFailed,
        icon: Icons.error_outline_rounded,
      );
      return false;
    }
  }

  bool _sameCustomLabel(String left, String right) =>
      AppStrings.canonicalizeStoredValue(left) ==
          AppStrings.canonicalizeStoredValue(right) ||
      _normalizeCustomLabel(left) == _normalizeCustomLabel(right);

  String _normalizeCustomLabel(String value) => value
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp('[İIı]'), 'i')
      .toLowerCase();

  List<String> _uniqueCustomLabels(Iterable<String> values) {
    final result = <String>[];
    final seen = <String>{};
    for (final raw in values) {
      final value = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (value.isNotEmpty &&
          seen.add(AppStrings.canonicalizeStoredValue(value))) {
        result.add(value);
      }
    }
    return result;
  }

  List<String> _withCanonicalLabel(Iterable<String> values, String canonical) =>
      _uniqueCustomLabels([...values, canonical]);

  List<MedicationIdentity> _withCanonicalMedication(
    Iterable<MedicationIdentity> values,
    MedicationIdentity canonical,
  ) {
    String key(MedicationIdentity value) => [
      value.displayName,
      value.mainGroup,
      value.activeIngredient ?? '',
    ].map(_normalizeCustomLabel).join('\u0000');
    final canonicalKey = key(canonical);
    return [...values.where((value) => key(value) != canonicalKey), canonical];
  }
}

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
  final bool colorizeIdle;
  final VoidCallback onTap;

  const _PillChoice({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    this.colorizeIdle = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? color
          : colorizeIdle
          ? Color.lerp(AppColors.surface, color, 0.09)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? color
                  : colorizeIdle
                  ? color.withValues(alpha: 0.62)
                  : AppColors.outline,
              width: selected || colorizeIdle ? 1.2 : 1,
            ),
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
          side: BorderSide(
            color: filled ? color : color.withValues(alpha: 0.38),
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 18, color: filled ? Colors.white : color),
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

class _DreamDraft {
  final DreamType type;
  final String note;

  const _DreamDraft({required this.type, required this.note});
}

class _SymptomGroup {
  final String title;
  final List<_SymptomItem> items;
  final List<_SymptomSubgroup> subgroups;
  final bool showsDreamRecorder;
  final CustomSymptomGroup? customGroup;

  const _SymptomGroup({
    required this.title,
    required this.items,
    this.subgroups = const [],
    this.showsDreamRecorder = false,
    this.customGroup,
  });

  Iterable<_SymptomItem> get allItems sync* {
    yield* items;
    for (final subgroup in subgroups) {
      yield* subgroup.items;
    }
  }
}

class _SymptomSubgroup {
  final String title;
  final List<_SymptomItem> items;
  final CustomSymptomGroup customGroup;

  const _SymptomSubgroup({
    required this.title,
    required this.items,
    required this.customGroup,
  });
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

class _DreamRecorderTile extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _DreamRecorderTile({
    super.key,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      height: 60,
      decoration: BoxDecoration(
        color: selected
            ? color.withValues(alpha: 0.18)
            : Color.lerp(AppColors.surface, color, 0.075),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? color : color.withValues(alpha: 0.62),
          width: selected ? 1.6 : 1.15,
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
                    color: color.withValues(alpha: selected ? 0.15 : 0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.nights_stay_outlined,
                    color: color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.chevron_right_rounded,
                  color: color,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
    final tone = item.color;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          key: ValueKey('symptom_tile_surface_${item.label}'),
          duration: const Duration(milliseconds: 160),
          height: 60,
          decoration: BoxDecoration(
            color: selected
                ? tone.withValues(alpha: 0.18)
                : Color.lerp(AppColors.surface, tone, 0.075),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? tone : tone.withValues(alpha: 0.62),
              width: selected ? 1.6 : 1.15,
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
                            : tone.withValues(alpha: 0.09),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: tone, size: 16),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 3,
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
            : Color.lerp(AppColors.surface, color, 0.075),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? color : color.withValues(alpha: 0.62),
          width: selected ? 1.5 : 1.1,
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
                Icon(icon, size: 18, color: color),
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
