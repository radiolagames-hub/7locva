
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/widgets/app_bottom_navigation.dart';

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
      });
    _controller2 = VideoPlayerController.asset('assets/videos/video2.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == 3) {
      SystemNavigator.pop(); // Exit the app
    } else {
      Navigator.pop(context, index);
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
    const int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('პატრიარქის კურთხევა', style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildVideoPlayer(_controller1, 'კურთხევა 1'),
            const SizedBox(height: 24),
            _buildVideoPlayer(_controller2, 'კურთხევა 2'),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerController controller, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (controller.value.isInitialized)
          AspectRatio(
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
                            color: Colors.black26,
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 64.0),
                          ),
                  ),
                ),
                VideoProgressIndicator(controller, allowScrubbing: true),
              ],
            ),
          )
        else
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
