
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/alarm_page.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'dart:developer' as developer;

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
        developer.log('Invalid payload in notification action', name: 'notification_controller');
        return;
      }

      final prayerIdString = payload['prayerId']!;
      final prayerId = int.tryParse(prayerIdString);
      
      if (prayerId == null) {
        developer.log('Invalid prayer ID: $prayerIdString', name: 'notification_controller');
        return;
      }

      if (receivedAction.buttonKeyPressed == 'READ_PRAYER') {
        if (navigatorKey.currentState != null) {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => AlarmPage(alarmId: prayerId),
            ),
          );
        }
      } else if (receivedAction.buttonKeyPressed == 'SNOOZE_ALARM') {
        try {
          final alarmProvider = AlarmProvider();
          await alarmProvider.snoozeAlarm(prayerId, 10);
        } catch (e) {
          developer.log('Error snoozing alarm: $e', name: 'notification_controller');
        }
      } else if (receivedAction.buttonKeyPressed == 'DISMISS_ALARM') {
        // No action needed, the notification is dismissed automatically
        developer.log('Alarm dismissed for prayer ID: $prayerId', name: 'notification_controller');
      }
    } catch (e) {
      developer.log('Error handling notification action: $e', name: 'notification_controller');
    }
  }
}
