import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:weather_mobx_app/src/weather_store.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();
  final _store = WeatherStore();

  @override
  void initState() {
    super.initState();
    _store.fetchWeather(_controller.text);
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
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            _buildWeatherCondition(context),
            _buildTemperatureDisplay(context),
            const SizedBox(height: 64),
            _buildWeatherDetails(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: EditableText(
        controller: _controller,
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.headlineSmall!,
        cursorColor: Colors.blueAccent,
        backgroundCursorColor: Colors.black,
        textAlign: TextAlign.center,
        onSubmitted: _store.fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition(BuildContext context) {
    return Observer(
      builder: (context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _store.isLoading
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
                    _store.weather!.current.condition.imageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    _store.weather!.current.condition.text,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildTemperatureDisplay(BuildContext context) {
    return Observer(
      builder: (context) => Column(
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                key: ValueKey(_store.weather),
                _store.isLoading
                    ? '...'
                    : '${_store.weather!.current.tempC.toInt()}°',
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
                key: ValueKey(_store.weather),
                _store.isLoading
                    ? '...'
                    : 'Feels like ${_store.weather!.current.feelsLikeC.toInt()}°',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(BuildContext context) {
    return Observer(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDetailItem(
              context: context,
              icon: Icons.opacity_outlined,
              value: _store.isLoading
                  ? '...'
                  : '${_store.weather!.current.humidity}%',
            ),
            _buildDetailItem(
              context: context,
              icon: Icons.air,
              value: _store.isLoading
                  ? '...'
                  : '${_store.weather!.current.windKph.toInt()} km/h',
            ),
            _buildDetailItem(
              context: context,
              icon: Icons.wb_sunny_outlined,
              value:
                  _store.isLoading ? '...' : '${_store.weather!.current.uv} UV',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required BuildContext context,
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
