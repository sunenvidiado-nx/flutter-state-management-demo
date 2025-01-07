import 'package:weather_repository/weather_repository.dart';

class WeatherState {
  final Weather? weather;
  final bool isLoading;

  const WeatherState({
    this.weather,
    this.isLoading = false,
  });

  WeatherState copyWith({
    Weather? weather,
    bool? isLoading,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
