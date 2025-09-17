
import 'package:flutter/material.dart';
import 'package:myapp/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/services/settings_service.dart';
import 'package:myapp/alarm_page.dart';
import 'package:myapp/pages/splash_screen.dart';
import 'dart:developer' as developer;
import 'package:myapp/widgets/custom_app_bar.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        const Color primarySeedColor = Color(0xFF7B4DFF);

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
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarySeedColor,
            brightness: Brightness.light,
            surface: const Color(0xFFFBFBFF),
          ),
          textTheme: appTextTheme.apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: primarySeedColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.2),
            titleTextStyle: TextStyle(
              fontFamily: 'Eka',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primarySeedColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(
                  fontFamily: 'BpgNinoMtavruli',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          ),
          iconTheme: const IconThemeData(color: primarySeedColor),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: primarySeedColor,
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: const TextStyle(fontFamily: 'BpgNinoMtavruli', fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontFamily: 'BpgNinoMtavruli'),
            backgroundColor: Colors.white,
            elevation: 8.0,
          ),
          tabBarTheme: TabBarThemeData(
            labelColor: primarySeedColor,
            unselectedLabelColor: Colors.grey.shade600,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: primarySeedColor, width: 2.0),
            ),
          ),
        );

        final ThemeData darkTheme = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primarySeedColor,
            brightness: Brightness.dark,
            surface: const Color(0xFF1A1A1A),
          ),
          textTheme: appTextTheme.apply(
              bodyColor: Colors.white.withAlpha(222),
              displayColor: Colors.white.withAlpha(222)
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.5),
            titleTextStyle: TextStyle(
              fontFamily: 'Eka',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primarySeedColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              textStyle: const TextStyle(
                  fontFamily: 'BpgNinoMtavruli',
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1E1E1E),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
               side: BorderSide(color: Colors.grey.shade800, width: 1),
            ),
             margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          ),
          iconTheme: IconThemeData(color: lightTheme.colorScheme.primary),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: lightTheme.colorScheme.primary,
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(fontFamily: 'BpgNinoMtavruli', fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontFamily: 'BpgNinoMtavruli'),
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 8.0,
          ),
          tabBarTheme: TabBarThemeData(
            labelColor: lightTheme.colorScheme.primary,
            unselectedLabelColor: Colors.grey.shade400,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: lightTheme.colorScheme.primary, width: 2.0),
            ),
          ),
        );

        return MaterialApp(
          navigatorKey: navigatorKey,
          title: '7 ლოცვა',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsController.themeMode,
          home: Scaffold(
            appBar: const CustomAppBar(title: '7 ლოცვა'),
            body: const SplashScreen(),
          ),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/alarm': (context) {
              final int alarmId =
                  ModalRoute.of(context)!.settings.arguments as int;
              return AlarmPage(alarmId: alarmId);
            },
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
