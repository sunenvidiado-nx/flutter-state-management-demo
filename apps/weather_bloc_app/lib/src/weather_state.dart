part of 'weather_cubit.dart';

sealed class WeatherState {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

final class WeatherLoaded extends WeatherState {
  const WeatherLoaded(this.weather);
  final Weather weather;
}

final class WeatherError extends WeatherState {
  const WeatherError(this.error);
  final Object error;
}
