import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/prayer_data.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmProvider with ChangeNotifier {
  Future<void> scheduleAlarms() async {
    try {
      for (int i = 0; i < prayerList.length; i++) {
        final prayer = prayerList[i];
        final timeParts = prayer.time.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: i,
            channelKey: 'alarm_channel',
            title: prayer.title,
            body: 'დააჭირეთ ლოცვის წასაკითხად',
            wakeUpScreen: true,
            fullScreenIntent: true,
            category: NotificationCategory.Alarm,
            payload: {'prayerId': i.toString()},
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'READ_PRAYER',
              label: 'წაკითხვა',
            ),
            NotificationActionButton(
              key: 'SNOOZE_ALARM',
              label: 'გადადება',
            ),
            NotificationActionButton(
              key: 'DISMISS_ALARM',
              label: 'დახურვა',
              isDangerousOption: true,
            ),
          ],
          schedule: NotificationCalendar(
            hour: hour,
            minute: minute,
            second: 0,
            millisecond: 0,
            repeats: true,
          ),
        );
      }
    } catch (e) {
      print('Error scheduling alarms: $e');
    }
  }

  Future<void> snoozeAlarm(int id, int minutes) async {
    final prayer = prayerList[id];
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(Duration(minutes: minutes));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'alarm_channel',
        title: '${prayer.title} (Snoozed)',
        body: 'დააჭირეთ ლოცვის წასაკითხად',
        wakeUpScreen: true,
        fullScreenIntent: true,
        category: NotificationCategory.Alarm,
        payload: {'prayerId': id.toString()},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'READ_PRAYER',
          label: 'წაკითხვა',
        ),
        NotificationActionButton(
          key: 'SNOOZE_ALARM',
          label: 'გადადება',
        ),
        NotificationActionButton(
          key: 'DISMISS_ALARM',
          label: 'დახურვა',
          isDangerousOption: true,
        ),
      ],
      schedule: NotificationCalendar(
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
        second: scheduledTime.second,
        repeats: false, // Snooze does not repeat
      ),
    );
  }

  Future<void> updateSingleAlarm(int prayerId, String newTime) async {
    await AwesomeNotifications().cancel(prayerId);

    final prayer = prayerList[prayerId];
    final timeParts = newTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: prayerId,
        channelKey: 'alarm_channel',
        title: prayer.title,
        body: 'დააჭირეთ ლოცვის წასაკითხად',
        wakeUpScreen: true,
        fullScreenIntent: true,
        category: NotificationCategory.Alarm,
        payload: {'prayerId': prayerId.toString()},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'READ_PRAYER',
          label: 'წაკითხვა',
        ),
        NotificationActionButton(
          key: 'SNOOZE_ALARM',
          label: 'გადადება',
        ),
        NotificationActionButton(
          key: 'DISMISS_ALARM',
          label: 'დახურვა',
          isDangerousOption: true,
        ),
      ],
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }
}