import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BleOffPage extends StatelessWidget {
  const BleOffPage({Key? key, this.adapterState}) : super(key: key);

  final BluetoothAdapterState? adapterState;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Colors.lightBlueAccent,
    );
  }

  Widget buildTitle(BuildContext context) {
    String? state = adapterState?.toString().split(".").last;
    return Text(
      'Bluetooth Adapter is ${state ?? 'not available'}',
      style: Theme.of(context)
          .primaryTextTheme
          .titleSmall
          ?.copyWith(color: Colors.black),
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: const Text('TURN ON'),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildBluetoothOffIcon(context),
            buildTitle(context),
            if (Platform.isAndroid) buildTurnOnButton(context),
          ],
        ),
      ),
    );
  }
}
