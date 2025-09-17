import 'package:flutter/material.dart';
import 'package:myapp/data/prayer_data.dart';
import 'package:myapp/pages/prayer_detail_page.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:provider/provider.dart';

class AlarmScreen extends StatelessWidget {
  final int prayerId;

  const AlarmScreen({super.key, required this.prayerId});

  @override
  Widget build(BuildContext context) {
    final prayer = prayerList[prayerId];
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(prayer.imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(128),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ლოცვის დროა!',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Eka',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      prayer.time,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSnoozeButton(context, '2 წუთით', 2),
                        _buildSnoozeButton(context, '5 წუთით', 5),
                      ],
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrayerDetailPage(
                              prayerText: prayer.prayerText,
                              title: prayer.title,
                              imagePath: prayer.imagePath,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(32),
                        elevation: 8,
                        shadowColor: Colors.green.shade200.withAlpha(178),
                      ),
                      child: const Text(
                        'წაკითხვა',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'BpgNinoMtavruli',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnoozeButton(BuildContext context, String label, int minutes) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<AlarmProvider>(context, listen: false).snoozeAlarm(prayerId, minutes);
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
