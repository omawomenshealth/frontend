part of '../daily_log_sheet.dart';

class WellbeingTrackingSheet extends DailyLogSheet {
  const WellbeingTrackingSheet({
    super.key,
    required super.initialLog,
    required super.settings,
    required super.onSave,
    super.onSettingsChanged,
    super.themeColor,
  }) : super(initialSection: TrackingSection.wellbeing, isSingleTab: true);

  @override
  State<DailyLogSheet> createState() => _WellbeingTrackingSheetState();
}

class _WellbeingTrackingSheetState extends _TrackingSheetState {
  late int _moodIndex;
  var _moodStep = 1;
  late Set<String> _moodCompanions;
  late Set<String> _moodPlaces;
  late List<String> _customMoodCompanions;
  late List<String> _customMoodPlaces;

  @override
  void _initializeSection() {
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
      _persistedSettings.customMoodCompanions,
    );
    _customMoodPlaces = List<String>.from(_persistedSettings.customMoodPlaces);
  }

  @override
  bool get _isMoodContext => _moodStep == 2;

  @override
  String get _contentKey => '${_section.name}-$_moodStep';

  @override
  void _goBackFromMoodContext() => _mutate(() => _moodStep = 1);

  @override
  String get _actionLabel =>
      _moodStep == 1 ? AppStrings.continueAction : AppStrings.saveMoment;

  @override
  Widget _buildContent() =>
      _moodStep == 1 ? _buildMoodPage() : _buildMoodContextPage();

  @override
  DailyLogDraft _currentDraft() => WellbeingLogDraft(
    mood: AppStrings.moodCheckInOptions[_moodIndex],
    moodEmoji: AppStrings.moodCheckInEmojis[_moodIndex],
    moodCompanions: _moodCompanions.toList(),
    moodPlaces: _moodPlaces.toList(),
  );

  @override
  Future<void> _handleAction() async {
    if (_moodStep == 1) {
      _mutate(() => _moodStep = 2);
      return;
    }
    await _saveLog();
  }
}

extension _WellbeingSection on _WellbeingTrackingSheetState {
  Widget _buildMoodPage() {
    final tone = _tone;
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
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 29,
            fontWeight: FontWeight.w700,
            color: _tone,
          ),
        ),
        const SizedBox(height: 28),
        _StepSelector(
          labels: AppStrings.moodCheckInOptions,
          selectedIndex: _moodIndex,
          color: tone,
          onChanged: (index) => _mutate(() => _moodIndex = index),
        ),
      ],
    );
  }

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
            color: Color.lerp(AppColors.surface, _tone, 0.09),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: _tone.withValues(alpha: 0.42)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.omaNote,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: _tone,
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
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.moodCompanionTrackingHint,
            style: const TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
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
    final reusableOptions = _uniqueCustomLabels([
      ...options,
      ...(companion ? _customMoodCompanions : _customMoodPlaces),
      ...selected,
    ]);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in reusableOptions.asMap().entries)
          _PillChoice(
            key: ValueKey(
              'mood_${companion ? 'companion' : 'place'}_${entry.key}',
            ),
            label: entry.value,
            selected: selected.contains(entry.value),
            color: _tone,
            colorizeIdle: true,
            onTap: () => _toggleChoice(selected, entry.value),
          ),
        _RoundButton(
          key: ValueKey(companion ? 'mood_companion_add' : 'mood_place_add'),
          icon: Icons.add_rounded,
          color: _tone,
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
          cursorColor: _tone,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: _tone, width: 1.6),
            ),
          ),
          onChanged: (value) => customValue = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(foregroundColor: _tone),
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
    if (!mounted || value == null || value.isEmpty) return;
    final kind = companion
        ? UserDefinedOptionKind.moodCompanion
        : UserDefinedOptionKind.moodPlace;
    final canonical =
        await context.read<LocalStorageService>().rememberUserDefinedOption(
          kind,
          value,
        ) ??
        value;
    await widget.onSettingsChanged?.call();
    if (!mounted) return;
    _mutate(() {
      final catalog = companion ? _customMoodCompanions : _customMoodPlaces;
      if (!catalog.any((item) => _sameCustomLabel(item, canonical))) {
        catalog.add(canonical);
      }
      (companion ? _moodCompanions : _moodPlaces).add(canonical);
    });
  }
}
