import 'package:flutter/material.dart';
import 'package:neopixel_app_flutter/theme/app_theme.dart';
import 'package:neopixel_app_flutter/view/home/home_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WS2812B neopixel led controller',
      theme: appTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
