import 'package:flutter/foundation.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(this._repository);

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
