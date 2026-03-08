import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // import sharedPreferencesProvider
import '../../core/services/notification_service.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final notifService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(prefs, notifService);
});

class NotificationNotifier extends StateNotifier<bool> {
  final _prefs;
  final NotificationService _notificationService;
  static const _key = 'notifications_enabled';

  NotificationNotifier(this._prefs, this._notificationService)
      : super(_prefs.getBool(_key) ?? false) {
    if (state) {
      // Re-enable in case device booted or we want to ensure scheduling
      _notificationService.enableStreakReminder();
    }
  }

  Future<void> toggleNotifications() async {
    final newState = !state;
    state = newState;
    await _prefs.setBool(_key, newState);

    if (newState) {
      await _notificationService.enableStreakReminder();
    } else {
      await _notificationService.disableAllReminders();
    }
  }
}
