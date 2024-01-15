import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gap/gap.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/widget/head_widget.dart';

class ConnectionWidget extends StatelessWidget {
  const ConnectionWidget({
    super.key,
    required this.bluetoothConnectionState,
  });

  final BluetoothConnectionState bluetoothConnectionState;

  @override
  Widget build(BuildContext context) {
    return bluetoothConnectionState == BluetoothConnectionState.connecting
        ? BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 1.0,
              sigmaY: 1.0,
            ),
            child: Container(
              color: colorBackground!.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.grey[800]),
                    const Gap(headSize),
                    const HeadWidget(title: 'Bağlanıyor')
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
