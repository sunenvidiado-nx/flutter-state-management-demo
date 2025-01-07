import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherPage extends HookWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: 'Manila');
    final focusNode = useFocusNode();
    final weatherRepository = useMemoized(() =>
        WeatherRepository(const String.fromEnvironment('WEATHER_API_KEY')));

    final weather = useState<Weather?>(null);
    final isLoading = useState(false);

    final fetchWeather = useCallback((String city) async {
      isLoading.value = true;
      final result = await weatherRepository.getWeather(city);
      weather.value = result;
      isLoading.value = false;
    }, [weatherRepository]);

    useEffect(() {
      fetchWeather(controller.text);
      return null;
    }, []);

    return Scaffold(
      appBar: _buildAppBar(context, controller, focusNode, fetchWeather),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            _buildWeatherCondition(context, weather.value, isLoading.value),
            _buildTemperatureDisplay(context, weather.value, isLoading.value),
            const SizedBox(height: 64),
            _buildWeatherDetails(context, weather.value, isLoading.value),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    Future<void> Function(String) fetchWeather,
  ) {
    return AppBar(
      title: EditableText(
        controller: controller,
        focusNode: focusNode,
        style: Theme.of(context).textTheme.headlineSmall!,
        cursorColor: Colors.blueAccent,
        backgroundCursorColor: Colors.black,
        textAlign: TextAlign.center,
        onSubmitted: fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition(
    BuildContext context,
    Weather? weather,
    bool isLoading,
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
    Weather? weather,
    bool isLoading,
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
    Weather? weather,
    bool isLoading,
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
