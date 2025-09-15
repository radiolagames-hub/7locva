import 'package:flutter/material.dart';
import 'package:myapp/data/prayer_data.dart';
import 'package:myapp/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmProvider with ChangeNotifier {
  Future<void> scheduleAlarms() async {
    final notificationService = NotificationService();
    for (int i = 0; i < prayerList.length; i++) {
      final prayer = prayerList[i];
      final timeParts = prayer.time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final now = tz.TZDateTime.now(tz.local);
      var scheduledTime = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, hour, minute);
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await notificationService.scheduleDailyAlarms(
        i, // Use the index as the id
        prayer.title,
        'Prayer Time',
        scheduledTime,
        prayer.imagePath,
      );
    }
  }
}
