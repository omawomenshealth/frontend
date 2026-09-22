import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../localization/generated/strings.g.dart';
import '../model/notification_entry.dart';
import '../viewmodel/notification_inbox.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  NotificationEntryType _selected = NotificationEntryType.app;

  @override
  Widget build(BuildContext context) {
    final labels = context.t.notifications.common;
    final entries = context.watch<NotificationInbox>().entriesFor(_selected);
    final isApp = _selected == NotificationEntryType.app;
    final accent = isApp ? OmaPalette.plum : context.omaTheme.primary;

    return Scaffold(
      backgroundColor: context.omaTheme.background,
      body: OmaSurface(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: context.omaTheme.foreground,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        labels.title,
                        style: OmaText.display(29).copyWith(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 22),
                child: Text(
                  labels.subtitle,
                  style: OmaText.body(13, color: context.omaTheme.muted),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.omaTheme.backgroundAlt,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: context.omaTheme.border),
                  ),
                  child: Row(
                    children: [
                      _tab(
                        NotificationEntryType.app,
                        labels.appTab,
                        Icons.notifications_none_rounded,
                      ),
                      _tab(
                        NotificationEntryType.log,
                        labels.logTab,
                        Icons.edit_note_rounded,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(28, 0, 28, 70),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isApp
                                      ? Icons.notifications_none_rounded
                                      : Icons.edit_note_rounded,
                                  size: 34,
                                  color: accent,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                isApp
                                    ? labels.appEmptyTitle
                                    : labels.logEmptyTitle,
                                textAlign: TextAlign.center,
                                style: OmaText.body(
                                  17,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                isApp
                                    ? labels.appEmptyDescription
                                    : labels.logEmptyDescription,
                                textAlign: TextAlign.center,
                                style: OmaText.body(
                                  13,
                                  color: context.omaTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            _entryCard(entries[index], accent),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(NotificationEntryType type, String label, IconData icon) {
    final selected = _selected == type;
    final accent = type == NotificationEntryType.app
        ? OmaPalette.plum
        : context.omaTheme.primary;
    return Expanded(
      child: InkWell(
        key: ValueKey('notification_tab_${type.name}'),
        onTap: () => setState(() => _selected = type),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? context.omaTheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected ? OmaShadows.soft : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? accent : context.omaTheme.muted,
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: OmaText.body(
                    13,
                    weight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected
                        ? context.omaTheme.foreground
                        : context.omaTheme.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entryCard(NotificationEntry entry, Color accent) {
    if (entry.type == NotificationEntryType.log &&
        entry.periodDetails != null) {
      return _periodEntryCard(entry, entry.periodDetails!);
    }
    final locale = Localizations.localeOf(context).toString();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.omaTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.omaTheme.border),
        boxShadow: OmaShadows.soft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              entry.type == NotificationEntryType.app
                  ? Icons.notifications_none_rounded
                  : Icons.check_rounded,
              size: 18,
              color: accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: OmaText.body(14, weight: FontWeight.w600),
                ),
                if (entry.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.description!,
                    style: OmaText.body(12, color: context.omaTheme.muted),
                  ),
                ],
                const SizedBox(height: 9),
                Text(
                  DateFormat('d MMM y · HH:mm', locale).format(entry.createdAt),
                  style: OmaText.caption(color: context.omaTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodEntryCard(
    NotificationEntry entry,
    PeriodNotificationDetails details,
  ) {
    final labels = context.t.notifications.common;
    final locale = Localizations.localeOf(context).toString();
    final flow = details.flow == null
        ? null
        : AppStrings.localizeStoredValue(details.flow!);
    final symptoms = details.symptoms
        .map(AppStrings.localizeStoredValue)
        .toList();

    return Container(
      key: const ValueKey('period_notification_card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [OmaPalette.periodLight, context.omaTheme.surface],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: OmaPalette.periodPrimary.withValues(alpha: 0.25),
        ),
        boxShadow: OmaShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: OmaPalette.periodPrimary.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  size: 19,
                  color: OmaPalette.periodPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  labels.periodEntry,
                  style: OmaText.body(
                    11,
                    weight: FontWeight.w700,
                    color: OmaPalette.periodPrimary,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Text(
                DateFormat.Hm(locale).format(entry.createdAt),
                style: OmaText.caption(color: context.omaTheme.muted),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(entry.title, style: OmaText.body(17, weight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(
            DateFormat.yMMMMd(locale).format(details.date),
            style: OmaText.body(12, color: context.omaTheme.muted),
          ),
          if (flow != null && flow.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: context.omaTheme.surface.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: OmaPalette.periodPrimary.withValues(alpha: 0.13),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    labels.periodFlow,
                    style: OmaText.body(12, color: context.omaTheme.muted),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      flow,
                      textAlign: TextAlign.end,
                      style: OmaText.body(
                        13,
                        weight: FontWeight.w600,
                        color: OmaPalette.periodPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (symptoms.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              labels.periodSymptoms,
              style: OmaText.body(11, color: context.omaTheme.muted),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final symptom in symptoms)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.omaTheme.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: OmaPalette.periodPrimary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      symptom,
                      style: OmaText.body(
                        11,
                        color: context.omaTheme.foreground,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
