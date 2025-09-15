
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/widgets/app_bottom_navigation.dart';

class PrayerDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String prayerText;

  const PrayerDetailPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.prayerText,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == 3) {
      SystemNavigator.pop(); // Exit the app
    } else {
      // Pop the current page and pass the selected index back to the previous screen (HomeScreen)
      Navigator.pop(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // We set the current index to 0 (Home) because this page is conceptually part of the 'Home' flow.
    const int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('7 locva', style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        // The back button is automatically added by Navigator.push, which is what we want.
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
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
                  imagePath,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              prayerText,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex, // Always highlight 'Home'
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
