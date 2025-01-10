import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:weather_repository/weather_repository.dart';

import 'src/weather_page.dart';

void main() {
  // Register weather repository as lazy singleton
  Get.lazyPut(
    () => WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY')),
  );

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      getPages: [
        GetPage(
          name: '/',
          page: () => const WeatherPage(),
        ),
      ],
    );
  }
}
