part of '../daily_log_sheet.dart';

/// Independent period sheet opened by the dashboard's period action.
class PeriodTrackingSheet extends DailyLogSheet {
  const PeriodTrackingSheet({
    super.key,
    required super.initialLog,
    required super.settings,
    required super.onSave,
    super.onDeletePeriod,
    super.onSettingsChanged,
    super.themeColor,
  }) : super(initialSection: TrackingSection.period, isSingleTab: true);

  @override
  State<DailyLogSheet> createState() => _PeriodTrackingSheetState();
}

class _PeriodTrackingSheetState extends _TrackingSheetState {
  late int _flowIndex;
  late Set<String> _symptoms;
  late Map<String, int> _symptomSeverities;

  @override
  void _initializeSection() {
    _flowIndex = _localizedIndex(
      AppStrings.flowOptions,
      _log.flowIntensity,
      fallback: 2,
    );
    _symptoms = _localizedSetPreservingCustom(
      _log.symptoms,
      AppStrings.allSymptomOptions,
    );
    _symptomSeverities = {
      for (final rawSymptom in _log.symptoms)
        AppStrings.localizeStoredValue(rawSymptom):
            _log.symptomSeverities[rawSymptom] ??
            _log.symptomSeverities[AppStrings.localizeStoredValue(
              rawSymptom,
            )] ??
            2,
    };
  }

  @override
  Widget _buildContent() => _buildPeriodPage();

  @override
  DailyLogDraft _currentDraft() => PeriodLogDraft(
    flowIntensity: AppStrings.flowOptions[_flowIndex],
    symptoms: _symptoms.toList(),
    symptomSeverities: {
      for (final symptom in _symptoms)
        symptom: _symptomSeverities[symptom] ?? 2,
    },
  );

  void _toggleSymptom(String label) {
    _mutate(() {
      if (_symptoms.remove(label)) {
        _symptomSeverities.remove(label);
      } else {
        _symptoms.add(label);
        _symptomSeverities[label] = 2;
      }
    });
  }
}

extension _PeriodSection on _PeriodTrackingSheetState {
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
          onChanged: (index) => _mutate(() => _flowIndex = index),
        ),
        const SizedBox(height: 25),
        _SectionTitle(AppStrings.logAnythingElse),
        const SizedBox(height: 11),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            key: const ValueKey('period_symptom_choices'),
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final option in AppStrings.periodSymptomOptions)
                _PillChoice(
                  label: option,
                  selected: _symptoms.contains(option),
                  color: AppColors.periodPrimary,
                  onTap: () => _toggleSymptom(option),
                ),
              Tooltip(
                message: AppStrings.symptom,
                child: _RoundButton(
                  key: const ValueKey('period_open_symptoms'),
                  icon: Icons.add_rounded,
                  color: AppColors.periodPrimary,
                  filled: true,
                  enabled: true,
                  onTap: _promptSavePeriodAndOpenSymptoms,
                ),
              ),
            ],
          ),
        ),
        if (widget.onDeletePeriod != null &&
            (_log.flowIntensity != null ||
                _log.observedSections.contains(
                  DailyLogObservedSection.period,
                ))) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const ValueKey('delete_period_for_day'),
              onPressed: _isSaving ? null : _confirmDeletePeriod,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.periodPrimary,
                side: BorderSide(
                  color: AppColors.periodPrimary.withValues(alpha: 0.55),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 19),
              label: Text(
                AppStrings.deletePeriodForDay(_log.date.isToday),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _confirmDeletePeriod() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.deletePeriodConfirmationTitle),
        content: Text(AppStrings.deletePeriodConfirmationBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.periodPrimary,
            ),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    _mutate(() => _isSaving = true);
    var success = false;
    try {
      success = await widget.onDeletePeriod!.call(_log.date);
    } catch (_) {
      success = false;
    }
    if (!mounted) return;
    _mutate(() => _isSaving = false);

    if (success) {
      Navigator.pop(context);
      OmaToast.show(context, title: AppStrings.periodEntryDeleted);
    } else {
      OmaToast.show(
        context,
        title: AppStrings.error,
        description: AppStrings.periodDeleteFailed,
        icon: Icons.error_outline_rounded,
      );
    }
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
    final navigator = Navigator.of(context);
    final nextLog = _log;
    final settings = widget.settings;
    final onSave = widget.onSave;
    final onSettingsChanged = widget.onSettingsChanged;
    final themeColor = widget.themeColor;
    navigator.pop();
    await showModalBottomSheet<void>(
      context: navigator.context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SymptomsTrackingSheet(
        initialLog: nextLog,
        settings: settings,
        onSave: onSave,
        onSettingsChanged: onSettingsChanged,
        themeColor: themeColor,
      ),
    );
  }
}
