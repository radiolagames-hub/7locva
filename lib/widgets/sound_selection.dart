import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class SoundSelection extends StatefulWidget {
  const SoundSelection({super.key});

  @override
  State<SoundSelection> createState() => _SoundSelectionState();
}

class _SoundSelectionState extends State<SoundSelection> {
  String? _selectedSound;
  late AudioPlayer _audioPlayer;
  final Map<String, String> sounds = {
    'მაღვიძარა': 'alarm.mp3',
    'ზარი': 'bell.mp3',
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
    try {
      _audioPlayer.stop(); 
      if (sound != null) {
        _audioPlayer.play(AssetSource('audio/$sound'));
      }
    } catch (e) {
      developer.log('Error playing preview sound: $e', name: 'sound_selection');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ხმის ფაილი ვერ მოიძებნა', style: TextStyle(fontFamily: 'BpgNinoMtavruli')),
          ),
        );
      }
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
                  label: Text(entry.key, style: const TextStyle(fontFamily: 'BpgNinoMtavruli')),
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
                if (_selectedSound != null) {
                  _playSound(_selectedSound);
                }
              },
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
