import 'package:flutter/foundation.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  // In a production app, you would want to use a proper dependency injection
  // framework to provide the [WeatherRepository] instance to this class.
  // For simplicity, we're creating it directly in the constructor here.
  WeatherViewModel()
      : _repository =
            WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY'));

  final WeatherRepository _repository;

  Weather? _weather;
  Weather? get weather => _weather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchWeather(String location) async {
    _isLoading = true;
    notifyListeners();

    try {
      _weather = await _repository.getWeather(location);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
