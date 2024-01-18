import 'package:flutter/material.dart';
import 'package:neopixel_app_flutter/model/rgb_model.dart';

final List<String> animationList = [
  'Single Color',
  'Rainbow',
  'Rainbow Cycle',
  'RGB',
  'Theater Chase',
  'Theater Chase Rainbow',
];

final List<RgbModel> colorList = [
  RgbModel(
      colorName: Colors.white.withOpacity(0.4), red: 80, green: 80, blue: 80),
  RgbModel(colorName: Colors.red, red: 128, green: 10, blue: 0),
  RgbModel(colorName: Colors.purpleAccent, red: 72, green: 119, blue: 72),
  RgbModel(colorName: Colors.lightGreenAccent, red: 119, green: 10, blue: 119),
  RgbModel(colorName: Colors.cyan, red: 10, green: 128, blue: 128),
  RgbModel(colorName: Colors.lightBlueAccent, red: 10, green: 128, blue: 128),
];
