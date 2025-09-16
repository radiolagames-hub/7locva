import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/prayer_data.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer' as developer;

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
      developer.log('Error scheduling alarms: $e', name: 'alarm_provider');
      rethrow;
    }
  }

  Future<void> snoozeAlarm(int id, int minutes) async {
    try {
      if (id < 0 || id >= prayerList.length) {
        throw ArgumentError('Invalid prayer ID: $id');
      }
      
      final prayer = prayerList[id];
      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = now.add(Duration(minutes: minutes));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id + 1000, // Use different ID for snoozed notifications
          channelKey: 'alarm_channel',
          title: '${prayer.title} (გადადებული)',
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
    } catch (e) {
      developer.log('Error snoozing alarm: $e', name: 'alarm_provider');
      rethrow;
    }
  }

  Future<void> updateSingleAlarm(int prayerId, String newTime) async {
    try {
      if (prayerId < 0 || prayerId >= prayerList.length) {
        throw ArgumentError('Invalid prayer ID: $prayerId');
      }
      
      await AwesomeNotifications().cancel(prayerId);

      final prayer = prayerList[prayerId];
      final timeParts = newTime.split(':');
      
      if (timeParts.length != 2) {
        throw ArgumentError('Invalid time format: $newTime');
      }
      
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw ArgumentError('Invalid time values: $hour:$minute');
      }

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
    } catch (e) {
      developer.log('Error updating alarm: $e', name: 'alarm_provider');
      rethrow;
    }
  }
}