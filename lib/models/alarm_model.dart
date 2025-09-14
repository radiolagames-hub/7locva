import 'package:flutter/material.dart';

class Alarm {
  int id;
  TimeOfDay time;
  String text;
  String image;
  bool isEnabled;
  String prayer;

  Alarm({
    required this.id,
    required this.time,
    required this.text,
    required this.image,
    this.isEnabled = true,
    this.prayer = "",
  });
}
