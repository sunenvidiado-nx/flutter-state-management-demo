import 'dart:convert';

import 'package:weather_repository/src/weather.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  WeatherRepository(this._apiKey)
      : assert(_apiKey.isNotEmpty, 'API key cannot be empty.');

  final String _apiKey;

  Future<Weather> getWeather(String location) async {
    final queryParameters = {'key': _apiKey, 'q': location, 'aqi': 'no'};
    final uri =
        Uri.https('api.weatherapi.com', '/v1/current.json', queryParameters);
    final response = await http.get(uri);

    return Weather.fromJson(jsonDecode(response.body));
  }
}
