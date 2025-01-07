import 'package:very_simple_state_manager/very_simple_state_manager.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weather_simple_state_management_app/src/weather_state.dart';

class WeatherStateManager extends StateManager<WeatherState> {
  WeatherStateManager()
      // In a production app, you would want to use a proper dependency injection
      // framework to provide the [WeatherRepository] instance to this class.
      // For simplicity, we're creating it directly in the constructor here.
      : _weatherRepository =
            WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY')),
        super(WeatherInitial());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String location) async {
    state = const WeatherLoading();

    try {
      final weather = await _weatherRepository.getWeather(location);
      state = WeatherData(weather);
    } catch (e) {
      // Handle error
    }
  }
}
