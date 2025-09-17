import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/widgets/app_bottom_navigation.dart';
import 'dart:developer' as developer;

class BlessingPage extends StatefulWidget {
  const BlessingPage({super.key});

  @override
  State<BlessingPage> createState() => _BlessingPageState();
}

class _BlessingPageState extends State<BlessingPage> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = VideoPlayerController.asset('assets/videos/video1.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        developer.log('Error initializing video 1: $error', name: 'blessing_page');
      });
    _controller2 = VideoPlayerController.asset('assets/videos/video2.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        developer.log('Error initializing video 2: $error', name: 'blessing_page');
      });
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 2) {
      Navigator.pop(context);
    } else if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false, arguments: 0);
    } else if (index == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false, arguments: 1);
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            _buildVideoPlayer(theme, _controller1, 'კურთხევა 1'),
            const SizedBox(height: 32),
            _buildVideoPlayer(theme, _controller2, 'კურთხევა 2'),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0, 
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  Widget _buildVideoPlayer(ThemeData theme, VideoPlayerController controller, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
          child: Text(title, style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface
          )),
        ),
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16),
          shadowColor: Colors.black.withAlpha(77),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(controller),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.value.isPlaying ? controller.pause() : controller.play();
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: controller.value.isPlaying
                              ? const SizedBox.shrink()
                              : Container(
                                  key: ValueKey<bool>(controller.value.isPlaying),
                                  alignment: Alignment.center,
                                  color: Colors.black45,
                                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 70.0),
                                ),
                        ),
                      ),
                      VideoProgressIndicator(controller, allowScrubbing: true, colors: VideoProgressColors(
                        playedColor: theme.colorScheme.primary,
                        bufferedColor: theme.colorScheme.primary.withAlpha(128),
                        backgroundColor: Colors.white.withAlpha(51),
                      ),),
                    ],
                  ),
                )
              : SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: theme.colorScheme.primary),
                        const SizedBox(height: 20),
                        Text('ვიდეო იტვირთება...', style: TextStyle(fontFamily: 'BpgNinoMtavruli', color: theme.colorScheme.onSurface)),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
