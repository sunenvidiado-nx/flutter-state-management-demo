import 'package:weather_repository/weather_repository.dart';

sealed class WeatherState {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherData extends WeatherState {
  const WeatherData(this.weather);
  final Weather weather;
}
