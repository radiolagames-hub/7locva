
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/data/prayer_data.dart';
import 'package:myapp/models/prayer.dart';
import 'package:myapp/pages/blessing_page.dart';
import 'package:myapp/pages/calendar_page.dart';
import 'package:myapp/pages/prayer_detail_page.dart';
import 'package:myapp/pages/settings_page.dart';

class HomeScreen extends StatefulWidget {
  final int? initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late List<Prayer> _prayers;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _prayers = List.from(prayerList);

    if (widget.initialTabIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final prayer = _prayers[widget.initialTabIndex!];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrayerDetailPage(
                imagePath: prayer.imagePath,
                title: prayer.title,
                prayerText: prayer.prayerText,
              ),
            ),
          );
        }
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      SystemNavigator.pop();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _updatePrayerTime(int index, int hourChange) {
    setState(() {
      final prayer = _prayers[index];
      final timeParts = prayer.time.split(':');
      int hour = int.parse(timeParts[0]);

      int newHour = hour;

      if (index == 0) {
        newHour = (hour + hourChange);
        if (newHour < 6) newHour = 8;
        if (newHour > 8) newHour = 6;
      } else if (index == _prayers.length - 1) {
        newHour = (hour + hourChange);
        if (newHour < 22) newHour = 23;
        if (newHour > 23) newHour = 22;
      }

      _prayers[index] = prayer.copyWith(
        time: '${newHour.toString().padLeft(2, '0')}:00',
        imagePath: 'assets/images/${newHour.toString().padLeft(2, '0')}.jpg',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String formatTime(String time24) {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    }

    final List<Widget> widgetOptions = <Widget>[
      _buildPrayerList(formatTime),
      const CalendarPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('7 locva', style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'მთავარი',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'კალენდარი',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'პარამეტრები',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'გასვლა',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildPrayerList(String Function(String) formatTime) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlessingPage()),
              );
            },
            icon: const Icon(Icons.video_library),
            label: const Text('პატრიარქის კურთხევა'),
            style: theme.elevatedButtonTheme.style,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            itemCount: _prayers.length,
            itemBuilder: (context, index) {
              final prayer = _prayers[index];
              final time = formatTime(prayer.time);

              bool isFirst = index == 0;
              bool isLast = index == _prayers.length - 1;
              bool showTimeChange = isFirst || isLast;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 1,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrayerDetailPage(
                          imagePath: prayer.imagePath,
                          title: prayer.title,
                          prayerText: prayer.prayerText,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.alarm, color: theme.primaryColor, size: 28),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    time,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    prayer.title,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                      if (showTimeChange)
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor.withAlpha(128),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => _updatePrayerTime(index, -1),
                                ),
                                Text(
                                  'დროის შეცვლა',
                                  style: theme.textTheme.labelLarge,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _updatePrayerTime(index, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
