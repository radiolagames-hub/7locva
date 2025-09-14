import 'package:flutter/material.dart';
import 'package:myapp/models/alarm_model.dart';
import 'package:myapp/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmProvider with ChangeNotifier {
  final List<Alarm> _alarms = [
    Alarm(id: 0, time: const TimeOfDay(hour: 6, minute: 0), text: "ლოცვები დილის 6 საათზე", image: "assets/images/06.jpg"),
    Alarm(id: 1, time: const TimeOfDay(hour: 9, minute: 0), text: "ლოცვები დილის 9 საათზე", image: "assets/images/09.jpg"),
    Alarm(id: 2, time: const TimeOfDay(hour: 12, minute: 0), text: "ლოცვები დღის 12 საათზე", image: "assets/images/12.jpg"),
    Alarm(id: 3, time: const TimeOfDay(hour: 15, minute: 0), text: "ლოცვები დღის 3 საათზე", image: "assets/images/15.jpg"),
    Alarm(id: 4, time: const TimeOfDay(hour: 18, minute: 0), text: "ლოცვა საღამოს 6 საათზე", image: "assets/images/18.jpg"),
    Alarm(id: 5, time: const TimeOfDay(hour: 21, minute: 0), text: "ლოცვა საღამოს 9 საათზე", image: "assets/images/21.jpg"),
    Alarm(id: 6, time: const TimeOfDay(hour: 0, minute: 0), text: "ლოცვა ღამის 12 საათზე", image: "assets/images/00.jpg"),
  ];

  List<Alarm> get alarms => _alarms;

  void updateAlarmTime(int id, TimeOfDay newTime) {
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index].time = newTime;
      scheduleAlarms();
      notifyListeners();
    }
  }

  Future<void> scheduleAlarms() async {
    final notificationService = NotificationService();
    for (final alarm in _alarms) {
      final now = tz.TZDateTime.now(tz.local);
      var scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, alarm.time.hour, alarm.time.minute);
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }
      await notificationService.scheduleDailyAlarms(alarm.id, alarm.text, 'Prayer Time', scheduledTime, alarm.image);
    }
  }
}
