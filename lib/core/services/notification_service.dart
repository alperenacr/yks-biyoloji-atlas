import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _notificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> enableStreakReminder() async {
    // Basic daily repeat reminder. In a real app we might use tz.TZDateTime for precise scheduling
    const androidDetails = AndroidNotificationDetails(
      'streak_reminders',
      'Çalışma Hatırlatıcıları',
      channelDescription: 'Günlük çalışma serisini hatırlatan bildirimler',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Cancel previously scheduled notifications to avoid duplicates
    await _notificationsPlugin.cancelAll();
    
    // We can use periodicallyShow for a simple daily reminder since timezone package wasn't fully set up with TZ
    await _notificationsPlugin.periodicallyShow(
      id: 0,
      title: 'Zaman Geldi! 🧬',
      body: 'Serini bozma, Biyoloji Atlası seni bekliyor!',
      repeatInterval: RepeatInterval.daily,
      notificationDetails: platformDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> disableAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }
}
