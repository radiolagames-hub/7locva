
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrayerScreen extends StatelessWidget {
  final String title;
  final String prayerText;

  const PrayerScreen({super.key, required this.title, required this.prayerText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          prayerText,
          style: GoogleFonts.openSans(fontSize: 16, height: 1.5),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
