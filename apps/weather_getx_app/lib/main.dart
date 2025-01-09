import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:weather_getx_app/src/weather_controller.dart';
import 'package:weather_getx_app/src/weather_page.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY')));

    return GetMaterialApp(
      title: 'Weather app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: child!,
      ),
      home: GetBuilder<WeatherController>(
        init: WeatherController(Get.find<WeatherRepository>()),
        builder: (controller) => const WeatherPage(),
      ),
    );
  }
}
