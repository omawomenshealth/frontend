import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../theme/oma_theme.dart';
import '../../data/models/lab_result_model.dart';

/// İlk giriş ve profil ekranında ortak kullanılan yapılandırılmış laboratuvar
/// sonuçları formu.
class LabResultsForm extends StatefulWidget {
  final Map<String, LabResult> initialResults;
  final DateTime? initialTestDate;
  final bool? initialFasting;
  final Color? accent;
  final ValueChanged<Map<String, LabResult>> onResultsChanged;
  final ValueChanged<DateTime?> onTestDateChanged;
  final ValueChanged<bool?> onFastingChanged;

  const LabResultsForm({
    super.key,
    this.initialResults = const {},
    this.initialTestDate,
    this.initialFasting,
    this.accent,
    required this.onResultsChanged,
    required this.onTestDateChanged,
    required this.onFastingChanged,
  });

  @override
  State<LabResultsForm> createState() => _LabResultsFormState();
}

class _LabResultsFormState extends State<LabResultsForm> {
  final _searchController = TextEditingController();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, String> _units;
  late Map<String, LabResult> _results;
  late DateTime? _testDate;
  late bool? _fasting;

  bool get _isTurkish => AppStrings.isTurkish;

  @override
  void initState() {
    super.initState();
    _results = Map<String, LabResult>.from(widget.initialResults);
    _testDate = widget.initialTestDate;
    _fasting = widget.initialFasting;
    _controllers = {
      for (final definition in LabTestCatalog.definitions)
        definition.id: TextEditingController(
          text: _results[definition.id]?.value ?? '',
        ),
    };
    _units = {
      for (final definition in LabTestCatalog.definitions)
        definition.id: _validInitialUnit(definition),
    };
  }

  String _validInitialUnit(LabTestDefinition definition) {
    final savedUnit = widget.initialResults[definition.id]?.unit;
    return definition.units.contains(savedUnit)
        ? savedUnit!
        : definition.defaultUnit;
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateResult(LabTestDefinition definition) {
    final value = _controllers[definition.id]!.text.trim();
    final updated = Map<String, LabResult>.from(_results);
    if (value.isEmpty) {
      updated.remove(definition.id);
    } else {
      updated[definition.id] = LabResult(
        value: value,
        unit: _units[definition.id]!,
      );
    }
    _results = updated;
    widget.onResultsChanged(Map.unmodifiable(updated));
  }

  Future<void> _pickTestDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _testDate ?? now,
      firstDate: DateTime(now.year - 20),
      lastDate: now,
    );
    if (selected == null || !mounted) return;
    setState(() => _testDate = selected);
    widget.onTestDateChanged(selected);
  }

  void _clearTestDate() {
    setState(() => _testDate = null);
    widget.onTestDateChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent ?? context.omaTheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(OmaRadius.lg),
            border: Border.all(color: accent.withValues(alpha: 0.18)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppStrings.laboratoryEntryDisclaimer,
                  style: TextStyle(
                    color: context.omaTheme.muted,
                    fontSize: OmaTypeScale.caption,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: OmaSpacing.lg),
        TextField(
          key: const ValueKey('lab_results_search'),
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: AppStrings.searchLaboratoryValue,
            prefixIcon: Icon(Icons.search_rounded, color: accent),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        ),
        const SizedBox(height: OmaSpacing.md),
        _buildContextFields(context),
        const SizedBox(height: OmaSpacing.md),
        for (final group in LabTestGroup.values)
          if (_definitionsForGroup(group).isNotEmpty) ...[
            _LabGroupTile(
              key: ValueKey(
                'lab_group_${group.name}_${_searchController.text.trim()}',
              ),
              title: LabTestCatalog.groupLabel(group, _isTurkish),
              count: LabTestCatalog.forGroup(group)
                  .where((definition) => _results.containsKey(definition.id))
                  .length,
              accent: accent,
              initiallyExpanded:
                  _searchController.text.trim().isNotEmpty ||
                  LabTestCatalog.forGroup(
                    group,
                  ).any((definition) => _results.containsKey(definition.id)),
              children: _definitionsForGroup(group)
                  .map((definition) => _buildResultField(context, definition))
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  List<LabTestDefinition> _definitionsForGroup(LabTestGroup group) {
    final query = _searchController.text.trim().toLowerCase();
    final definitions = LabTestCatalog.forGroup(group);
    if (query.isEmpty) return definitions;
    return definitions
        .where(
          (definition) =>
              definition.id.toLowerCase().contains(query) ||
              definition.label(_isTurkish).toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  Widget _buildContextFields(BuildContext context) {
    final oma = context.omaTheme;
    final accent = widget.accent ?? oma.primary;
    final dateLabel = _testDate == null
        ? AppStrings.noTestDateSelected
        : MaterialLocalizations.of(context).formatMediumDate(_testDate!);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: oma.surface,
        borderRadius: BorderRadius.circular(OmaRadius.lg),
        border: Border.all(color: oma.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.testDetails,
            style: TextStyle(
              fontSize: OmaTypeScale.body,
              fontWeight: FontWeight.w700,
              color: oma.foreground,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('lab_test_date'),
                  onPressed: _pickTestDate,
                  icon: const Icon(Icons.calendar_month_outlined, size: 18),
                  label: Text(dateLabel, overflow: TextOverflow.ellipsis),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accent,
                    side: BorderSide(color: accent.withValues(alpha: 0.35)),
                  ),
                ),
              ),
              if (_testDate != null) ...[
                const SizedBox(width: 6),
                IconButton(
                  tooltip: AppStrings.clearTestDate,
                  onPressed: _clearTestDate,
                  icon: const Icon(Icons.close_rounded, size: 19),
                ),
              ],
            ],
          ),
          const SizedBox(height: OmaSpacing.sm),
          Text(
            AppStrings.fastingSampleQuestion,
            style: TextStyle(fontSize: OmaTypeScale.caption, color: oma.muted),
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _fastingChip(context, true, AppStrings.yes),
              _fastingChip(context, false, AppStrings.no),
              _fastingChip(context, null, AppStrings.doNotKnow),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fastingChip(BuildContext context, bool? value, String label) {
    final oma = context.omaTheme;
    final accent = widget.accent ?? oma.primary;
    final selected = _fasting == value;
    return ChoiceChip(
      key: ValueKey('lab_fasting_${value ?? 'unknown'}'),
      label: Text(label),
      selected: selected,
      selectedColor: accent.withValues(alpha: 0.14),
      side: BorderSide(
        color: selected ? accent.withValues(alpha: 0.55) : oma.border,
      ),
      onSelected: (_) {
        setState(() => _fasting = value);
        widget.onFastingChanged(value);
      },
    );
  }

  Widget _buildResultField(BuildContext context, LabTestDefinition definition) {
    return Padding(
      padding: const EdgeInsets.only(bottom: OmaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.label(_isTurkish),
            style: TextStyle(
              fontSize: OmaTypeScale.caption,
              fontWeight: FontWeight.w600,
              color: context.omaTheme.foreground,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: ValueKey('lab_value_${definition.id}'),
                  controller: _controllers[definition.id],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  onChanged: (_) {
                    _updateResult(definition);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: AppStrings.value,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: OmaSpacing.sm),
              SizedBox(
                width: 134,
                child: DropdownButtonFormField<String>(
                  key: ValueKey('lab_unit_${definition.id}'),
                  initialValue: _units[definition.id],
                  isExpanded: true,
                  decoration: const InputDecoration(isDense: true),
                  items: definition.units
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(
                            unit,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: OmaTypeScale.caption),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (unit) {
                    if (unit == null) return;
                    _units[definition.id] = unit;
                    _updateResult(definition);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabGroupTile extends StatelessWidget {
  final String title;
  final int count;
  final Color accent;
  final bool initiallyExpanded;
  final List<Widget> children;

  const _LabGroupTile({
    super.key,
    required this.title,
    required this.count,
    required this.accent,
    required this.initiallyExpanded,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    return Material(
      color: oma.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OmaRadius.lg),
        side: BorderSide(color: oma.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          iconColor: accent,
          collapsedIconColor: oma.muted,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: OmaSpacing.xxs),
          childrenPadding: const EdgeInsets.fromLTRB(14, OmaSpacing.xs, 14, OmaSpacing.xs),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: oma.foreground,
            ),
          ),
          subtitle: count == 0
              ? null
              : Text(
                  AppStrings.laboratoryValuesEntered(count),
                  style: TextStyle(fontSize: 11, color: accent),
                ),
          children: children,
        ),
      ),
    );
  }
}
