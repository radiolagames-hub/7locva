
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/alarm_page.dart';
import 'package:myapp/providers/alarm_provider.dart';

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    try {
    final payload = receivedAction.payload;
    if (payload == null || payload['prayerId'] == null) {
      return;
    }

    final prayerId = int.parse(payload['prayerId']!);

    if (receivedAction.buttonKeyPressed == 'READ_PRAYER') {
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => AlarmPage(alarmId: prayerId),
            ),
          );
        }
    } else if (receivedAction.buttonKeyPressed == 'SNOOZE_ALARM') {
      final alarmProvider = AlarmProvider();
      await alarmProvider.snoozeAlarm(prayerId, 10);
    } else if (receivedAction.buttonKeyPressed == 'DISMISS_ALARM') {
      // No action needed, the notification is dismissed automatically
    }
    } catch (e) {
      print('Error handling notification action: $e');
    }
  }
}
