import 'package:flutter/material.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weather_value_notifier_app/src/weather_view_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();
  final _viewModel = WeatherViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchWeather(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _viewModel.dispose();
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
        onSubmitted: _viewModel.fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition() {
    return ValueListenableBuilder<bool>(
      valueListenable: _viewModel.loadingNotifier,
      builder: (context, loading, child) {
        return ValueListenableBuilder<Weather?>(
          valueListenable: _viewModel.weatherNotifier,
          builder: (context, weather, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: switch (weather) {
                final Weather? _ when loading => Center(
                    child: Text(
                      'Fetching...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                final Weather weather when !loading => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          weather.current.condition.imageUrl,
                          width: 52,
                          height: 52,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          weather.current.condition.text,
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ],
                    ),
                  ),
                _ => const SizedBox.shrink(),
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTemperatureDisplay() {
    return ValueListenableBuilder<bool>(
      valueListenable: _viewModel.loadingNotifier,
      builder: (context, loading, child) {
        return ValueListenableBuilder<Weather?>(
          valueListenable: _viewModel.weatherNotifier,
          builder: (context, weather, child) {
            return Column(
              children: [
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      key: ValueKey(weather),
                      switch (weather) {
                        final Weather? _ when loading => '...',
                        final Weather weather when !loading =>
                          '${weather.current.tempC.toInt()}°',
                        _ => '',
                      },
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
                      switch (weather) {
                        final Weather? _ when loading => '...',
                        final Weather weather when !loading =>
                          'Feels like ${weather.current.feelsLikeC.toInt()}°',
                        _ => '',
                      },
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWeatherDetails() {
    return ValueListenableBuilder(
      valueListenable: _viewModel.loadingNotifier,
      builder: (context, loading, child) {
        return ValueListenableBuilder(
          valueListenable: _viewModel.weatherNotifier,
          builder: (context, weather, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDetailItem(
                    icon: Icons.opacity_outlined,
                    value: switch (weather) {
                      final Weather? _ when loading => '...',
                      final Weather weather when !loading =>
                        '${weather.current.humidity}%',
                      _ => '',
                    },
                  ),
                  _buildDetailItem(
                    icon: Icons.air,
                    value: switch (weather) {
                      final Weather? _ when loading => '...',
                      final Weather weather when !loading =>
                        '${weather.current.windKph.toInt()} km/h',
                      _ => '',
                    },
                  ),
                  _buildDetailItem(
                    icon: Icons.wb_sunny_outlined,
                    value: switch (weather) {
                      final Weather? _ when loading => '...',
                      final Weather weather when !loading =>
                        '${weather.current.uv} UV',
                      _ => '',
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem({required IconData icon, required String value}) {
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
