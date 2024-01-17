import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';

class BleOffPage extends StatelessWidget {
  const BleOffPage({Key? key, this.adapterState}) : super(key: key);

  final BluetoothAdapterState? adapterState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.lightBlueAccent,
            ),
            Text(
              'Bluetooth kapalı',
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleSmall
                  ?.copyWith(color: Colors.black),
            ),
            Platform.isAndroid
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      child: const Text('AÇ'),
                      onPressed: () async {
                        try {
                          if (Platform.isAndroid) {
                            await FlutterBluePlus.turnOn();
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: "Error Turning On: $e");
                        }
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
