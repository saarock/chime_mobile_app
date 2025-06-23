import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'video_call_channel',
      'Video Call Notifications',
      channelDescription: 'Notifications for video call events',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const platformDetails = NotificationDetails(android: androidDetails);
    await _notifications.show(0, title, body, platformDetails);
  }
}
