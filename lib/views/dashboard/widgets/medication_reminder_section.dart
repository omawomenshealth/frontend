import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/medication_reminder_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/notification_service.dart';

class MedicationReminderSection extends StatefulWidget {
  final MedicationPlanItemType itemType;
  final List<String> availableItems;
  final Color color;

  const MedicationReminderSection({
    super.key,
    required this.itemType,
    required this.availableItems,
    required this.color,
  });

  @override
  State<MedicationReminderSection> createState() =>
      _MedicationReminderSectionState();
}

class _MedicationReminderSectionState extends State<MedicationReminderSection> {
  List<MedicationReminderPlan> _plans = [];
  List<MedicationDoseRecord> _doseRecords = [];
  bool _busy = false;

  LocalStorageService get _storage => context.read<LocalStorageService>();
  NotificationService get _notifications => context.read<NotificationService>();

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    if (!mounted) return;
    setState(() {
      _plans = _storage.loadMedicationReminderPlans();
      _doseRecords = _storage.loadMedicationDoseRecords();
    });
  }

  List<MedicationReminderPlan> get _sectionPlans => _plans
      .where((plan) => plan.itemType == widget.itemType)
      .toList(growable: false);

  List<MedicationDoseRecord> _todaysDoses(DateTime now) {
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    return _doseRecords
        .where(
          (record) =>
              record.itemType == widget.itemType &&
              !record.scheduledAt.isBefore(start) &&
              !record.scheduledAt.isAfter(end),
        )
        .toList(growable: false);
  }

  Future<void> _openForm([MedicationReminderPlan? existing]) async {
    final baseTheme = Theme.of(context);
    final plan = await showModalBottomSheet<MedicationReminderPlan>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      builder: (_) => Theme(
        data: baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(primary: widget.color),
        ),
        child: MedicationReminderFormSheet(
          itemType: widget.itemType,
          availableItems: widget.availableItems,
          existing: existing,
        ),
      ),
    );
    if (plan != null && mounted) await _savePlan(plan);
  }

  Future<void> _savePlan(
    MedicationReminderPlan plan, {
    bool requestPermission = true,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);

    String message;
    try {
      await _storage.refreshMedicationDoseRecords(
        plans: _storage.loadMedicationReminderPlans(),
        notificationScheduledDoseIds: const {},
      );
      await _storage.upsertMedicationReminderPlan(plan);

      var permissionGranted = true;
      if (requestPermission && plan.enabled && _notifications.isSupported) {
        permissionGranted = await _notifications.requestPermissions();
      }
      final result = await _notifications.rescheduleMedicationReminders(
        plans: _storage.loadMedicationReminderPlans(),
      );
      await _storage.refreshMedicationDoseRecords(
        plans: _storage.loadMedicationReminderPlans(),
        notificationScheduledDoseIds: result.scheduledDoses
            .map((dose) => dose.id)
            .toSet(),
      );
      _reload();
      if (!result.supported) {
        message = AppStrings.phoneNotificationUnsupported;
      } else if (!permissionGranted) {
        message = AppStrings.notificationPermissionDenied;
      } else {
        message = AppStrings.reminderSaved;
      }
    } catch (error) {
      await _storage.refreshMedicationDoseRecords(
        plans: _storage.loadMedicationReminderPlans(),
        notificationScheduledDoseIds: const {},
      );
      _reload();
      message = AppStrings.reminderScheduleFailed(error);
    }

    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _togglePlan(MedicationReminderPlan plan, bool enabled) async {
    await _savePlan(
      plan.copyWith(enabled: enabled, updatedAt: DateTime.now()),
      requestPermission: enabled,
    );
  }

  Future<void> _deletePlan(MedicationReminderPlan plan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppStrings.delete),
        content: Text(AppStrings.reminderDeleteQuestion(plan.itemName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    await _storage.refreshMedicationDoseRecords(
      plans: _storage.loadMedicationReminderPlans(),
      notificationScheduledDoseIds: const {},
    );
    await _storage.deleteMedicationReminderPlan(plan.id);
    var scheduledDoseIds = <String>{};
    try {
      final result = await _notifications.rescheduleMedicationReminders(
        plans: _storage.loadMedicationReminderPlans(),
      );
      scheduledDoseIds = result.scheduledDoses.map((dose) => dose.id).toSet();
    } catch (_) {}
    await _storage.refreshMedicationDoseRecords(
      plans: _storage.loadMedicationReminderPlans(),
      notificationScheduledDoseIds: scheduledDoseIds,
    );
    _reload();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppStrings.reminderDeleted)));
  }

  Future<void> _recordResponse(
    MedicationDoseRecord dose,
    MedicationDoseResponseStatus status,
  ) async {
    await _storage.recordMedicationDoseResponse(
      recordId: dose.id,
      status: status,
    );
    _reload();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppStrings.responseSaved)));
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final now = DateTime.now();
    final todaysDoses = _todaysDoses(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 14),
        const Divider(),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.reminderPlans,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: _busy ? null : () => _openForm(),
              icon: const Icon(Icons.add_alarm_rounded, size: 18),
              label: Text(AppStrings.createReminder),
              style: FilledButton.styleFrom(
                backgroundColor: widget.color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_sectionPlans.isEmpty)
          Text(
            AppStrings.noReminderPlans,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          )
        else
          ..._sectionPlans.map(_buildPlanCard),
        if (todaysDoses.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            AppStrings.todaysPlannedDoses,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...todaysDoses.map((dose) => _buildDoseCard(dose, now)),
        ],
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 17,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  AppStrings.reminderDeliveryNote,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(MedicationReminderPlan plan) {
    final time = _formatTime(plan.time);
    final schedule = plan.frequency == MedicationPlanFrequency.everyDay
        ? AppStrings.reminderSummaryDaily(time)
        : AppStrings.reminderSummaryDays(
            (plan.weekdays.toList()..sort())
                .map((day) => AppStrings.shortWeekdays[day - 1])
                .join(', '),
            time,
          );
    final range = AppStrings.reminderDateRange(
      _formatDate(plan.startDate),
      plan.endDate == null ? AppStrings.noEndDate : _formatDate(plan.endDate!),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: plan.enabled ? 0.10 : 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.color.withValues(alpha: plan.enabled ? 0.35 : 0.15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${plan.itemName} • ${plan.dosage}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  schedule,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  range,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: plan.enabled,
            activeTrackColor: widget.color,
            onChanged: _busy ? null : (value) => _togglePlan(plan, value),
          ),
          IconButton(
            tooltip: AppStrings.edit,
            onPressed: _busy ? null : () => _openForm(plan),
            style: IconButton.styleFrom(foregroundColor: widget.color),
            icon: const Icon(Icons.edit_outlined, size: 20),
          ),
          IconButton(
            tooltip: AppStrings.delete,
            onPressed: _busy ? null : () => _deletePlan(plan),
            style: IconButton.styleFrom(foregroundColor: widget.color),
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseCard(MedicationDoseRecord dose, DateTime now) {
    final statusLabel = switch (dose.status) {
      MedicationDoseResponseStatus.taken => AppStrings.doseTaken,
      MedicationDoseResponseStatus.skipped => AppStrings.doseSkipped,
      null =>
        dose.scheduledAt.isBefore(now)
            ? AppStrings.doseUnanswered
            : AppStrings.doseUpcoming,
    };
    final statusColor = switch (dose.status) {
      MedicationDoseResponseStatus.taken => AppColors.success,
      MedicationDoseResponseStatus.skipped => AppColors.error,
      null =>
        dose.scheduledAt.isBefore(now) ? AppColors.warning : AppColors.info,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                DateFormat.Hm(AppStrings.localeName).format(dose.scheduledAt),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text('${dose.itemName} • ${dose.dosage}')),
              Tooltip(
                message: dose.notificationScheduled
                    ? AppStrings.notificationScheduled
                    : AppStrings.notificationNotScheduled,
                child: Icon(
                  dose.notificationScheduled
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  size: 17,
                  color: dose.notificationScheduled
                      ? widget.color
                      : AppColors.textHint,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _recordResponse(dose, MedicationDoseResponseStatus.taken),
                  icon: const Icon(Icons.check_rounded, size: 17),
                  label: Text(AppStrings.doseTaken),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        dose.status == MedicationDoseResponseStatus.taken
                        ? AppColors.success.withValues(alpha: 0.18)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _recordResponse(
                    dose,
                    MedicationDoseResponseStatus.skipped,
                  ),
                  icon: const Icon(Icons.close_rounded, size: 17),
                  label: Text(AppStrings.doseSkipped),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        dose.status == MedicationDoseResponseStatus.skipped
                        ? AppColors.error.withValues(alpha: 0.15)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      DateFormat.yMd(AppStrings.localeName).format(date);

  String _formatTime(ReminderClockTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}

class MedicationReminderFormSheet extends StatefulWidget {
  final MedicationPlanItemType itemType;
  final List<String> availableItems;
  final MedicationReminderPlan? existing;

  const MedicationReminderFormSheet({
    super.key,
    required this.itemType,
    required this.availableItems,
    this.existing,
  });

  @override
  State<MedicationReminderFormSheet> createState() =>
      _MedicationReminderFormSheetState();
}

class _MedicationReminderFormSheetState
    extends State<MedicationReminderFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _customItemController = TextEditingController();
  final _customDoseController = TextEditingController();

  late List<String> _itemOptions;
  late List<String> _doseOptions;
  late String _selectedItem;
  late String _selectedDose;
  late TimeOfDay _time;
  late MedicationPlanFrequency _frequency;
  late Set<int> _weekdays;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _itemOptions = widget.availableItems
        .where((item) => item.trim().isNotEmpty)
        .toSet()
        .toList();
    if (existing != null && !_itemOptions.contains(existing.itemName)) {
      _itemOptions.add(existing.itemName);
    }
    _itemOptions.sort();
    _itemOptions.add(AppStrings.custom);
    _selectedItem = existing?.itemName ?? _itemOptions.first;

    _doseOptions = List<String>.from(AppStrings.dosageOptions);
    if (existing != null && !_doseOptions.contains(existing.dosage)) {
      _doseOptions.add(existing.dosage);
    }
    _doseOptions.add(AppStrings.custom);
    _selectedDose = existing?.dosage ?? AppStrings.dosageOptions.first;

    _time = existing == null
        ? const TimeOfDay(hour: 9, minute: 0)
        : TimeOfDay(hour: existing.time.hour, minute: existing.time.minute);
    _frequency = existing?.frequency ?? MedicationPlanFrequency.everyDay;
    _weekdays = Set<int>.from(
      existing?.weekdays ?? const {1, 2, 3, 4, 5, 6, 7},
    );
    final today = DateTime.now();
    _startDate =
        existing?.startDate ?? DateTime(today.year, today.month, today.day);
    _endDate = existing?.endDate;
    _enabled = existing?.enabled ?? true;
  }

  @override
  void dispose() {
    _customItemController.dispose();
    _customDoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.existing == null
                          ? AppStrings.createReminder
                          : AppStrings.editReminder,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedItem,
                decoration: InputDecoration(
                  labelText: AppStrings.reminderItem,
                  prefixIcon: Icon(
                    widget.itemType == MedicationPlanItemType.medication
                        ? Icons.medication_outlined
                        : Icons.spa_outlined,
                  ),
                ),
                items: _itemOptions
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedItem = value!),
              ),
              if (_selectedItem == AppStrings.custom) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _customItemController,
                  autofocus: true,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: AppStrings.reminderItem,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AppStrings.reminderItemRequired
                      : null,
                ),
              ],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedDose,
                decoration: InputDecoration(
                  labelText: AppStrings.reminderDose,
                  prefixIcon: const Icon(Icons.straighten_rounded),
                ),
                items: _doseOptions
                    .map(
                      (dose) =>
                          DropdownMenuItem(value: dose, child: Text(dose)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedDose = value!),
              ),
              if (_selectedDose == AppStrings.custom) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _customDoseController,
                  maxLength: 200,
                  decoration: InputDecoration(
                    labelText: AppStrings.customDosage,
                    hintText: AppStrings.customDosageHint,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AppStrings.customDosageHint
                      : null,
                ),
              ],
              const SizedBox(height: 12),
              _pickerTile(
                icon: Icons.schedule_rounded,
                label: AppStrings.notificationTime,
                value: _time.format(context),
                onTap: _pickTime,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<MedicationPlanFrequency>(
                initialValue: _frequency,
                decoration: InputDecoration(
                  labelText: AppStrings.repeatPeriod,
                  prefixIcon: const Icon(Icons.repeat_rounded),
                ),
                items: [
                  DropdownMenuItem(
                    value: MedicationPlanFrequency.everyDay,
                    child: Text(AppStrings.everyDay),
                  ),
                  DropdownMenuItem(
                    value: MedicationPlanFrequency.selectedWeekdays,
                    child: Text(AppStrings.selectedDays),
                  ),
                ],
                onChanged: (value) => setState(() => _frequency = value!),
              ),
              if (_frequency == MedicationPlanFrequency.selectedWeekdays) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children: List.generate(7, (index) {
                    final day = index + 1;
                    return FilterChip(
                      label: Text(AppStrings.shortWeekdays[index]),
                      selected: _weekdays.contains(day),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _weekdays.add(day);
                        } else {
                          _weekdays.remove(day);
                        }
                      }),
                    );
                  }),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _pickerTile(
                      icon: Icons.calendar_today_outlined,
                      label: AppStrings.startDate,
                      value: _formatDate(_startDate),
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _pickerTile(
                      icon: Icons.event_available_outlined,
                      label: AppStrings.endDate,
                      value: _endDate == null
                          ? AppStrings.noEndDate
                          : _formatDate(_endDate!),
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),
              if (_endDate != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => _endDate = null),
                    child: Text(AppStrings.noEndDate),
                  ),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(AppStrings.reminderEnabled),
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.alarm_add_rounded),
                label: Text(AppStrings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(context: context, initialTime: _time);
    if (value != null && mounted) setState(() => _time = value);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final today = DateTime.now();
    final initial = isStart ? _startDate : (_endDate ?? _startDate);
    final value = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 10),
    );
    if (value == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startDate = value;
        if (_endDate?.isBefore(value) ?? false) _endDate = null;
      } else {
        _endDate = value;
      }
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_frequency == MedicationPlanFrequency.selectedWeekdays &&
        _weekdays.isEmpty) {
      _showValidation(AppStrings.selectAtLeastOneDay);
      return;
    }
    if (_endDate?.isBefore(_startDate) ?? false) {
      _showValidation(AppStrings.endDateValidation);
      return;
    }

    final now = DateTime.now();
    final existing = widget.existing;
    final itemName = _selectedItem == AppStrings.custom
        ? _customItemController.text.trim()
        : _selectedItem;
    final dosage = _selectedDose == AppStrings.custom
        ? _customDoseController.text.trim()
        : _selectedDose;
    final plan = MedicationReminderPlan(
      id: existing?.id ?? 'plan_${now.microsecondsSinceEpoch}',
      itemType: widget.itemType,
      itemName: itemName,
      dosage: dosage,
      time: ReminderClockTime(hour: _time.hour, minute: _time.minute),
      frequency: _frequency,
      weekdays: _frequency == MedicationPlanFrequency.everyDay
          ? const {1, 2, 3, 4, 5, 6, 7}
          : _weekdays,
      startDate: DateTime(_startDate.year, _startDate.month, _startDate.day),
      endDate: _endDate == null
          ? null
          : DateTime(_endDate!.year, _endDate!.month, _endDate!.day),
      enabled: _enabled,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    Navigator.pop(context, plan);
  }

  void _showValidation(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime date) =>
      DateFormat.yMd(AppStrings.localeName).format(date);
}
