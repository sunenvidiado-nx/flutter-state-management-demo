import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(const WeatherInitial());

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather(String location) async {
    try {
      emit(const WeatherLoading());
      final weather = await _weatherRepository.getWeather(location);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e));
    }
  }
}
