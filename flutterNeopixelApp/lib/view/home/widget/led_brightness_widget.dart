import 'package:flutter/material.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/widget/head_widget.dart';

class LedBrightness extends StatefulWidget {
  LedBrightness({
    super.key,
    required this.changeBrightness,
    required this.changeBrightnessEnd,
    required this.currentValue,
  });

  Function(int) changeBrightness;
  Function(int) changeBrightnessEnd;
  final int currentValue;

  @override
  State<LedBrightness> createState() => _LedBrightnessState();
}

class _LedBrightnessState extends State<LedBrightness> {
  Color? changeColor(int value) {
    return value >= 0.0 && value < 60.0
        ? Colors.orange.shade50
        : value > 60.0 && value < 120.0
            ? Colors.orange.shade100
            : value > 120.0 && value <= 180.0
                ? Colors.orange.shade200
                : value > 180.0 && value <= 255
                    ? Colors.orange.shade300
                    : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadWidget(title: 'Renk Sıcaklığı'),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: hPadding, vertical: vPadding),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorCard,
              borderRadius: const BorderRadius.all(
                Radius.circular(22),
              ),
            ),
            child: Slider(
              min: 0.0,
              max: 255.0,
              //divisions: 10,
              label: '${widget.currentValue.round()}',
              inactiveColor: colorBackground,
              thumbColor: changeColor(widget.currentValue),
              activeColor: changeColor(widget.currentValue),
              value: widget.currentValue.toDouble(),
              onChangeEnd: (value) {
                widget.changeBrightnessEnd.call(value.toInt());
              },
              onChanged: (value) {
                changeColor(value.toInt());
                widget.changeBrightness.call(value.toInt());
              },
            ),
          ),
        ),
      ],
    );
  }
}
