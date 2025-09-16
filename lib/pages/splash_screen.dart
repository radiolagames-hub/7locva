
import 'dart:async';
import 'dart:io'; // Import for Platform check
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/services/notification_controller.dart';
import 'package:permission_handler/permission_handler.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndNavigate();
    });
  }

  Future<void> _requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
        channelKey: 'alarm_channel',
        permissions: [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.CriticalAlert,
        ],
      );
    }

    if (Platform.isAndroid) {
      if (await Permission.systemAlertWindow.isDenied) {
        await Permission.systemAlertWindow.request();
      }
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }
  }

  Future<void> _initializeAndNavigate() async {
    // Storing context-dependent objects before async operations.
    final settingsController = context.read<SettingsController>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await _requestPermissions();

      await AwesomeNotifications().initialize(
        'resource://drawable/res_app_icon',
        [
          NotificationChannel(
            channelKey: 'alarm_channel',
            channelName: 'Alarm Notifications',
            channelDescription: 'Notification channel for prayer alarms',
            defaultColor: const Color(0xFF7B4DFF),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            soundSource: 'resource://raw/custom_sound',
            criticalAlerts: true,
            locked: true,
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            defaultPrivacy: NotificationPrivacy.Public,
          ),
        ],
        debug: false, // Set to false for production
      );

      AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod,
      );

      await settingsController.loadSettings();

      if (!mounted) return;

      navigator.pushReplacementNamed('/home');

    } catch (e) {
      debugPrint('Error during initialization: $e');
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(content: Text('Initialization failed: $e')),
      );
      navigator.pushReplacementNamed('/home');
    }
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
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 1),
              child: const Text(
                'იტვირთება...',
                style: TextStyle(fontSize: 18, fontFamily: 'BpgNinoMtavruli'),
              ),
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
