import 'package:flutter/material.dart';

@immutable
class Prayer {
  final String time;
  final String title;
  final String imagePath;
  final String prayerText;
  final Widget page;

  const Prayer({
    required this.time,
    required this.title,
    required this.imagePath,
    required this.prayerText,
    required this.page,
  });

  Prayer copyWith({
    String? time,
    String? title,
    String? imagePath,
    String? prayerText,
    Widget? page,
  }) {
    return Prayer(
      time: time ?? this.time,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      prayerText: prayerText ?? this.prayerText,
      page: page ?? this.page,
    );
  }
}
