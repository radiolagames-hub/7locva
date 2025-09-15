import 'package:flutter/material.dart';

class EveningPrayerPage extends StatelessWidget {
  const EveningPrayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('საღამოს ლოცვა'),
      ),
      body: const Center(
        child: Text('Content for the evening prayer will be added here.'),
      ),
    );
  }
}
