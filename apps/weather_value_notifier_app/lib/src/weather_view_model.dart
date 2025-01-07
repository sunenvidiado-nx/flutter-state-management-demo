import 'package:flutter/material.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherViewModel {
  // In a production app, you would want to use a proper dependency injection
  // framework to provide the [WeatherRepository] instance to this class.
  // For simplicity, we're creating it directly in the constructor here.
  WeatherViewModel()
      : _repository =
            WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY'));

  final ValueNotifier<Weather?> weatherNotifier = ValueNotifier(null);
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false);

  final WeatherRepository _repository;

  Future<void> fetchWeather(String city) async {
    loadingNotifier.value = true;

    try {
      final weather = await _repository.getWeather(city);
      weatherNotifier.value = weather;
    } finally {
      loadingNotifier.value = false;
    }
  }

  void dispose() {
    weatherNotifier.dispose();
    loadingNotifier.dispose();
  }
}
