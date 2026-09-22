import 'package:flutter/foundation.dart';

import '../../../data/services/local_storage_service.dart';
import '../model/notification_entry.dart';

class NotificationInbox extends ChangeNotifier {
  NotificationInbox(this._storage)
    : _entries = _storage.loadNotificationEntries();

  final LocalStorageService _storage;
  final List<NotificationEntry> _entries;
  Future<void> _pendingWrite = Future<void>.value();

  List<NotificationEntry> entriesFor(NotificationEntryType type) =>
      List.unmodifiable(_entries.where((entry) => entry.type == type));

  Future<void> add({
    required NotificationEntryType type,
    required String title,
    String? description,
    PeriodNotificationDetails? periodDetails,
  }) async {
    _entries.insert(
      0,
      NotificationEntry(
        type: type,
        title: title,
        description: description,
        periodDetails: periodDetails,
        createdAt: DateTime.now(),
      ),
    );
    if (_entries.length > 50) _entries.removeRange(50, _entries.length);
    notifyListeners();
    final snapshot = List<NotificationEntry>.of(_entries);
    _pendingWrite = _pendingWrite.then((_) async {
      try {
        await _storage.saveNotificationEntries(snapshot);
      } catch (_) {
        // A storage failure must not interrupt the toast or a successful log save.
      }
    });
    await _pendingWrite;
  }
}
