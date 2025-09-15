import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init(void Function(NotificationResponse)? onDidReceiveNotificationResponse) async {
    tz.initializeTimeZones();
    final AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel', // A unique channel ID
      'Alarm Channel', // A channel name
      channelDescription: 'This channel is used for alarm notifications.', // A channel description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      fullScreenIntent: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleDailyAlarms(int id, String title, String body, tz.TZDateTime scheduledTime, String imagePath) async {
    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath),
      largeIcon: FilePathAndroidBitmap(imagePath),
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: body,
      htmlFormatSummaryText: true,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_alarm_channel',
          'Daily Alarms',
          channelDescription: 'Channel for daily alarms',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
          fullScreenIntent: true, // This is the key for full-screen notification
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: id.toString(), // Pass the alarm ID as a payload
    );
  }

  Future<void> snooze(int id, String title, String body, int minutes, String imagePath) async {
    final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));
    await scheduleDailyAlarms(id, title, body, scheduledTime, imagePath);
  }

  Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
