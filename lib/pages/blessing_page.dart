import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
        setState(() {}); // Ensure the first frame is shown
      });
    _controller2 = VideoPlayerController.asset('assets/videos/video2.mp4')
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('პატრიარქის კურთხევა'),
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
    );
  }

  Widget _buildVideoPlayer(VideoPlayerController controller, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center, // Center the overlay
                  children: <Widget>[
                    VideoPlayer(controller),
                    // The play/pause overlay
                    _buildPlayPauseOverlay(controller),
                    // The progress bar at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: VideoProgressIndicator(controller, allowScrubbing: true),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildPlayPauseOverlay(VideoPlayerController controller) {
    return GestureDetector(
      onTap: () {
        setState(() {
          controller.value.isPlaying ? controller.pause() : controller.play();
        });
      },
      behavior: HitTestBehavior.translucent, // Make sure tap is detected on transparent areas
      child: controller.value.isPlaying
          ? const SizedBox.shrink() // Show nothing when playing
          : Container(
              alignment: Alignment.center,
              color: Colors.black26, // Semi-transparent background for better icon visibility
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 64.0,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
