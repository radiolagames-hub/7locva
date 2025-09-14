
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BlessingScreen extends StatefulWidget {
  const BlessingScreen({super.key});

  @override
  State<BlessingScreen> createState() => _BlessingScreenState();
}

class _BlessingScreenState extends State<BlessingScreen> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  bool _video1Error = false;
  bool _video2Error = false;

  @override
  void initState() {
    super.initState();
    _controller1 = VideoPlayerController.asset('assets/videos/video1.mp4')
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        setState(() {
          _video1Error = true;
        });
      });
    _controller2 = VideoPlayerController.asset('assets/videos/video2.mp4')
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        setState(() {
          _video2Error = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('პატრიარქის კურთხევა'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _video1Error
                ? const Text('Video 1 not found')
                : _buildVideoPlayer(_controller1),
            const Divider(height: 20, thickness: 2),
            _video2Error
                ? const Text('Video 2 not found')
                : _buildVideoPlayer(_controller2),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerController controller) {
    return Column(
      children: [
        controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              )
            : const CircularProgressIndicator(),
        VideoProgressIndicator(controller, allowScrubbing: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  controller.value.isPlaying ? controller.pause() : controller.play();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
