
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:myapp/pages/home_screen.dart';

class BlessingPage extends StatefulWidget {
  const BlessingPage({super.key});

  @override
  State<BlessingPage> createState() => _BlessingPageState();
}

class _BlessingPageState extends State<BlessingPage> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  final int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    if (index == 3) {
      SystemNavigator.pop();
    } else if (index == 0) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(initialIndex: index)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('7 locva', style: TextStyle(fontFamily: 'Eka', color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'მთავარი',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'კალენდარი',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'პარამეტრები',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'გასვლა',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
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
                  alignment: Alignment.center,
                  children: <Widget>[
                    VideoPlayer(controller),
                    _buildPlayPauseOverlay(controller),
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
      behavior: HitTestBehavior.translucent,
      child: controller.value.isPlaying
          ? const SizedBox.shrink()
          : Container(
              alignment: Alignment.center,
              color: Colors.black26,
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
