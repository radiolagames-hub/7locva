import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/blessing_page.dart';
import 'package:myapp/pages/morning_prayer_page.dart';
import 'package:myapp/pages/nine_oclock_prayer_page.dart';
import 'package:myapp/pages/six_oclock_prayer_page.dart';
import 'package:myapp/pages/three_oclock_prayer_page.dart';
import 'package:myapp/pages/twelve_oclock_prayer_page.dart';
import 'package:myapp/pages/twenty_one_oclock_prayer_page.dart';
import 'package:myapp/pages/twenty_three_oclock_prayer_page.dart';

class PrayerInfo {
  TimeOfDay time;
  final String title;
  final Widget page;
  final bool isAdjustable;

  PrayerInfo({
    required this.time,
    required this.title,
    required this.page,
    this.isAdjustable = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<PrayerInfo> prayerList;

  @override
  void initState() {
    super.initState();
    prayerList = [
      PrayerInfo(
        time: const TimeOfDay(hour: 6, minute: 0),
        title: 'ლოცვები დილის 6 საათზე',
        page: const MorningPrayerPage(),
        isAdjustable: true,
      ),
      PrayerInfo(
        time: const TimeOfDay(hour: 9, minute: 0),
        title: 'ლოცვები დილის 9 საათზე',
        page: const NineOClockPrayerPage(),
      ),
      PrayerInfo(
        time: const TimeOfDay(hour: 12, minute: 0),
        title: 'ლოცვები დღის 12 საათზე',
        page: const TwelveOClockPrayerPage(),
      ),
      PrayerInfo(
        time: const TimeOfDay(hour: 15, minute: 0),
        title: 'ლოცვები დღის 3 საათზე',
        page: const ThreeOClockPrayerPage(),
      ),
      PrayerInfo(
        time: const TimeOfDay(hour: 18, minute: 0),
        title: 'ლოცვები საღამოს 6 საათზე',
        page: const SixOClockPrayerPage(),
      ),
      PrayerInfo(
        time: const TimeOfDay(hour: 21, minute: 0),
        title: 'ლოცვები საღამოს 9 საათზე',
        page: const TwentyOneOClockPrayerPage(),
      ),
      PrayerInfo(
        time: const TimeOfDay(hour: 23, minute: 0),
        title: 'ლოცვები ძილის წინ',
        page: const TwentyThreeOClockPrayerPage(),
        isAdjustable: true,
      ),
    ];
  }

  void _changeTime(int index, int hour) {
    setState(() {
      final currentTime = prayerList[index].time;
      // Prevent going before 5 AM and after 8 AM for morning prayer
      if (index == 0 && (currentTime.hour + hour < 5 || currentTime.hour + hour > 8)) {
        return;
      }
      // Prevent going before 10 PM and after 11 PM for night prayer
      if (index == prayerList.length - 1 && (currentTime.hour + hour < 22 || currentTime.hour + hour > 23)) {
        return;
      }
      
      final newTime = currentTime.replacing(hour: currentTime.hour + hour);
      prayerList[index].time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('7 ლოცვა'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BlessingPage()),
                );
              },
              icon: const Icon(Icons.video_library),
              label: const Text('პატრიარქის კურთხევა'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: prayerList.length,
                itemBuilder: (context, index) {
                  return _buildPrayerCard(
                    context,
                    prayerList[index],
                    index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerCard(BuildContext context, PrayerInfo prayerInfo, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => prayerInfo.page,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.alarm, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayerInfo.time.format(context),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(prayerInfo.title),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          if (prayerInfo.isAdjustable) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _changeTime(index, -1),
                  ),
                  const Text('დროის შეცვლა'),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _changeTime(index, 1),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
