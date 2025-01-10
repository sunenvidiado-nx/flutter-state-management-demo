import 'package:get/get.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherController extends GetxController {
  WeatherController();

  final _weatherRepository = Get.find<WeatherRepository>();

  final weather = Rx<Weather?>(null);
  final loading = false.obs; // Or Rx<bool>(false) or RxBool(false)

  Future<void> fetchWeather(String location) async {
    loading.value = true;
    try {
      final weather = await _weatherRepository.getWeather(location);
      this.weather.value = weather;
    } finally {
      loading.value = false;
    }
  }
}
