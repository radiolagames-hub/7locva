import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/alarm_provider.dart';
import 'package:myapp/controllers/settings_controller.dart';
import 'package:myapp/pages/home_screen.dart';

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
      _player.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Error playing sound: $e');
      // Fallback to default system sound or show error
    }
  }

  void _stopSound() {
    _player.stop();
  }

  void _readPrayer() {
    _stopSound();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(initialTabIndex: widget.alarmId),
      ),
    );
  }

  void _snooze(int minutes) {
    _stopSound();
    Provider.of<AlarmProvider>(context, listen: false).snoozeAlarm(widget.alarmId, minutes);
    Navigator.pop(context);
  }

  void _dismiss() {
    _stopSound();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _stopSound();
    super.dispose();
  }

  String _getBackgroundImage() {
    final hour = DateTime.now().hour;
    if (hour >= 23 || hour < 6) {
      return "assets/images/23.jpg";
    } else if (hour >= 21) {
      return "assets/images/21.jpg";
    } else if (hour >= 18) {
      return "assets/images/18.jpg";
    } else if (hour >= 15) {
      return "assets/images/15.jpg";
    } else if (hour >= 12) {
      return "assets/images/12.jpg";
    } else if (hour >= 9) {
      return "assets/images/09.jpg";
    } else {
      return "assets/images/06.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_getBackgroundImage(), fit: BoxFit.cover),
          Container(color: Colors.black45),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ლოცვის დროა!",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _readPrayer, 
                child: const Text("წაკითხვა"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => _snooze(2),
                child: const Text("გადადება 2 წუთით"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => _snooze(5),
                child: const Text("გადადება 5 წუთით"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _dismiss,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("გამოტოვება"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
