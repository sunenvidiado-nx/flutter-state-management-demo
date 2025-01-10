import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_repository/weather_repository.dart';

import 'weather_repository_provider.dart';

part 'weather_notifier.g.dart';

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  late final WeatherRepository _repository;

  @override
  Future<Weather> build() async {
    _repository = ref.read(weatherRepositoryProvider);
    return _repository.getWeather('Manila');
  }

  Future<void> fetchWeather(String location) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => _repository.getWeather(location),
    );
  }
}
