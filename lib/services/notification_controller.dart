
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart'; // To access navigatorKey
import 'package:myapp/providers/alarm_provider.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.payload == null) return;

    final prayerId = int.tryParse(receivedAction.payload!['prayerId'] ?? '');
    if (prayerId == null) return;

    final BuildContext? context = navigatorKey.currentContext;
    if (context == null) return;

    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    switch (receivedAction.buttonKeyPressed) {
      case 'READ_PRAYER':
        try {
          navigatorKey.currentState?.pushNamed('/alarm', arguments: prayerId);
        } catch (e) {
          developer.log('Error navigating to alarm page: $e', name: 'notification_controller');
        }
        break;
      case 'SNOOZE_ALARM':
        try {
          await alarmProvider.snoozeAlarm(prayerId, 5);
        } catch (e) {
          developer.log('Error snoozing alarm: $e', name: 'notification_controller');
        }
        break;
      case 'DISMISS_ALARM':
        // The alarm is dismissed by the system, so no specific action is needed here,
        // unless you want to log or track this event.
        break;
      default:
        break;
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code to handle when a notification is created
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code to handle when a notification is displayed
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code to handle when a notification is dismissed
  }
}
