import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/medication_identity_model.dart';
import '../../../data/models/medication_reminder_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/notification_service.dart';

Future<String> saveMedicationReminderPlan({
  required LocalStorageService storage,
  required NotificationService notifications,
  required MedicationReminderPlan plan,
  bool requestPermission = true,
}) async {
  try {
    await storage.refreshMedicationDoseRecords(
      plans: storage.loadMedicationReminderPlans(),
      notificationScheduledDoseIds: const {},
    );
    await storage.upsertMedicationReminderPlan(plan);

    var permissionGranted = true;
    if (requestPermission && plan.enabled && notifications.isSupported) {
      permissionGranted = await notifications.requestPermissions();
    }
    final result = await notifications.rescheduleMedicationReminders(
      plans: storage.loadMedicationReminderPlans(),
    );
    await storage.refreshMedicationDoseRecords(
      plans: storage.loadMedicationReminderPlans(),
      notificationScheduledDoseIds: result.scheduledDoses
          .map((dose) => dose.id)
          .toSet(),
    );
    if (!result.supported) {
      return AppStrings.phoneNotificationUnsupported;
    }
    if (!permissionGranted) {
      return AppStrings.notificationPermissionDenied;
    }
    return AppStrings.reminderSaved;
  } catch (error) {
    await storage.refreshMedicationDoseRecords(
      plans: storage.loadMedicationReminderPlans(),
      notificationScheduledDoseIds: const {},
    );
    return AppStrings.reminderScheduleFailed(error);
  }
}

class TodaysMedicationDosesCard extends StatefulWidget {
  final Color color;

  const TodaysMedicationDosesCard({super.key, required this.color});

  @override
  State<TodaysMedicationDosesCard> createState() =>
      _TodaysMedicationDosesCardState();
}

class _TodaysMedicationDosesCardState extends State<TodaysMedicationDosesCard> {
  LocalStorageService get _storage => context.read<LocalStorageService>();

  List<MedicationDoseRecord> _doses = const [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final activePlans = _storage
        .loadMedicationReminderPlans()
        .where((plan) => plan.enabled)
        .toList(growable: false);
    final activeDoseIds = MedicationScheduleCalculator.between(
      plans: activePlans,
      from: start,
      through: end,
    ).map((dose) => dose.id).toSet();
    _doses =
        _storage
            .loadMedicationDoseRecords()
            .where(
              (dose) =>
                  activeDoseIds.contains(dose.id) &&
                  !dose.scheduledAt.isBefore(start) &&
                  !dose.scheduledAt.isAfter(end),
            )
            .toList()
          ..sort(
            (left, right) => left.scheduledAt.compareTo(right.scheduledAt),
          );
  }

  @override
  void didUpdateWidget(covariant TodaysMedicationDosesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reload();
  }

  Future<void> _record(
    MedicationDoseRecord dose,
    MedicationDoseResponseStatus status,
  ) async {
    await _storage.recordMedicationDoseResponse(
      recordId: dose.id,
      status: status,
    );
    if (!mounted) return;
    setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    _reload();
    if (_doses.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        key: const ValueKey('dashboard_planned_doses'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: widget.color.withValues(alpha: 0.20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.todaysPlannedDoses,
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            for (final dose in _doses) _buildDose(dose, now),
          ],
        ),
      ),
    );
  }

  Widget _buildDose(MedicationDoseRecord dose, DateTime now) {
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
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                DateFormat.Hm(AppStrings.localeName).format(dose.scheduledAt),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${AppStrings.localizeStoredValue(dose.displayName)} • '
                  '${dose.dosage}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                dose.notificationScheduled
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
                size: 17,
                color: dose.notificationScheduled
                    ? widget.color
                    : AppColors.textHint,
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _record(dose, MedicationDoseResponseStatus.taken),
                  icon: const Icon(Icons.check_rounded, size: 17),
                  label: Text(AppStrings.doseTaken),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: const BorderSide(color: AppColors.success),
                    backgroundColor:
                        dose.status == MedicationDoseResponseStatus.taken
                        ? AppColors.success.withValues(alpha: 0.12)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _record(dose, MedicationDoseResponseStatus.skipped),
                  icon: const Icon(Icons.close_rounded, size: 17),
                  label: Text(AppStrings.doseSkipped),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    backgroundColor:
                        dose.status == MedicationDoseResponseStatus.skipped
                        ? AppColors.error.withValues(alpha: 0.10)
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
}

class MedicationReminderSection extends StatefulWidget {
  final MedicationPlanItemType itemType;
  final List<String> availableItems;
  final Map<String, MedicationIdentity> itemIdentities;
  final Color color;
  final VoidCallback? onChanged;

  const MedicationReminderSection({
    super.key,
    required this.itemType,
    required this.availableItems,
    this.itemIdentities = const {},
    required this.color,
    this.onChanged,
  });

  @override
  State<MedicationReminderSection> createState() =>
      _MedicationReminderSectionState();
}

class _MedicationReminderSectionState extends State<MedicationReminderSection> {
  List<MedicationReminderPlan> _plans = [];
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
    });
  }

  List<MedicationReminderPlan> get _sectionPlans => _plans
      .where((plan) => plan.itemType == widget.itemType)
      .toList(growable: false);

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
          itemIdentities: widget.itemIdentities,
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

    final message = await saveMedicationReminderPlan(
      storage: _storage,
      notifications: _notifications,
      plan: plan,
      requestPermission: requestPermission,
    );
    _reload();
    widget.onChanged?.call();

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
        content: Text(
          AppStrings.reminderDeleteQuestion(
            AppStrings.localizeStoredValue(plan.displayName),
          ),
        ),
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
    widget.onChanged?.call();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(AppStrings.reminderDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);

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
    final time = plan.times.map(_formatTime).join(' · ');
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
                  '${AppStrings.localizeStoredValue(plan.displayName)} • '
                  '${plan.dosage}',
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

  String _formatDate(DateTime date) =>
      DateFormat.yMd(AppStrings.localeName).format(date);

  String _formatTime(ReminderClockTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}

class MedicationReminderFormSheet extends StatefulWidget {
  final MedicationPlanItemType itemType;
  final List<String> availableItems;
  final Map<String, MedicationIdentity> itemIdentities;
  final MedicationReminderPlan? existing;
  final String? initialItemName;
  final String? initialDosage;
  final List<TimeOfDay> initialTimes;

  const MedicationReminderFormSheet({
    super.key,
    required this.itemType,
    required this.availableItems,
    this.itemIdentities = const {},
    this.existing,
    this.initialItemName,
    this.initialDosage,
    this.initialTimes = const [],
  });

  @override
  State<MedicationReminderFormSheet> createState() =>
      _MedicationReminderFormSheetState();
}

class _MedicationReminderFormSheetState
    extends State<MedicationReminderFormSheet> {
  static const _medicationDurationPresets = <int>[3, 5, 7, 10, 14];
  static const _routineDurationPresets = <int>[30, 60, 90];

  final _formKey = GlobalKey<FormState>();
  final _customItemController = TextEditingController();

  late List<String> _itemOptions;
  late String _selectedItem;
  late int _doseCount;
  late List<TimeOfDay?> _times;
  late MedicationPlanFrequency _frequency;
  late Set<int> _weekdays;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _enabled;

  List<int> get _durationPresets =>
      widget.itemType == MedicationPlanItemType.medication
      ? _medicationDurationPresets
      : _routineDurationPresets;

  bool get _isRoutineItem =>
      widget.itemType == MedicationPlanItemType.supplement ||
      widget.itemType == MedicationPlanItemType.skincare;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _itemOptions = widget.availableItems
        .where((item) => item.trim().isNotEmpty)
        .toSet()
        .toList();
    final localizedExistingName = existing == null
        ? null
        : AppStrings.localizeStoredValue(existing.displayName);
    if (localizedExistingName != null &&
        !_itemOptions.contains(localizedExistingName)) {
      _itemOptions.add(localizedExistingName);
    }
    final initialItemName = widget.initialItemName?.trim();
    if (existing == null &&
        initialItemName != null &&
        initialItemName.isNotEmpty &&
        !_itemOptions.contains(initialItemName)) {
      _itemOptions.add(initialItemName);
    }
    _itemOptions.sort();
    _itemOptions.add(AppStrings.custom);
    _selectedItem =
        localizedExistingName ??
        (initialItemName?.isNotEmpty ?? false
            ? initialItemName!
            : _itemOptions.first);

    final initialDosage = widget.initialDosage?.trim();
    _doseCount = _doseCountFromText(existing?.dosage ?? initialDosage);

    _times = List<TimeOfDay?>.filled(3, null, growable: true);
    final initialTimes = existing == null
        ? widget.initialTimes
        : existing.times
              .map((clock) => TimeOfDay(hour: clock.hour, minute: clock.minute))
              .toList();
    if (initialTimes.isEmpty) {
      _times[0] = const TimeOfDay(hour: 9, minute: 0);
    } else {
      for (final time in initialTimes) {
        var slot = _slotForHour(time.hour);
        if (_times[slot] != null) {
          slot = _times.indexWhere((value) => value == null);
        }
        if (slot == -1) {
          if (_times.length < 12) _times.add(time);
        } else {
          _times[slot] = time;
        }
      }
    }
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
              InputDecorator(
                decoration: InputDecoration(
                  labelText: AppStrings.reminderDose,
                  prefixIcon: const Icon(Icons.straighten_rounded),
                ),
                child: Row(
                  children: [
                    IconButton.outlined(
                      key: const ValueKey('reminder_dose_decrement'),
                      onPressed: _doseCount > 1
                          ? () => setState(() => _doseCount--)
                          : null,
                      icon: const Icon(Icons.remove_rounded),
                    ),
                    Expanded(
                      child: Text(
                        AppStrings.dosageCount(_doseCount),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton.filled(
                      key: const ValueKey('reminder_dose_increment'),
                      onPressed: _doseCount < 12
                          ? () => setState(() => _doseCount++)
                          : null,
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.notificationTime,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              for (var index = 0; index < _times.length; index++) ...[
                _buildTimeSlot(index),
                if (index != _times.length - 1) const SizedBox(height: 8),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  key: const ValueKey('reminder_add_time'),
                  onPressed: _times.length < 12 || _times.contains(null)
                      ? _addReminderTime
                      : null,
                  icon: const Icon(Icons.add_alarm_rounded, size: 18),
                  label: Text(AppStrings.addTime),
                ),
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
                    child: Text(
                      _isRoutineItem
                          ? AppStrings.remindEveryDay
                          : AppStrings.everyDay,
                    ),
                  ),
                  DropdownMenuItem(
                    value: MedicationPlanFrequency.selectedWeekdays,
                    child: Text(
                      _isRoutineItem
                          ? AppStrings.remindOnSelectedDays
                          : AppStrings.selectedDays,
                    ),
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
              Text(
                AppStrings.usageDurationQuestion,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  ChoiceChip(
                    key: const ValueKey('reminder_duration_long_term'),
                    label: Text(
                      _isRoutineItem
                          ? AppStrings.ongoingRoutine
                          : AppStrings.longTermUsage,
                    ),
                    selected: _endDate == null,
                    onSelected: (_) => _setUsageDuration(null),
                  ),
                  for (final days in _durationPresets)
                    ChoiceChip(
                      key: ValueKey('reminder_duration_$days'),
                      label: Text(AppStrings.durationDays(days)),
                      selected: _usageDurationDays == days,
                      onSelected: (_) => _setUsageDuration(days),
                    ),
                  ChoiceChip(
                    key: const ValueKey('reminder_duration_custom'),
                    label: Text(AppStrings.customEndDate),
                    selected:
                        _endDate != null &&
                        !_durationPresets.contains(_usageDurationDays),
                    onSelected: (_) => _pickDate(isStart: false),
                  ),
                ],
              ),
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

  Widget _buildTimeSlot(int index) {
    final value = _times[index];
    return Container(
      key: ValueKey('reminder_time_slot_$index'),
      padding: const EdgeInsets.fromLTRB(12, 5, 4, 5),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 19,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              index < AppStrings.medicationTimes.length
                  ? AppStrings.medicationTimes[index]
                  : '${AppStrings.medicationTime} ${index + 1}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (value != null)
            TextButton(
              key: ValueKey('reminder_time_pick_$index'),
              onPressed: () => _pickTime(index),
              child: Text(value.format(context)),
            ),
          if (index < AppStrings.medicationTimes.length)
            Switch(
              key: ValueKey('reminder_time_toggle_$index'),
              value: value != null,
              onChanged: (enabled) => setState(() {
                _times[index] = enabled ? _defaultTimeForSlot(index) : null;
              }),
            )
          else
            IconButton(
              key: ValueKey('reminder_time_remove_$index'),
              tooltip: AppStrings.delete,
              onPressed: () => setState(() => _times.removeAt(index)),
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    );
  }

  Future<void> _pickTime(int index) async {
    final value = await showTimePicker(
      context: context,
      initialTime: _times[index] ?? _defaultTimeForSlot(index),
    );
    if (value != null && mounted) setState(() => _times[index] = value);
  }

  void _addReminderTime() {
    setState(() {
      final emptySlot = _times.indexWhere((value) => value == null);
      if (emptySlot >= 0) {
        _times[emptySlot] = _defaultTimeForSlot(emptySlot);
      } else if (_times.length < 12) {
        _times.add(_nextReminderTime());
      }
      final activeTimeCount = _times.whereType<TimeOfDay>().length;
      if (_doseCount < activeTimeCount) _doseCount = activeTimeCount;
    });
  }

  TimeOfDay _nextReminderTime() {
    final active = _times.whereType<TimeOfDay>().toList();
    if (active.isEmpty) return const TimeOfDay(hour: 9, minute: 0);
    var minutes = (active.last.hour * 60 + active.last.minute + 360) % 1440;
    for (var attempt = 0; attempt < 24; attempt++) {
      final candidate = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
      final duplicate = active.any(
        (time) =>
            time.hour == candidate.hour && time.minute == candidate.minute,
      );
      if (!duplicate) return candidate;
      minutes = (minutes + 60) % 1440;
    }
    return const TimeOfDay(hour: 0, minute: 0);
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
    final presetDuration = _durationPresets.contains(_usageDurationDays)
        ? _usageDurationDays
        : null;
    setState(() {
      if (isStart) {
        _startDate = value;
        if (presetDuration != null) {
          _endDate = value.add(Duration(days: presetDuration - 1));
        } else if (_endDate?.isBefore(value) ?? false) {
          _endDate = null;
        }
      } else {
        _endDate = value;
      }
    });
  }

  int? get _usageDurationDays {
    final endDate = _endDate;
    if (endDate == null) return null;
    return endDate.difference(_startDate).inDays + 1;
  }

  void _setUsageDuration(int? days) {
    setState(() {
      _endDate = days == null ? null : _startDate.add(Duration(days: days - 1));
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final selectedTimes = _times.whereType<TimeOfDay>().toList();
    if (selectedTimes.isEmpty) {
      _showValidation(AppStrings.selectAtLeastOneNotificationTime);
      return;
    }
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
    final displayName = _selectedItem == AppStrings.custom
        ? _customItemController.text.trim()
        : _selectedItem;
    final knownIdentity = widget.itemIdentities[displayName];
    final mainGroup =
        existing?.mainGroup ?? knownIdentity?.mainGroup ?? displayName;
    final activeIngredient =
        widget.itemType == MedicationPlanItemType.medication
        ? existing?.activeIngredient ?? knownIdentity?.activeIngredient
        : null;
    final reminderTimes = selectedTimes
        .map(
          (value) => ReminderClockTime(hour: value.hour, minute: value.minute),
        )
        .toList();
    final plan = MedicationReminderPlan(
      id: existing?.id ?? 'plan_${now.microsecondsSinceEpoch}',
      itemType: widget.itemType,
      displayName: displayName,
      mainGroup: mainGroup,
      activeIngredient: activeIngredient,
      dosage: AppStrings.dosageCount(_doseCount),
      times: reminderTimes,
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

  int _doseCountFromText(String? value) {
    if (value == null) return 1;
    final match = RegExp(r'\d+').firstMatch(value);
    return (int.tryParse(match?.group(0) ?? '') ?? 1).clamp(1, 12);
  }

  int _slotForHour(int hour) {
    if (hour < 12) return 0;
    if (hour < 17) return 1;
    return 2;
  }

  TimeOfDay _defaultTimeForSlot(int index) => switch (index) {
    0 => const TimeOfDay(hour: 9, minute: 0),
    1 => const TimeOfDay(hour: 13, minute: 0),
    _ => const TimeOfDay(hour: 20, minute: 0),
  };
}
