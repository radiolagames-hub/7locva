
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/pages/home_screen.dart';

class PrayerDetailPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String prayerText;

  const PrayerDetailPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.prayerText,
  });

  @override
  State<PrayerDetailPage> createState() => _PrayerDetailPageState();
}

class _PrayerDetailPageState extends State<PrayerDetailPage> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 3) {
      SystemNavigator.pop();
    } else if (index == 0) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(initialTabIndex: index)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('7 locva', style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BpgNinoMtavruli',
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  widget.imagePath,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.prayerText,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
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
      ),
    );
  }
}
