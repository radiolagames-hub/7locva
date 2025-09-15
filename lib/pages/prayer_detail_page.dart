import 'package:flutter/material.dart';

class PrayerDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String prayerText;

  const PrayerDetailPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.prayerText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('მთავარი გვერდი', style: TextStyle(fontFamily: 'BpgNinoMtavruli')), 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BpgNinoMtavruli',
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 220, 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              prayerText,
              style: const TextStyle(fontFamily: 'Eka', fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
