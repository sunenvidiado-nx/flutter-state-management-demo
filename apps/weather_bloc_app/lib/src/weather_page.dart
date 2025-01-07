import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_app/src/weather_cubit.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().fetchWeather(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            _buildWeatherCondition(),
            _buildTemperatureDisplay(),
            const SizedBox(height: 64),
            _buildWeatherDetails(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: EditableText(
        controller: _controller,
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.headlineSmall!,
        cursorColor: Colors.blueAccent,
        backgroundCursorColor: Colors.black,
        textAlign: TextAlign.center,
        onSubmitted: context.read<WeatherCubit>().fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (state) {
            WeatherLoading() => Text(
                'Fetching...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            WeatherLoaded(weather: final weather) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    weather.current.condition.imageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    weather.current.condition.text,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }

  Widget _buildTemperatureDisplay() {
    return Column(
      children: [
        Center(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  key: ValueKey(state),
                  switch (state) {
                    WeatherLoaded(weather: final weather) =>
                      '${weather.current.tempC.toInt()}°',
                    _ => '...',
                  },
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 180, color: Colors.black87),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  key: ValueKey(state),
                  switch (state) {
                    WeatherLoaded(weather: final weather) =>
                      'Feels like ${weather.current.feelsLikeC.toInt()}°',
                    _ => 'Fetching...',
                  },
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailItem(
            icon: Icons.opacity_outlined,
            valueBuilder: (weather) => '${weather.current.humidity}%',
          ),
          _buildDetailItem(
            icon: Icons.air,
            valueBuilder: (weather) =>
                '${weather.current.windKph.toInt()} km/h',
          ),
          _buildDetailItem(
            icon: Icons.wb_sunny_outlined,
            valueBuilder: (weather) => '${weather.current.uv} UV',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String Function(Weather) valueBuilder,
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 26,
          child: Icon(
            icon,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return Text(
              switch (state) {
                WeatherLoaded(weather: final weather) => valueBuilder(weather),
                _ => '...',
              },
              style: Theme.of(context).textTheme.titleMedium,
            );
          },
        ),
      ],
    );
  }
}
