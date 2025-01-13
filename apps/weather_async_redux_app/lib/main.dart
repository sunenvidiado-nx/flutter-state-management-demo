import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:weather_async_redux_app/src/weather_page.dart';
import 'package:weather_async_redux_app/src/weather_state.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
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
      builder: (context, child) => KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: child!,
      ),
      home: StoreProvider(
        store: Store(
          initialState: const WeatherState(),
          props: {
            'weatherRepository': WeatherRepository(
              const String.fromEnvironment('WEATHER_API_KEY'),
            ),
          },
        ),
        child: const WeatherPage(),
      ),
    );
  }
}
