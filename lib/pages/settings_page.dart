import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/widgets/sound_selection.dart';
import 'package:myapp/widgets/custom_app_bar.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:myapp/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsController>(context, listen: false).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const CustomAppBar(title: 'პარამეტრები'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'შეხსენებები'),
          _buildNotificationToggle(context, settingsController, theme),
          const SizedBox(height: 16),
          _buildTestReminderButton(context),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'შეხსენების ხმა'),
          const SoundSelection(),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'თემა'),
          _buildThemeSelector(context, settingsController, theme),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'ლოცვების ტექსტის ზომა'),
          _buildFontSizeSlider(context, settingsController, theme),
        ],
      ),
    );
  }

  Widget _buildTestReminderButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        AndroidAlarmManager.oneShot(
          const Duration(seconds: 5),
          12345, // Unique ID for the alarm
          showTestNotification, // The top-level function to be executed
          exact: true,
          wakeup: true,
        );
      },
      child: const Text('სატესტო შეხსენება'),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildNotificationToggle(
      BuildContext context, SettingsController controller, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text('აპლიკაციის ზემოდან გადადება', style: theme.textTheme.bodyLarge),
        subtitle: Text('საჭიროა შეხსენებების გამოსაჩენად', style: theme.textTheme.bodySmall),
        value: controller.notificationsEnabled,
        onChanged: (bool value) async {
          if (value) {
            final status = await Permission.systemAlertWindow.request();
            if (status.isGranted) {
              controller.setNotificationsEnabled(value);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'ნებართვა მიუღებელია. ვიჯეტს ეს ნებართვა სჭირდება ფუნქციონირებისთვის.',
                      style: TextStyle(fontFamily: 'BpgNinoMtavruli'),
                    ),
                  ),
                );
              }
            }
          } else {
            controller.setNotificationsEnabled(value);
          }
        },
      ),
    );
  }

  Widget _buildThemeSelector(
      BuildContext context, SettingsController controller, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SegmentedButton<ThemeMode>(
          segments: const <ButtonSegment<ThemeMode>>[
            ButtonSegment<ThemeMode>(
                value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
            ButtonSegment<ThemeMode>(
                value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
            ButtonSegment<ThemeMode>(
                value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.auto_mode)),
          ],
          selected: <ThemeMode>{controller.themeMode},
          onSelectionChanged: (Set<ThemeMode> newSelection) {
            controller.setThemeMode(newSelection.first);
          },
        ),
      ),
    );
  }

  Widget _buildFontSizeSlider(
      BuildContext context, SettingsController controller, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ლოცვების ტექსტის ზომა: ${controller.fontSize.toStringAsFixed(1)}',
              style: theme.textTheme.bodyLarge,
            ),
            Slider(
              value: controller.fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 12,
              label: controller.fontSize.round().toString(),
              onChanged: (double value) {
                controller.setFontSize(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
