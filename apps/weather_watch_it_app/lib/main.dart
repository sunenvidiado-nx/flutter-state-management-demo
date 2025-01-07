import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:watch_it/watch_it.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weather_watch_it_app/src/weather_page.dart';
import 'package:weather_watch_it_app/src/weather_view_model.dart';

void main() {
  // Register repository
  di.registerLazySingleton(
      () => WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY')));

  // Register view model
  di.registerLazySingleton(() => WeatherViewModel(di()));

  runApp(const WeatherApp());
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
      builder: (context, child) => KeyboardDismissOnTap(child: child!),
      home: WeatherPage(),
    );
  }
}
