import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:neopixel_app_flutter/constants/size.dart';

class BluetoothDeviceList extends ListTile {
  BluetoothDeviceList({
    super.key,
    required ScanResult result,
    required GestureTapCallback onTap,
    bool enabled = true,
  }) : super(
          onTap: onTap,
          enabled: enabled,
          leading: const Icon(Icons.devices_outlined, size: iconSize),
          title: Text(
            result.device.name.isEmpty || result.device.name == null
                ? 'Unkown device'
                : result.device.name,
          ),
          subtitle: Text(result.device.id.toString()),
          // subtitle: result.device.prevBondState != null
          //     ? const Text('Secure connection ready')
          //     : const Text("Cannot connect to this device"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              result.rssi != null
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      child: DefaultTextStyle(
                        style: _computeTextStyle(result.rssi),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(result.rssi.toString()),
                            const Text('dBm'),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(width: 0, height: 0),
              // device.isConnected
              //     ? const Icon(Icons.bluetooth_connected_outlined)
              //     : const SizedBox(width: 0, height: 0),
              // device.isBonded
              //     ? const Icon(Icons.bluetooth_disabled_outlined)
              //     : const SizedBox(width: 0, height: 0),
            ],
          ),
        );

  static TextStyle _computeTextStyle(int rssi) {
    if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700]);
    } else if (rssi >= -45) {
      return TextStyle(
          color: Color.lerp(
              Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
    } else if (rssi >= -55) {
      return TextStyle(
          color: Color.lerp(
              Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
    } else if (rssi >= -65) {
      return TextStyle(
          color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
    } else if (rssi >= -75) {
      return TextStyle(
          color: Color.lerp(
              Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
    } else if (rssi >= -85) {
      return TextStyle(
          color: Color.lerp(
              Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
    } else {
      return const TextStyle(color: Colors.redAccent);
    }
  }
}
