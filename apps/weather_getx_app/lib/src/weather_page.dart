import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_getx_app/src/weather_controller.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();

  late final _weatherController = Get.put(WeatherController()); // Initialize

  @override
  void initState() {
    super.initState();
    _weatherController.fetchWeather(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    Get.delete<WeatherController>(); // Clean up
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
        onSubmitted: _weatherController.fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition() {
    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _weatherController.loading
            ? Text(
                'Fetching...',
                style: Theme.of(context).textTheme.titleLarge,
              )
            : _weatherController.weather != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        _weatherController.weather!.current.condition.imageUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        _weatherController.weather!.current.condition.text,
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    ],
                  )
                : const SizedBox.shrink(),
      );
    });
  }

  Widget _buildTemperatureDisplay() {
    return Column(
      children: [
        Center(
          child: Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                key: ValueKey(_weatherController.weather),
                _weatherController.weather != null &&
                        !_weatherController.loading
                    ? '${_weatherController.weather!.current.tempC.toInt()}°'
                    : '...',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 180, color: Colors.black87),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        Center(
          child: Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                key: ValueKey(_weatherController.weather),
                _weatherController.weather != null
                    ? 'Feels like ${_weatherController.weather!.current.feelsLikeC.toInt()}°'
                    : 'Fetching...',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            );
          }),
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
            valueBuilder: (weather) => '${weather.current.windKph} km/h',
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
    return Obx(() {
      final weather = _weatherController.weather;

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
          const SizedBox(height: 8),
          Text(
            key: ValueKey(weather),
            weather != null ? valueBuilder(weather) : '...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
    });
  }
}
