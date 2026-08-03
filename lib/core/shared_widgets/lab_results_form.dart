import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../constants/color_constants.dart';
import '../../data/models/lab_result_model.dart';

/// İlk giriş ve profil ekranında ortak kullanılan yapılandırılmış laboratuvar
/// sonuçları formu.
class LabResultsForm extends StatefulWidget {
  final Map<String, LabResult> initialResults;
  final DateTime? initialTestDate;
  final bool? initialFasting;
  final Color accent;
  final ValueChanged<Map<String, LabResult>> onResultsChanged;
  final ValueChanged<DateTime?> onTestDateChanged;
  final ValueChanged<bool?> onFastingChanged;

  const LabResultsForm({
    super.key,
    this.initialResults = const {},
    this.initialTestDate,
    this.initialFasting,
    this.accent = AppColors.primary,
    required this.onResultsChanged,
    required this.onTestDateChanged,
    required this.onFastingChanged,
  });

  @override
  State<LabResultsForm> createState() => _LabResultsFormState();
}

class _LabResultsFormState extends State<LabResultsForm> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.accent.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.accent.withValues(alpha: 0.18)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: widget.accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isTurkish
                      ? 'Raporunuzdaki değeri ve birimi aynen seçin. Tüm alanlar isteğe bağlıdır; sonuçların yorumu için raporu düzenleyen laboratuvarın referans aralığını kullanın.'
                      : 'Enter the value and choose the unit exactly as shown on your report. Every field is optional; use the issuing laboratory’s reference range for interpretation.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildContextFields(context),
        const SizedBox(height: 12),
        for (final group in LabTestGroup.values) ...[
          _LabGroupTile(
            key: ValueKey('lab_group_${group.name}'),
            title: LabTestCatalog.groupLabel(group, _isTurkish),
            count: LabTestCatalog.forGroup(
              group,
            ).where((definition) => _results.containsKey(definition.id)).length,
            accent: widget.accent,
            initiallyExpanded: LabTestCatalog.forGroup(
              group,
            ).any((definition) => _results.containsKey(definition.id)),
            children: LabTestCatalog.forGroup(
              group,
            ).map(_buildResultField).toList(),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildContextFields(BuildContext context) {
    final dateLabel = _testDate == null
        ? (_isTurkish ? 'Tarih seçilmedi' : 'No date selected')
        : MaterialLocalizations.of(context).formatMediumDate(_testDate!);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isTurkish ? 'Ölçüm bilgileri' : 'Test details',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
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
                    foregroundColor: widget.accent,
                    side: BorderSide(
                      color: widget.accent.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
              if (_testDate != null) ...[
                const SizedBox(width: 6),
                IconButton(
                  tooltip: _isTurkish ? 'Tarihi temizle' : 'Clear date',
                  onPressed: _clearTestDate,
                  icon: const Icon(Icons.close_rounded, size: 19),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isTurkish ? 'Kan açken mi verildi?' : 'Was the sample fasting?',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _fastingChip(true, _isTurkish ? 'Evet' : 'Yes'),
              _fastingChip(false, _isTurkish ? 'Hayır' : 'No'),
              _fastingChip(null, _isTurkish ? 'Bilmiyorum' : 'Unknown'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fastingChip(bool? value, String label) {
    final selected = _fasting == value;
    return ChoiceChip(
      key: ValueKey('lab_fasting_${value ?? 'unknown'}'),
      label: Text(label),
      selected: selected,
      selectedColor: widget.accent.withValues(alpha: 0.14),
      side: BorderSide(
        color: selected
            ? widget.accent.withValues(alpha: 0.55)
            : AppColors.outline,
      ),
      onSelected: (_) {
        setState(() => _fasting = value);
        widget.onFastingChanged(value);
      },
    );
  }

  Widget _buildResultField(LabTestDefinition definition) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            definition.label(_isTurkish),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
                    hintText: _isTurkish ? 'Değer' : 'Value',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
                            style: const TextStyle(fontSize: 12),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          iconColor: accent,
          collapsedIconColor: AppColors.textSecondary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: count == 0
              ? null
              : Text(
                  AppStrings.isTurkish
                      ? '$count değer girildi'
                      : '$count value${count == 1 ? '' : 's'} entered',
                  style: TextStyle(fontSize: 11, color: accent),
                ),
          children: children,
        ),
      ),
    );
  }
}
