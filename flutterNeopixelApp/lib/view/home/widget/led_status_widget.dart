import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/widget/head_widget.dart';
import 'package:neopixel_app_flutter/widget/switch_info_text.dart';

class LedStatusWidget extends StatelessWidget {
  const LedStatusWidget({
    super.key,
    required this.changeStatus,
    required this.isLedOn,
  });

  final Function(bool) changeStatus;
  final bool isLedOn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadWidget(title: 'Light Status'),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: hPadding, vertical: vPadding),
          child: Container(
            decoration: BoxDecoration(
              color: colorCard,
              borderRadius: BorderRadius.circular(24.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.lightbulb_outline,
                      size: iconSize,
                      color:
                          isLedOn ? CupertinoColors.systemGreen : Colors.black),
                ),
                SwitchInfoText(
                  title: 'Neopixel Led',
                  subTitle: isLedOn ? 'On' : 'Off',
                ),
                RotatedBox(
                  quarterTurns: 0,
                  child: Transform.scale(
                    scale: switchScale,
                    child: CupertinoSwitch(
                      value: isLedOn,
                      onChanged: (value) {
                        changeStatus.call(value);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
