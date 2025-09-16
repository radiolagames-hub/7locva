
import 'package:flutter/material.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/services/settings_service.dart';
import 'package:myapp/alarm_page.dart';
import 'package:myapp/pages/splash_screen.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:myapp/pages/test_reminder_page.dart';
import 'dart:developer' as developer;


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void showTestNotification() {
  try {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 123,
        channelKey: 'basic_channel',
        title: 'სატესტო შეტყობინება',
        body: 'ეს არის სატესტო შეტყობინება.',
        fullScreenIntent: true,
        autoDismissible: false,
        backgroundColor: Colors.red,
        payload: {'screen': 'test_reminder'}, 
      ),
    );
  } catch (e) {
    developer.log('Error creating test notification: $e', name: 'main');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  
  try {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        )
      ],
      debug: true,
    );
  } catch (e) {
    developer.log('Error initializing notifications: $e', name: 'main');
  }

  final settingsController = SettingsController(SettingsService());
  
  try {
    await settingsController.loadSettings();
  } catch (e) {
    developer.log('Error loading settings: $e', name: 'main');
  }

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction receivedAction) async {
          try {
            if (receivedAction.payload != null && receivedAction.payload!['screen'] == 'test_reminder') {
              navigatorKey.currentState?.pushNamed('/test_reminder');
            }
          } catch (e) {
            developer.log('Error handling notification action: $e', name: 'main');
          }
        },
      );
    } catch (e) {
      developer.log('Error setting notification listeners: $e', name: 'main');
    }
    
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        final TextTheme appTextTheme = TextTheme(
          displayLarge: const TextStyle(
              fontFamily: 'BpgNinoMtavruli',
              fontSize: 57,
              fontWeight: FontWeight.bold),
          titleLarge: const TextStyle(
              fontFamily: 'BpgNinoMtavruli',
              fontSize: 22,
              fontWeight: FontWeight.w500),
          bodyMedium: const TextStyle(fontFamily: 'Eka', fontSize: 16),
          bodyLarge: TextStyle(
              fontFamily: 'Eka', fontSize: settingsController.fontSize),
          labelLarge: const TextStyle(
              fontFamily: 'BpgNinoMtavruli',
              fontSize: 14,
              fontWeight: FontWeight.w600),
        );

        final ThemeData lightTheme = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          cardColor: const Color(0xFFF8F8F8),
          textTheme: appTextTheme.apply(
              bodyColor: const Color(0xFF1A1A1A),
              displayColor: const Color(0xFF1A1A1A)),
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
          textTheme: appTextTheme.apply(
              bodyColor: const Color(0xFFFFFFFF),
              displayColor: const Color(0xFFFFFFFF)),
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
          navigatorKey: navigatorKey,
          title: '7 ლოცვა',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsController.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
            '/alarm': (context) {
              final int alarmId =
                  ModalRoute.of(context)!.settings.arguments as int;
              return AlarmPage(alarmId: alarmId);
            },
            '/test_reminder': (context) => const TestReminderPage(),

          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
