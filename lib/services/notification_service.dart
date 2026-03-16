import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // MUST initialize timezone data before any zonedSchedule calls
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(settings: initializationSettings);
  }

  static Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    // Requests the "Allow Notifications" popup on Android 13+
    await androidImplementation?.requestNotificationsPermission();

    // Requests permission for exact alarms (watering schedules)
    await androidImplementation?.requestExactAlarmsPermission();
  }

  static Future<void> schedulePlantReminder({
    required int plantId,
    required String plantName,
    required int wateringIntervalDays,
    required int fertilizingIntervalDays,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id: plantId,
      scheduledDate: tz.TZDateTime.now(
        tz.local,
      ).add(Duration(days: wateringIntervalDays)),
      title: 'Time to water your $plantName!',
      body: 'Your plant needs a drink to stay healthy.',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'watering_channel',
          'Watering Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    await _notificationsPlugin.zonedSchedule(
      id: plantId + 5000,
      title: 'Feeding time for $plantName!',
      body: 'Time to apply some fertilizer for better growth.',
      scheduledDate: tz.TZDateTime.now(
        tz.local,
      ).add(Duration(days: fertilizingIntervalDays)),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'fertilizer_channel',
          'Fertilizer Reminders',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'plant_$plantId',
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
    await _notificationsPlugin.cancel(id: id + 5000);
  }
}
