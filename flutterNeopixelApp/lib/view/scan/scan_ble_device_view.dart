import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gap/gap.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/widget/head_widget.dart';

class ScanBleDevicePage extends StatelessWidget {
  const ScanBleDevicePage({
    super.key,
    required this.scanResults,
    required this.connect,
    required this.isScanning,
    required this.timerValue,
  });

  final List<ScanResult> scanResults;
  final Function(int) connect;
  final bool isScanning;
  final int timerValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: hPadding, vertical: vPadding),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const Gap(homeSizedHeight),
            isScanning
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      const LinearProgressIndicator(
                          color: CupertinoColors.inactiveGray),
                      const Gap(homeSizedHeight * 0.5),
                      HeadWidget(title: 'Searching for Bluetooth devices...$timerValue)'),
                    ],
                  )
                : const HeadWidget(title: 'Devices found'),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorCard,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(22),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.devices_outlined),
                    title: Text(
                      scanResults[index].device.platformName.isEmpty
                          ? 'Device name unknown'
                          : scanResults[index].device.platformName,
                    ),
                    subtitle: Text('${scanResults[index].rssi} dBm'),
                    subtitleTextStyle:
                        _computeTextStyle(scanResults[index].rssi),
                    trailing: TextButton(
                      onPressed: () async => connect.call(index),
                      child: Text(
                        'Connect',
                        style: TextStyle(
                          color: scanResults[index].device.platformName.isEmpty
                              ? CupertinoColors.systemGrey
                              : CupertinoColors.systemGreen,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Gap(homeSizedHeight),
          ],
        ),
      ),
    );
  }

  static TextStyle _computeTextStyle(int rssi) {
    if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700]!.withOpacity(0.5));
    } else if (rssi >= -45) {
      return TextStyle(
          color: Color.lerp(Colors.greenAccent[700]!.withOpacity(0.5),
              Colors.lightGreen.withOpacity(0.5), -(rssi + 35) / 10));
    } else if (rssi >= -55) {
      return TextStyle(
          color: Color.lerp(Colors.lightGreen.withOpacity(0.5),
              Colors.lime[600]!.withOpacity(0.5), -(rssi + 45) / 10));
    } else if (rssi >= -65) {
      return TextStyle(
          color: Color.lerp(Colors.lime[600]!.withOpacity(0.5),
              Colors.amber.withOpacity(0.5), -(rssi + 55) / 10));
    } else if (rssi >= -75) {
      return TextStyle(
          color: Color.lerp(Colors.amber.withOpacity(0.5),
              Colors.deepOrangeAccent.withOpacity(0.5), -(rssi + 65) / 10));
    } else if (rssi >= -85) {
      return TextStyle(
          color: Color.lerp(Colors.deepOrangeAccent.withOpacity(0.5),
              Colors.redAccent.withOpacity(0.5), -(rssi + 75) / 10));
    } else {
      return TextStyle(color: Colors.redAccent.withOpacity(0.5));
    }
  }
}
