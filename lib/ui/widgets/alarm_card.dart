import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/alarm_model.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/screens/evening_prayer_page.dart';
import 'package:myapp/screens/midnight_prayer_page.dart';
import 'package:myapp/screens/morning_prayer_page.dart';
import 'package:myapp/screens/nine_oclock_prayer_page.dart';
import 'package:myapp/screens/six_oclock_prayer_page.dart';
import 'package:myapp/screens/three_oclock_prayer_page.dart';
import 'package:myapp/screens/twelve_oclock_prayer_page.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;

  const AlarmCard({super.key, required this.alarm});

  void _navigateToPrayerScreen(BuildContext context) {
    Widget prayerPage;
    switch (alarm.id) {
      case 0:
        prayerPage = const MorningPrayerPage();
        break;
      case 1:
        prayerPage = const NineOClockPrayerPage();
        break;
      case 2:
        prayerPage = const TwelveOClockPrayerPage();
        break;
      case 3:
        prayerPage = const ThreeOClockPrayerPage();
        break;
      case 4:
        prayerPage = const SixOClockPrayerPage();
        break;
      case 5:
        prayerPage = const EveningPrayerPage();
        break;
      case 6:
        prayerPage = const MidnightPrayerPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => prayerPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    final isAdjustable = alarm.id == 0 || alarm.id == (alarmProvider.alarms.length - 1);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _navigateToPrayerScreen(context),
              borderRadius: BorderRadius.circular(15),
              child: Row(
                children: [
                  Icon(
                    Icons.alarm,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alarm.time.format(context),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alarm.text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            if (isAdjustable) ...[
              const Divider(height: 20, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: 'Decrease by 1 hour',
                    onPressed: () {
                      if (alarm.id == 0) {
                        if (alarm.time.hour > 6) {
                          final newHour = alarm.time.hour - 1;
                          alarmProvider.updateAlarmTime(alarm.id, TimeOfDay(hour: newHour, minute: alarm.time.minute));
                        }
                      } else {
                        if (alarm.time.hour > 22) {
                          final newHour = alarm.time.hour - 1;
                          alarmProvider.updateAlarmTime(alarm.id, TimeOfDay(hour: newHour, minute: alarm.time.minute));
                        }
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "დროის შეცვლა",
                      style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Increase by 1 hour',
                    onPressed: () {
                      if (alarm.id == 0) {
                        if (alarm.time.hour < 8) {
                          final newHour = alarm.time.hour + 1;
                          alarmProvider.updateAlarmTime(alarm.id, TimeOfDay(hour: newHour, minute: alarm.time.minute));
                        }
                      } else {
                        if (alarm.time.hour < 23) {
                          final newHour = alarm.time.hour + 1;
                          alarmProvider.updateAlarmTime(alarm.id, TimeOfDay(hour: newHour, minute: alarm.time.minute));
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
