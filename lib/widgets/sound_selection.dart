import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundSelection extends StatefulWidget {
  const SoundSelection({super.key});

  @override
  State<SoundSelection> createState() => _SoundSelectionState();
}

class _SoundSelectionState extends State<SoundSelection> {
  String? _selectedSound;
  late AudioPlayer _audioPlayer;
  final Map<String, String> sounds = {
    'Alarm': 'alarm.mp3',
    'Bell': 'bell.mp3',
  };

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
      _selectedSound = prefs.getString('notification_sound') ?? 'bell.mp3';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_sound', _selectedSound!);
  }

  void _playSound(String? sound) {
    _audioPlayer.stop();
    if (sound != null) {
      _audioPlayer.play(AssetSource('audio/$sound'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_selectedSound == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SegmentedButton<String>(
              segments: sounds.entries.map((entry) {
                return ButtonSegment<String>(
                  value: entry.value,
                  label: Text(entry.key),
                );
              }).toList(),
              selected: <String>{_selectedSound!},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedSound = newSelection.first;
                  _saveSettings();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              onPressed: () {
                _playSound(_selectedSound);
              },
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
