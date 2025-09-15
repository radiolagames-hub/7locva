
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:myapp/services/notification_service.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AlarmProvider()),
        ChangeNotifierProvider.value(value: settingsController),
      ],
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
    _requestPermissionsAndScheduleAlarms();
  }

  Future<void> _requestPermissionsAndScheduleAlarms() async {
    final status = await Permission.scheduleExactAlarm.request();
    if (status.isGranted) {
      if (mounted) {
        await Provider.of<AlarmProvider>(context, listen: false).scheduleAlarms();
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
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
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        final TextTheme appTextTheme = TextTheme(
          displayLarge: TextStyle(
              fontFamily: 'BpgNinoMtavruli',
              fontSize: 57,
              fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
              fontFamily: 'BpgNinoMtavruli',
              fontSize: 22,
              fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(
              fontFamily: 'Eka', fontSize: 16),
          bodyLarge: TextStyle(
              fontFamily: 'Eka', fontSize: settingsController.fontSize),
          labelLarge: TextStyle(
              fontFamily: 'BpgNinoMtavruli',
              fontSize: 14,
              fontWeight: FontWeight.w600),
        );

        final ThemeData lightTheme = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          cardColor: const Color(0xFFF8F8F8),
          textTheme: appTextTheme.apply(bodyColor: const Color(0xFF1A1A1A), displayColor: const Color(0xFF1A1A1A)),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF7B4DFF),
            onPrimary: Colors.white,
            secondary: Color(0xFFEDE5FF),
            onSecondary: Color(0xFF7B4DFF),
            surface: Color(0xFFFFFFFF),
            onSurface: Color(0xFF1A1A1A),
            error: Colors.red,
            onError: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF1A1A1A),
            elevation: 0,
            titleTextStyle: TextStyle(
                fontFamily: 'Eka',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF7B4DFF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                  fontFamily: 'BpgNinoMtavruli',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ).copyWith(elevation: ButtonStyleButton.allOrNull<double>(0.0)),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF7B4DFF)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFF7B4DFF),
            unselectedItemColor: Color(0xFF999999),
            selectedLabelStyle: TextStyle(fontFamily: 'BpgNinoMtavruli'),
            unselectedLabelStyle: TextStyle(fontFamily: 'BpgNinoMtavruli'),
          ),
          tabBarTheme: const TabBarThemeData(
            labelColor: Color(0xFF7B4DFF),
            unselectedLabelColor: Color(0xFF999999),
          ),
        );

        final ThemeData darkTheme = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
           textTheme: appTextTheme.apply(bodyColor: const Color(0xFFFFFFFF), displayColor: const Color(0xFFFFFFFF)),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFBB86FC),
            onPrimary: Colors.black,
            secondary: Color(0xFF2C1F4B),
            onSecondary: Color(0xFFBB86FC),
            surface: Color(0xFF121212),
            onSurface: Color(0xFFFFFFFF),
            error: Colors.red,
            onError: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            foregroundColor: Color(0xFFFFFFFF),
            elevation: 0,
            titleTextStyle: TextStyle(
                fontFamily: 'Eka',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFBB86FC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                  fontFamily: 'BpgNinoMtavruli',
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ).copyWith(elevation: ButtonStyleButton.allOrNull<double>(0.0)),
          ),
          iconTheme: const IconThemeData(color: Color(0xFFBB86FC)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFFBB86FC),
            unselectedItemColor: Color(0xFF888888),
            selectedLabelStyle: TextStyle(fontFamily: 'BpgNinoMtavruli'),
            unselectedLabelStyle: TextStyle(fontFamily: 'BpgNinoMtavruli'),
          ),
          tabBarTheme: const TabBarThemeData(
            labelColor: Color(0xFFBB86FC),
            unselectedLabelColor: Color(0xFF888888),
          ),
        );

        return MaterialApp(
          title: '7 ლოცვა',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsController.themeMode,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
