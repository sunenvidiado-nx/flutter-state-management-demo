import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:weather_bloc_app/src/weather_cubit.dart';
import 'package:weather_bloc_app/src/weather_page.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => WeatherRepository(
            const String.fromEnvironment('WEATHER_API_KEY'),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Weather app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.light(),
          useMaterial3: true,
        ),
        builder: (context, child) => KeyboardDismissOnTap(child: child!),
        home: BlocProvider(
          create: (context) => WeatherCubit(
            context.read<WeatherRepository>(),
          ),
          child: const WeatherPage(),
        ),
      ),
    );
  }
}
