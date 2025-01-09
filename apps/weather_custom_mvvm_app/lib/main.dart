import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:my_own_mvvm_with_dependency_injection_blackjack_and_hookers/dependencies.dart';
import 'package:weather_custom_mvvm_app/src/weather_page.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  runApp(DependenciesBuilder(
    dependencies: [
      Dependency(
        (_) =>
            WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY')),
      ),
    ],
    builder: (_, __) => const WeatherApp(),
  ));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
      builder: (context, child) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: child!,
      ),
      home: WeatherPage(),
    );
  }
}
