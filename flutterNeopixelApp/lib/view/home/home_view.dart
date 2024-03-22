import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:gap/gap.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_animations_widget.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_brightness_widget.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_color_picker.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_ready_color.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_status_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: ListView(
        shrinkWrap: true,
        children: [
          const Gap(homeSizedHeight),
          LedStatusWidget(
            isLedOn: true,
            changeStatus: (p0) async {},
          ),
          AnimationWidget(
            selectedAnimation: (p0) async {},
            selectedIndex: 0,
          ),
          LedBrightness(
            changeBrightnessEnd: (p0) async {},
            changeBrightness: (p0) {},
            currentValue: 64,
          ),
          Column(
            children: [
              LedReadyColor(
                selectedColor: (p0) async {},
              ),
              LightColorPicker(
                circleColorPickerController: CircleColorPickerController(),
                onEnded: (p0) async {},
                onChanged: (p0) {},
              ),
            ],
          ),
          const Gap(homeSizedHeight * 2.5),
        ],
      ),
    );
  }
}
