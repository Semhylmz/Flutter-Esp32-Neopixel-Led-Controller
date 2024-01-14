import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/view/ble_off_view.dart';
import 'package:neopixel_app_flutter/view/home/home_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage = _adapterState == BluetoothAdapterState.on
        ? HomePage(adapterState: _adapterState)
        : const BleOffPage();

    return MaterialApp(
      title: 'WS2812B neopixel led controller',
      theme: appTheme,
      home: currentPage,
      debugShowCheckedModeBanner: false,
    );
  }
}
