import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_repository_provider.g.dart';

@riverpod
WeatherRepository weatherRepository(Ref ref) {
  const apiKey = String.fromEnvironment('WEATHER_API_KEY');
  return WeatherRepository(apiKey);
}
