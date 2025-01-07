// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WeatherStore on _WeatherStore, Store {
  late final _$weatherAtom =
      Atom(name: '_WeatherStore.weather', context: context);

  @override
  Weather? get weather {
    _$weatherAtom.reportRead();
    return super.weather;
  }

  @override
  set weather(Weather? value) {
    _$weatherAtom.reportWrite(value, super.weather, () {
      super.weather = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_WeatherStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$fetchWeatherAsyncAction =
      AsyncAction('_WeatherStore.fetchWeather', context: context);

  @override
  Future<void> fetchWeather(String newCity) {
    return _$fetchWeatherAsyncAction.run(() => super.fetchWeather(newCity));
  }

  @override
  String toString() {
    return '''
weather: ${weather},
isLoading: ${isLoading}
    ''';
  }
}
