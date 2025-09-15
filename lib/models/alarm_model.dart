import 'package:flutter/material.dart';

class Alarm {
  int id;
  TimeOfDay time;
  String text;
  String image;

  Alarm({
    required this.id,
    required this.time,
    required this.text,
    required this.image,
  });
}
