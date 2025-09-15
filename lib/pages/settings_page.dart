
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedSound = 'default';
  bool _notificationsEnabled = true;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadSettings();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSound = prefs.getString('notification_sound') ?? 'default';
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_sound', _selectedSound!);
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
  }

  void _playSound(String sound) {
    _audioPlayer.stop();
    if (sound != 'default') {
      _audioPlayer.play(AssetSource('sounds/$sound'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface, // Fix: Use surface instead of background
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'შეხსენებები'),
          _buildNotificationToggle(theme),
          const SizedBox(height: 16),
          _buildSectionTitle(context, 'შეხსენების ხმა'),
          _buildSoundSelection(theme),
        ],
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

  Widget _buildNotificationToggle(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text('შეხსენებების ჩართვა', style: theme.textTheme.bodyLarge),
        value: _notificationsEnabled,
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
            _saveSettings();
          });
        },
        // Fix: activeColor is deprecated. The theme will handle the color.
      ),
    );
  }

  Widget _buildSoundSelection(ThemeData theme) {
    final sounds = {
      'Default': 'default',
      'Bell': 'bell.mp3',
      'Chimes': 'chimes.mp3',
      'Echo': 'echo.mp3',
    };

    // Fix: Using ListTile with Radio widgets to avoid deprecated properties on RadioListTile.
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: sounds.entries.map((entry) {
            final soundName = entry.key;
            final soundFile = entry.value;

            return ListTile(
              title: Text(soundName, style: theme.textTheme.bodyLarge),
              leading: Radio<String>(
                value: soundFile,
                groupValue: _selectedSound,
                onChanged: (String? value) {
                  setState(() {
                    _selectedSound = value;
                    _saveSettings();
                    if (value != null) {
                      _playSound(value);
                    }
                  });
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.play_circle_outline),
                onPressed: () {
                  _playSound(soundFile);
                },
                color: theme.colorScheme.secondary,
              ),
              onTap: () {
                if (_selectedSound != soundFile) {
                  setState(() {
                    _selectedSound = soundFile;
                    _saveSettings();
                    _playSound(soundFile);
                  });
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
