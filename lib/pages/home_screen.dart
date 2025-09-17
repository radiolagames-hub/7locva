
import 'package:flutter/material.dart';
import 'package:myapp/data/prayer_data.dart';
import 'package:myapp/models/prayer.dart';
import 'package:myapp/pages/blessing_page.dart';
import 'package:myapp/pages/prayer_detail_page.dart';
import 'package:myapp/pages/settings_page.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/widgets/app_bottom_navigation.dart';
import 'package:myapp/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'dart:io';

class HomeScreen extends StatefulWidget {
  final int? initialTabIndex;

  const HomeScreen({super.key, this.initialTabIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late List<Prayer> _prayers;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex ?? 0;
    _prayers = List.from(prayerList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTabIndex != null) {
        _pageController.jumpToPage(widget.initialTabIndex!);
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Exit the app
      exit(0);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  void _updatePrayerTime(int index, int hourChange, [int minuteChange = 0]) {
    setState(() {
      final prayer = _prayers[index];
      final timeParts = prayer.time.split(':');
      
      if (timeParts.length != 2) {
        developer.log('Invalid time format: ${prayer.time}', name: 'home_screen');
        return;
      }
      
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      final newTimeValue = TimeOfDay(hour: hour, minute: minute)
          .replacing(hour: hour + hourChange, minute: minute + minuteChange);

      final newTime = '${newTimeValue.hour.toString().padLeft(2, '0')}:${newTimeValue.minute.toString().padLeft(2, '0')}';

      _prayers[index] = prayer.copyWith(
        time: newTime,
        imagePath: 'assets/images/${newTimeValue.hour.toString().padLeft(2, '0')}.jpg',
      );
      
      try {
        Provider.of<AlarmProvider>(context, listen: false)
            .updateSingleAlarm(index, newTime);
      } catch (e) {
        developer.log('Error updating alarm: $e', name: 'home_screen');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ალარმის განახლება ვერ მოხერხდა', style: TextStyle(fontFamily: 'BpgNinoMtavruli')),
            ),
          );
        }
      }
    });
  }

  Future<void> _navigateTo(BuildContext context, Widget page) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (result is int) {
      _onItemTapped(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '7 locva'),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _buildPrayerList(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPrayerList() {
    final theme = Theme.of(context);

    String formatTime(String time24) {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateTo(context, const BlessingPage()),
              icon: const Icon(Icons.video_library_outlined),
              label: const Text('პატრიარქის კურთხევა'),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: _prayers.length,
            itemBuilder: (context, index) {
              final prayer = _prayers[index];
              final time = formatTime(prayer.time);

              bool isFirst = index == 0;
              bool isLast = index == _prayers.length - 1;
              bool showTimeChange = isFirst || isLast;

              return Card(
                child: InkWell(
                  onTap: () async {
                    if (showTimeChange) {
                      final newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.parse('2022-01-01 ${prayer.time}:00')),
                      );
                      if (newTime != null) {
                        _updatePrayerTime(index, newTime.hour - int.parse(prayer.time.split(':')[0]), newTime.minute - int.parse(prayer.time.split(':')[1]));
                      }
                    } else {
                      _navigateTo(
                        context,
                        PrayerDetailPage(
                          imagePath: prayer.imagePath,
                          title: prayer.title,
                          prayerText: prayer.prayerText,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                        child: Row(
                          children: [
                            Icon(Icons.alarm, color: theme.colorScheme.primary, size: 28),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    time,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    prayer.title,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withAlpha(204),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface.withAlpha(127)),
                          ],
                        ),
                      ),
                      if (showTimeChange)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer.withAlpha(102),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _updatePrayerTime(index, -1),
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                                Text(
                                  'დროის შეცვლა',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => _updatePrayerTime(index, 1),
                                  color: theme.colorScheme.onSecondaryContainer,
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
