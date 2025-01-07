import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weather_watch_it_app/src/weather_view_model.dart';

class WeatherPage extends StatelessWidget with WatchItMixin {
  WeatherPage({super.key});

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    final viewModel = di<WeatherViewModel>();
    final isLoading = watchPropertyValue((WeatherViewModel vm) => vm.isLoading);
    final weather = watchPropertyValue((WeatherViewModel vm) => vm.weather);

    callOnce((context) {
      _controller = TextEditingController(text: 'Manila');
      _focusNode = FocusNode();
      viewModel.fetchWeather(_controller.text);
    });

    onDispose(() {
      _controller.dispose();
      _focusNode.dispose();
    });

    return Scaffold(
      appBar: AppBar(
        title: EditableText(
          controller: _controller,
          focusNode: _focusNode,
          style: Theme.of(context).textTheme.headlineSmall!,
          cursorColor: Colors.blueAccent,
          backgroundCursorColor: Colors.black,
          textAlign: TextAlign.center,
          onSubmitted: viewModel.fetchWeather,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            _buildWeatherCondition(context, isLoading, weather),
            _buildTemperatureDisplay(context, isLoading, weather),
            const SizedBox(height: 64),
            _buildWeatherDetails(context, isLoading, weather),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCondition(
    BuildContext context,
    bool isLoading,
    Weather? weather,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoading
          ? SizedBox(
              height: 52,
              child: Text(
                'Fetching...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  weather!.current.condition.imageUrl,
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
    );
  }

  Widget _buildTemperatureDisplay(
    BuildContext context,
    bool isLoading,
    Weather? weather,
  ) {
    return Column(
      children: [
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(weather),
              isLoading ? '...' : '${weather!.current.tempC.toInt()}°',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 180, color: Colors.black87),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(weather),
              isLoading
                  ? '...'
                  : 'Feels like ${weather!.current.feelsLikeC.toInt()}°',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(
    BuildContext context,
    bool isLoading,
    Weather? weather,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailItem(
            context,
            icon: Icons.opacity_outlined,
            value: isLoading ? '...' : '${weather!.current.humidity}%',
          ),
          _buildDetailItem(
            context,
            icon: Icons.air,
            value:
                isLoading ? '...' : '${weather!.current.windKph.toInt()} km/h',
          ),
          _buildDetailItem(
            context,
            icon: Icons.wb_sunny_outlined,
            value: isLoading ? '...' : '${weather!.current.uv} UV',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String value,
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
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
