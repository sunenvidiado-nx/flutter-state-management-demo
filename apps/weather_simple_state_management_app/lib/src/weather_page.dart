import 'package:flutter/material.dart';
import 'package:very_simple_state_manager/very_simple_state_manager.dart';
import 'package:weather_simple_state_management_app/src/weather_state.dart';
import 'package:weather_simple_state_management_app/src/weather_state_manager.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();
  final _weatherStateManager = WeatherStateManager();

  @override
  void initState() {
    super.initState();
    _weatherStateManager.fetchWeather(_controller.text);
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
        onSubmitted: _weatherStateManager.fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition() {
    return StateBuilder(
      stateManager: _weatherStateManager,
      builder: (context, state) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (state) {
          WeatherLoading() => SizedBox(
              height: 52,
              child: Text(
                'Fetching...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          WeatherData(weather: final weather) => Column(
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
      ),
    );
  }

  Widget _buildTemperatureDisplay() {
    return StateBuilder(
      stateManager: _weatherStateManager,
      builder: (context, state) => Column(
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                key: ValueKey(state),
                switch (state) {
                  WeatherLoading() => '...',
                  WeatherData(weather: final weather) =>
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
                key: ValueKey(state),
                switch (state) {
                  WeatherLoading() => '...',
                  WeatherData(weather: final weather) =>
                    'Feels like ${weather.current.feelsLikeC.toInt()}°',
                  _ => '',
                },
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return StateBuilder(
      stateManager: _weatherStateManager,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDetailItem(
              icon: Icons.opacity_outlined,
              value: switch (state) {
                WeatherLoading() => '...',
                WeatherData(weather: final weather) =>
                  '${weather.current.humidity}%',
                _ => '',
              },
            ),
            _buildDetailItem(
              icon: Icons.air,
              value: switch (state) {
                WeatherLoading() => '...',
                WeatherData(weather: final weather) =>
                  '${weather.current.windKph.toInt()} km/h',
                _ => '',
              },
            ),
            _buildDetailItem(
              icon: Icons.wb_sunny_outlined,
              value: switch (state) {
                WeatherLoading() => '...',
                WeatherData(weather: final weather) => '${weather.current.uv} UV',
                _ => '',
              },
            ),
          ],
        ),
      ),
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
