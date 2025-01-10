import 'package:get/get.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherController extends GetxController {
  WeatherController();

  final _weatherRepository = Get.find<WeatherRepository>();

  final _weather = Rx<Weather?>(null);
  Weather? get weather => _weather.value;

  final _loading = false.obs; // Or Rx<bool>(false)
  bool get loading => _loading.value;

  Future<void> fetchWeather(String location) async {
    _loading.value = true;
    try {
      final weather = await _weatherRepository.getWeather(location);
      _weather.value = weather;
    } finally {
      _loading.value = false;
    }
  }
}
