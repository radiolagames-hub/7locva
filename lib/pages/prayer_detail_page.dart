import 'package:flutter/material.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/widgets/app_bottom_navigation.dart';
import 'package:myapp/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

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
    if (index == 2) {
      Navigator.pop(context);
    } else if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false, arguments: 0);
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false, arguments: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const int currentIndex = 0;

    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: '7 locva',
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                const Divider(),
                const SizedBox(height: 16.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  prayerText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: settingsController.fontSize,
                    height: 1.6,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: currentIndex,
            onTap: (index) => _onItemTapped(context, index),
          ),
        );
      },
    );
  }
}
