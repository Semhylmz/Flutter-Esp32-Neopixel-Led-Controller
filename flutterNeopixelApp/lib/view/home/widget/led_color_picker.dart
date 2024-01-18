import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/widget/head_widget.dart';

class LightColorPicker extends StatelessWidget {
  const LightColorPicker({
    super.key,
    required this.circleColorPickerController,
    required this.onChanged,
    required this.onEnded,
  });

  final Function(Color) onChanged;
  final Function(Color) onEnded;
  final CircleColorPickerController circleColorPickerController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadWidget(title: 'Custom Color'),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: hPadding, vertical: vPadding),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorCard,
              borderRadius: const BorderRadius.all(Radius.circular(22)),
            ),
            child: Center(
              child: CircleColorPicker(
                size: const Size(230, 230),
                strokeWidth: 12,
                thumbSize: 32,
                textStyle: const TextStyle(color: Colors.transparent),
                controller: circleColorPickerController,
                onEnded: (value) {
                  onEnded.call(value);
                },
                onChanged: (colorVal) {
                  onChanged.call(colorVal);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
