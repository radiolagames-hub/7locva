import 'package:flutter/material.dart';

class PrayerPage extends StatelessWidget {
  final String title;
  final String prayerText;
  final String imagePath;

  const PrayerPage({super.key, required this.title, required this.prayerText, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(imagePath),
              const SizedBox(height: 16),
              Text(
                prayerText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
