import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;

class SoundSelection extends StatefulWidget {
  const SoundSelection({super.key});

  @override
  State<SoundSelection> createState() => _SoundSelectionState();
}

class _SoundSelectionState extends State<SoundSelection> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, String> _sounds = {
    'ზარი': 'bell.mp3',
    'მაღვიძარა': 'alarm.mp3',
  };

  void _playSound(String soundFile) async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.stop();
    }
    try {
      await _audioPlayer.play(AssetSource('audio/$soundFile'));
    } catch (e) {
      developer.log('Error playing sound: $e', name: 'sound_selection');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _sounds.entries.map((entry) {
            final soundName = entry.key;
            final soundFile = entry.value;
            final isSelected = settingsController.sound == soundFile;

            return RadioListTile<String>(
              title: Text(soundName, style: theme.textTheme.bodyLarge),
              value: soundFile,
              groupValue: settingsController.sound,
              onChanged: (String? value) {
                if (value != null) {
                  settingsController.setSound(value);
                  _playSound(value);
                }
              },
              secondary: IconButton(
                icon: Icon(
                  Icons.play_circle_outline,
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                onPressed: () => _playSound(soundFile),
              ),
              activeColor: theme.colorScheme.primary,
            );
          }).toList(),
        ),
      ),
    );
  }
}
