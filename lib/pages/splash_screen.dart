
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/services/notification_controller.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the initialization process after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndNavigate();
    });
  }

  Future<void> _initializeAndNavigate() async {
    try {
      // Initialize Awesome Notifications
      await AwesomeNotifications().initialize(
        null, // Use default app icon
        [
          NotificationChannel(
            channelKey: 'alarm_channel',
            channelName: 'Alarm Notifications',
            channelDescription: 'Notification channel for prayer alarms',
            defaultColor: const Color(0xFF7B4DFF),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            criticalAlerts: true,
            locked: true,
          ),
        ],
        debug: false, // Set to false for production
      );

      // Set notification listeners
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
      );

      // Load app settings
      await context.read<SettingsController>().loadSettings();
    } catch (e) {
      print('Error during initialization: $e');
      // Continue to home screen even if some initialization fails
    }

    // Check if the widget is still mounted before navigating
    if (!mounted) return;

    // Navigate to the HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.church, size: 100),
            const SizedBox(height: 20),
            const Text(
              'იტვირთება...',
              style: TextStyle(fontSize: 18, fontFamily: 'BpgNinoMtavruli'),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
