import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/app_time.dart';
import '../../../core/utils/date_extensions.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';

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
  late int _logType;
  var _isSaving = false;

  late int _flowIndex;
  late bool _periodStartedToday;
  late Set<String> _periodSymptoms;

  late int _waterGlasses;
  late Set<String> _meals;
  late int _nutritionQualityIndex;
  late Set<String> _cravings;

  final _symptomSearchController = TextEditingController();
  late Set<String> _symptoms;
  late int _symptomSeverityIndex;

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
    _periodStartedToday = _log.periodStartedToday ?? true;
    _periodSymptoms = _localizedSet(
      _log.symptoms,
      AppStrings.periodSymptomOptions,
    );

    _waterGlasses = _log.waterIntakeMl == null
        ? 4
        : (_log.waterIntakeMl! / 250).round().clamp(0, 12);
    _meals = _localizedSet(_log.mealTypes, AppStrings.nutritionMealOptions);
    if (_meals.isEmpty) {
      _meals = {
        AppStrings.nutritionMealOptions[0],
        AppStrings.nutritionMealOptions[1],
      };
    }
    _nutritionQualityIndex = _localizedIndex(
      AppStrings.nutritionQualityOptions,
      _log.nutritionQuality,
      fallback: 1,
    );
    _cravings = _localizedSet(
      _log.cravings,
      AppStrings.nutritionCravingOptions,
    );

    _symptoms = _localizedSet(_log.symptoms, _allSymptomOptions);
    _symptomSeverityIndex = (_log.symptomSeverity ?? 2) - 1;

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
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
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
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.periodStartedToday,
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.periodStartedHint,
                      style: const TextStyle(
                        fontSize: 10.5,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _periodStartedToday,
                activeTrackColor: AppColors.periodPrimary,
                onChanged: (value) =>
                    setState(() => _periodStartedToday = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.logAnythingElse),
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
                    icon: Icons.remove_rounded,
                    color: AppColors.secondary,
                    filled: false,
                    enabled: _waterGlasses > 0,
                    onTap: () =>
                        setState(() => _waterGlasses = _waterGlasses - 1),
                  ),
                  const SizedBox(width: 9),
                  _RoundButton(
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
        _buildSimpleChoices(
          options: AppStrings.nutritionMealOptions,
          selected: _meals,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 24),
        _SectionTitle(AppStrings.mealsFeel),
        const SizedBox(height: 11),
        Row(
          children: AppStrings.nutritionQualityOptions.asMap().entries.map((
            entry,
          ) {
            final selected = entry.key == _nutritionQualityIndex;
            final activeColor = entry.key == 1
                ? AppColors.primary
                : AppColors.secondary;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right:
                      entry.key == AppStrings.nutritionQualityOptions.length - 1
                      ? 0
                      : 8,
                ),
                child: _PillChoice(
                  label: entry.value,
                  selected: selected,
                  color: activeColor,
                  onTap: () =>
                      setState(() => _nutritionQualityIndex = entry.key),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.cravingsQuestion),
        const SizedBox(height: 11),
        _buildSimpleChoices(
          options: AppStrings.nutritionCravingOptions,
          selected: _cravings,
          color: AppColors.secondary,
        ),
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
        if (_symptoms.isNotEmpty) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.symptomStrength.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: AppStrings.symptomSeverityOptions
                      .asMap()
                      .entries
                      .map((entry) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: entry.key == 2 ? 0 : 7,
                            ),
                            child: _PillChoice(
                              label: entry.value,
                              selected: entry.key == _symptomSeverityIndex,
                              color: AppColors.primary,
                              onTap: () => setState(
                                () => _symptomSeverityIndex = entry.key,
                              ),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ],
            ),
          ),
        ],
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
            GridView.count(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3.75,
              children: [
                for (final item in group.items)
                  if (query.isEmpty || item.label.toLowerCase().contains(query))
                    _SymptomTile(
                      item: item,
                      selected: _symptoms.contains(item.label),
                      onTap: () => _toggleSymptom(item.label),
                    ),
              ],
            ),
          ],
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
            icon: icons[index],
            color: colors[index],
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
      } else {
        _symptoms.add(label);
      }
    });
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
        _RoundButton(
          icon: Icons.add_rounded,
          color: AppColors.primary,
          filled: false,
          enabled: true,
          onTap: () => _addCustomContext(companion),
        ),
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
      ],
    );
  }

  Future<void> _addCustomContext(bool companion) async {
    final controller = TextEditingController();
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
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(AppStrings.add),
          ),
        ],
      ),
    );
    controller.dispose();
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

  DailyLog _preparedLog(DateTime finalDate) {
    final observed = <DailyLogObservedSection>{
      ..._log.observedSections,
      switch (_logType) {
        0 => DailyLogObservedSection.period,
        1 => DailyLogObservedSection.nutrition,
        2 => DailyLogObservedSection.symptom,
        _ => DailyLogObservedSection.wellbeing,
      },
    };

    return switch (_logType) {
      0 => _log.copyWith(
        date: finalDate,
        flowIntensity: AppStrings.flowOptions[_flowIndex],
        periodStartedToday: _periodStartedToday,
        symptoms: _periodSymptoms.toList(),
        painLocations: _matchingPainLocations(_periodSymptoms),
        observedSections: observed,
      ),
      1 => _log.copyWith(
        date: finalDate,
        waterIntakeMl: _waterGlasses * 250,
        mealTypes: _meals.toList(),
        nutritionQuality:
            AppStrings.nutritionQualityOptions[_nutritionQualityIndex],
        cravings: _cravings.toList(),
        observedSections: observed,
      ),
      2 => _log.copyWith(
        date: finalDate,
        symptoms: _symptoms.toList(),
        symptomSeverity: _symptomSeverityIndex + 1,
        painLocations: _matchingPainLocations(_symptoms),
        observedSections: observed,
      ),
      _ => _log.copyWith(
        date: finalDate,
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

  Future<void> _saveLog() async {
    final today = AppTime.now.dateOnly;
    var finalDate = _log.date;
    if (_log.date.dateOnly.isBefore(today)) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_log.date),
        helpText: AppStrings.selectLogTime,
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
      success = await widget.onSave(_preparedLog(finalDate));
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
  final VoidCallback onTap;

  const _SymptomTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.lerp(item.color, Colors.white, 0.84),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.fromLTRB(5, 4, 8, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected ? item.color : AppColors.outline,
                  width: selected ? 1.8 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 15),
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
                ],
              ),
            ),
            if (selected)
              Positioned(
                right: -2,
                top: -3,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
