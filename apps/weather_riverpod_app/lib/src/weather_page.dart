import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weather_riverpod_app/src/weather_notifier.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weatherNotifierProvider);
    final notifier = ref.read(weatherNotifierProvider.notifier);

    return Scaffold(
      appBar: _buildAppBar(notifier),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            _buildWeatherCondition(state),
            _buildTemperatureDisplay(state),
            const SizedBox(height: 64),
            _buildWeatherDetails(state),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(WeatherNotifier notifier) {
    return AppBar(
      title: EditableText(
        controller: _controller,
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.headlineSmall!,
        cursorColor: Colors.blueAccent,
        backgroundCursorColor: Colors.black,
        textAlign: TextAlign.center,
        onSubmitted: notifier.fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition(AsyncValue<Weather> state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: state.when(
        loading: () => SizedBox(
          height: 52,
          child: Text(
            'Fetching...',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        error: (_, __) => const Text(':-('),
        data: (weather) => Column(
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
      ),
    );
  }

  Widget _buildTemperatureDisplay(AsyncValue<Weather> state) {
    return Column(
      children: [
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(state),
              state.when(
                data: (weather) => '${weather.current.tempC.toInt()}°',
                error: (_, __) => ':-(',
                loading: () => '...',
              ),
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
              state.when(
                data: (weather) =>
                    'Feels like ${weather.current.feelsLikeC.toInt()}°',
                error: (_, __) => 'Something went wrong.',
                loading: () => 'Fetching...',
              ),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(AsyncValue<Weather> state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailItem(
            icon: Icons.opacity_outlined,
            value: state.when(
              data: (weather) => '${weather.current.humidity}%',
              error: (_, __) => ':-(',
              loading: () => '...',
            ),
          ),
          _buildDetailItem(
            icon: Icons.air,
            value: state.when(
              data: (weather) => '${weather.current.windKph.toInt()} km/h',
              error: (_, __) => ':-(',
              loading: () => '...',
            ),
          ),
          _buildDetailItem(
            icon: Icons.wb_sunny_outlined,
            value: state.when(
              data: (weather) => '${weather.current.uv} UV',
              error: (_, __) => ':-(',
              loading: () => '...',
            ),
          ),
        ],
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
