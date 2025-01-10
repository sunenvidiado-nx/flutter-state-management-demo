import 'package:mobx/mobx.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_store.g.dart';

class WeatherStore = _WeatherStore with _$WeatherStore;

abstract class _WeatherStore with Store {
  // Typically, you would use a dependency injection framework like GetIt.
  final _repository = WeatherRepository(
    const String.fromEnvironment('WEATHER_API_KEY'),
  );

  @observable
  Weather? weather;

  @observable
  bool isLoading = false;

  @action
  Future<void> fetchWeather(String newCity) async {
    isLoading = true;
    try {
      weather = await _repository.getWeather(newCity);
    } finally {
      isLoading = false;
    }
  }
}
