import 'package:async_redux/async_redux.dart';
import 'package:weather_repository/weather_repository.dart';
import 'weather_actions.dart';
import 'weather_state.dart';
import 'weather_page.dart';

class WeatherViewModel extends Vm {
  final Weather? weather;
  final bool isLoading;
  final Function(String) onLocationSubmitted;

  WeatherViewModel({
    required this.weather,
    required this.isLoading,
    required this.onLocationSubmitted,
  }) : super(equals: [weather, isLoading]);
}

class WeatherFactory
    extends VmFactory<WeatherState, WeatherPage, WeatherViewModel> {
  @override
  WeatherViewModel fromStore() {
    return WeatherViewModel(
      weather: state.weather,
      isLoading: state.isLoading,
      onLocationSubmitted: (location) {
        dispatch(FetchWeatherAction(location: location));
      },
    );
  }
}
