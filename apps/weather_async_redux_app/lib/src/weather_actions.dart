import 'package:async_redux/async_redux.dart';
import 'package:weather_repository/weather_repository.dart';
import 'weather_state.dart';

class FetchWeatherAction extends ReduxAction<WeatherState> {
  final String location;

  FetchWeatherAction({required this.location});

  WeatherRepository get _repository =>
      prop<WeatherRepository>('weatherRepository');

  @override
  Future<WeatherState?> reduce() async {
    try {
      dispatch(SetLoadingAction(isLoading: true));
      final weather = await _repository.getWeather(location);
      return state.copyWith(weather: weather, isLoading: false);
    } finally {
      dispatch(SetLoadingAction(isLoading: false));
    }
  }
}

class SetLoadingAction extends ReduxAction<WeatherState> {
  final bool isLoading;

  SetLoadingAction({required this.isLoading});

  @override
  WeatherState reduce() {
    return state.copyWith(isLoading: isLoading);
  }
}
