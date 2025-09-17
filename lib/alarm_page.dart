import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/data/prayer_data.dart';
import 'package:myapp/pages/prayer_detail_page.dart';
import 'dart:developer' as developer;

class AlarmPage extends StatefulWidget {
  final int alarmId;
  const AlarmPage({super.key, required this.alarmId});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playSound();
    });
  }

  Future<void> _playSound() async {
    final sound = Provider.of<SettingsController>(context, listen: false).sound;
    try {
      await _player.play(AssetSource("audio/$sound"), volume: 1.0);
      await _player.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      developer.log('Error playing sound: $e', name: 'alarm_page');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ხმის დაკვრა ვერ მოხერხდა', style: TextStyle(fontFamily: 'BpgNinoMtavruli')),
          ),
        );
      }
    }
  }

  void _stopSound() {
    try {
      _player.stop();
    } catch (e) {
      developer.log('Error stopping sound: $e', name: 'alarm_page');
    }
  }

  void _readPrayer() {
    _stopSound();
    final prayer = prayerList[widget.alarmId];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PrayerDetailPage(
          imagePath: prayer.imagePath,
          title: prayer.title,
          prayerText: prayer.prayerText,
        ),
      ),
    );
  }

  void _snooze(int minutes) {
    _stopSound();
    try {
      Provider.of<AlarmProvider>(context, listen: false).snoozeAlarm(widget.alarmId, minutes);
    } catch (e) {
      developer.log('Error snoozing alarm: $e', name: 'alarm_page');
    }
    Navigator.pop(context);
  }

  void _dismiss() {
    _stopSound();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _stopSound();
    _player.dispose();
    super.dispose();
  }

  String _getBackgroundImage() {
    final prayer = prayerList[widget.alarmId];
    return prayer.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final prayer = prayerList[widget.alarmId];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage()),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withAlpha(128),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: _dismiss,
                  tooltip: 'გამოტოვება',
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      prayer.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BpgNinoMtavruli',
                        fontSize: 28,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,  
                            color: Colors.black, 
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      prayer.time,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Eka', 
                        fontSize: 64,
                        fontWeight: FontWeight.w600,
                         shadows: [
                          Shadow(
                            blurRadius: 8.0,  
                            color: Colors.black54, 
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSnoozeButton(context, '2 წუთით', 2),
                        _buildSnoozeButton(context, '5 წუთით', 5),
                      ],
                    ),
                    const SizedBox(height: 40),
                    _buildReadButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnoozeButton(BuildContext context, String label, int minutes) {
    return ElevatedButton.icon(
      onPressed: () => _snooze(minutes),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.9).round()),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: const Icon(Icons.alarm, size: 18),
      label: Text(label),
    );
  }

  Widget _buildReadButton() {
    return GestureDetector(
      onTap: _readPrayer,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha((255 * 0.2).round()),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: const Text(
          'წაკითხვა',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'BpgNinoMtavruli',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
