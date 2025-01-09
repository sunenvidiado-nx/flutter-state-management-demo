import 'package:flutter/material.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();
  final _weatherRepository =
      WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY'));

  late final _weatherNotifier = ValueNotifier<Weather?>(null);

  bool get _isLoading => _weatherNotifier.value == null;

  @override
  void initState() {
    super.initState();
    _fetchWeather(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _weatherNotifier.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String location) async {
    _weatherNotifier.value = null;
    final weather = await _weatherRepository.getWeather(location);
    _weatherNotifier.value = weather;
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
        onSubmitted: _fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition() {
    return ValueListenableBuilder<Weather?>(
      valueListenable: _weatherNotifier,
      builder: (context, weather, _) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading
            ? Text('Fetching...', style: Theme.of(context).textTheme.titleLarge)
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      weather!.current.condition.imageUrl,
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
      ),
    );
  }

  Widget _buildTemperatureDisplay() {
    return ValueListenableBuilder<Weather?>(
      valueListenable: _weatherNotifier,
      builder: (context, weather, _) => Column(
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                key: ValueKey(weather),
                _isLoading ? '...' : '${weather!.current.tempC.toInt()}°',
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
                _isLoading
                    ? '...'
                    : 'Feels like ${weather!.current.feelsLikeC.toInt()}°',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return ValueListenableBuilder<Weather?>(
      valueListenable: _weatherNotifier,
      builder: (context, weather, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDetailItem(
              icon: Icons.opacity_outlined,
              value: _isLoading ? '...' : '${weather!.current.humidity}%',
            ),
            _buildDetailItem(
              icon: Icons.air,
              value: _isLoading
                  ? '...'
                  : '${weather!.current.windKph.toInt()} km/h',
            ),
            _buildDetailItem(
              icon: Icons.wb_sunny_outlined,
              value: _isLoading ? '...' : '${weather!.current.uv} UV',
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
