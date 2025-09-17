import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/widgets/sound_selection.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationStatus = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsController>(context, listen: false).loadSettings();
    });
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _notificationStatus = status.isGranted;
    });
  }

  Future<void> _toggleNotificationPermission(bool value) async {
    if (value) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        setState(() {
          _notificationStatus = true;
        });
      } else {
        // Handle the case where the user denies the permission
        openAppSettings();
      }
    } else {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'ნებართვები'),
          _buildPermissionsSection(context, theme),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'თემა'),
          _buildThemeSelector(context, settingsController, theme),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'ლოცვების ტექსტის ზომა'),
          _buildFontSizeSlider(context, settingsController, theme),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'შეხსენების ხმა'),
          const SoundSelection(),
        ],
      ),
    );
  }

  Widget _buildPermissionsSection(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('შეტყობინებები', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('მაღვიძარას და შეხსენებებისთვის', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            Switch(
              value: _notificationStatus,
              onChanged: _toggleNotificationPermission,
            ),
          ],
        ),
      ),
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
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode)),
            ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode)),
            ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.auto_mode)),
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
