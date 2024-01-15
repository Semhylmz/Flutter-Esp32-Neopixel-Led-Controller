import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:neopixel_app_flutter/constants/ble_consts.dart';
import 'package:neopixel_app_flutter/constants/size.dart';
import 'package:neopixel_app_flutter/hex_color_conventer.dart';
import 'package:neopixel_app_flutter/model/led_model.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_animations_widget.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_brightness_widget.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_color_picker.dart';
import 'package:neopixel_app_flutter/view/home/widget/led_status_widget.dart';
import 'package:neopixel_app_flutter/view/scan/scan_ble_device_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.adapterState});

  final BluetoothAdapterState adapterState;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isScanning;
  late int _selectedDeviceIndex;
  late LedModel _ledModel;

  int _scanTimeout = 15;
  late Timer _timer;

  late BluetoothConnectionState _bluetoothConnectionState;
  late BluetoothCharacteristic? _selectedCharacteristic;

  List<ScanResult> _scanResults = [];
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  late final _circleColorPickerController;
  late String currentColor;

  @override
  void initState() {
    super.initState();

    _isScanning = false;
    _selectedDeviceIndex = 0;
    currentColor = '';
    _circleColorPickerController = CircleColorPickerController();

    _bluetoothConnectionState = BluetoothConnectionState.disconnected;
    _selectedCharacteristic = null;

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        _scanResults = results;
        if (mounted) setState(() {});
      },
      onError: (e) => toastMsg(msg: 'Error scan result subscription: $e'),
    );

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      if (mounted) setState(() => _isScanning = state);
    });

    scanDevice();
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    _circleColorPickerController.dispose();
    super.dispose();
  }

  Future scanDevice() async {
    _scanResults.clear();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _scanTimeout--);
    });
    _timer.cancel();

    try {
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: _scanTimeout),
        continuousUpdates: true,
        continuousDivisor: divisor,
      );
    } catch (e) {
      toastMsg(msg: 'Error scan device method: $e');
    }
  }

  Future getCharacteristic() async {
    List<BluetoothService> services =
        await _scanResults[_selectedDeviceIndex].device.discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == mCharacteristicUuid) {
          _selectedCharacteristic = characteristic;
        }
      }
    }
  }

  void toastMsg({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: CupertinoColors.systemGreen,
    );
  }

  Future bleRead() async {
    await _selectedCharacteristic!.read().then((value) {
      setState(() {
        _ledModel = LedModel(
          isLedOn: value[0] == 1 ? true : false,
          selectedAnimation: HexDecConverter.convertAnimationHexToDec(value[1]),
          brightnessValue: value[2],
          ledRed: value[3],
          ledGreen: value[4],
          ledBlue: value[5],
        );
        currentColor =
            '${_ledModel.ledRed}${_ledModel.ledGreen}${_ledModel.ledBlue}';
        _bluetoothConnectionState = BluetoothConnectionState.connected;
      });
    });

    toastMsg(
        msg:
            '${_scanResults[_selectedDeviceIndex].device.platformName} bağlandı');
  }

  Future bleWrite(List<int> list) async {
    _bluetoothConnectionState == BluetoothConnectionState.connected
        ? await _selectedCharacteristic!.write(Uint8List.fromList(list))
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: _bluetoothConnectionState == BluetoothConnectionState.disconnected
          ? ScanBleDevicePage(
              isScanning: _isScanning,
              scanResults: _scanResults,
              timerValue: _scanTimeout,
              connect: (index) async {
                setState(() => _selectedDeviceIndex = index);
                await _scanResults[_selectedDeviceIndex]
                    .device
                    .connect()
                    .then((value) => getCharacteristic());
                await bleRead();
              },
            )
          : ListView(
              shrinkWrap: true,
              children: [
                const Gap(homeSizedHeight),
                LedStatusWidget(
                  isLedOn: _ledModel.isLedOn,
                  changeStatus: (p0) async {
                    await bleWrite([0x02, _ledModel.isLedOn ? 0x00 : 0x01]);
                    setState(() => _ledModel.isLedOn = p0);
                  },
                ),
                AnimationWidget(
                  selectedAnimation: (p0) async {
                    setState(() => _ledModel.selectedAnimation = p0);
                    await bleWrite([
                      0x09,
                      HexDecConverter.convertAnimationDecToHex(
                          _ledModel.selectedAnimation)
                    ]);
                  },
                  selectedIndex: _ledModel.selectedAnimation,
                ),
                LedBrightness(
                  changeBrightnessEnd: (p0) async {
                    await bleWrite([
                      0x20,
                      int.parse(HexDecConverter.convertDecimalToHex(
                          _ledModel.brightnessValue))
                    ]);
                  },
                  changeBrightness: (p0) {
                    setState(() => _ledModel.brightnessValue = p0);
                  },
                  currentValue: _ledModel.brightnessValue,
                ),
                _ledModel.selectedAnimation == 1 ||
                        _ledModel.selectedAnimation == 2
                    ? const SizedBox.shrink()
                    : LightColorPicker(
                        circleColorPickerController:
                            _circleColorPickerController,
                        onEnded: (p0) async {
                          await bleWrite([
                            0x10,
                            HexDecConverter.convertDecToHex(p0.red),
                            HexDecConverter.convertDecToHex(p0.green),
                            HexDecConverter.convertDecToHex(p0.blue),
                          ]);
                        },
                        onChanged: (p0) {
                          setState(() {
                            _circleColorPickerController.color = p0;
                          });
                        },
                      ),
                const Gap(homeSizedHeight),
              ],
            ),
    );
  }
}
