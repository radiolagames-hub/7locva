
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  final alarmProvider = AlarmProvider();
  await alarmProvider.scheduleAlarms();
  runApp(
    ChangeNotifierProvider.value(
      value: alarmProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.scheduleExactAlarm.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
                'This app needs permission to schedule alarms to notify you of prayer times. Please enable this permission in the app settings.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;

    const TextTheme appTextTheme = TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'BpgNinoMtavruli',
          fontSize: 57,
          fontWeight: FontWeight.bold),
      titleLarge: TextStyle(
          fontFamily: 'BpgNinoMtavruli',
          fontSize: 22,
          fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontFamily: 'Eka', fontSize: 16),
      labelLarge: TextStyle(
          fontFamily: 'BpgNinoMtavruli',
          fontSize: 14,
          fontWeight: FontWeight.w600),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
            fontFamily: 'BpgNinoMtavruli',
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
              fontFamily: 'BpgNinoMtavruli',
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ),
    );

    return MaterialApp(
      title: '7 ლოცვა',
      theme: lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
