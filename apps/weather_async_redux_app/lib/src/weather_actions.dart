import 'package:async_redux/async_redux.dart';
import 'package:weather_repository/weather_repository.dart';
import 'weather_state.dart';

class FetchWeatherAction extends ReduxAction<WeatherState> {
  final String location;

  FetchWeatherAction({required this.location});

  WeatherRepository get _repository =>
      prop<WeatherRepository>('weatherRepository');

  @override
  Future<WeatherState> reduce() async {
    // Actions can dispatch other actions
    dispatch(SetLoadingAction(isLoading: true));

    final weather = await _repository.getWeather(location);

    dispatch(SetLoadingAction(isLoading: false));

    return state.copyWith(weather: weather);
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
