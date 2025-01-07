import 'package:async_redux/async_redux.dart';
import 'package:weather_repository/weather_repository.dart';
import 'weather_state.dart';

class FetchWeatherAction extends ReduxAction<WeatherState> {
  final String location;

  FetchWeatherAction({required this.location});

  @override
  Future<WeatherState> reduce() async {
    dispatch(SetLoadingAction(isLoading: true));

    try {
      final weather = await prop<WeatherRepository>('weatherRepository')
          .getWeather(location);

      return state.copyWith(weather: weather, isLoading: false);
    } catch (e) {
      return state.copyWith(isLoading: false);
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
