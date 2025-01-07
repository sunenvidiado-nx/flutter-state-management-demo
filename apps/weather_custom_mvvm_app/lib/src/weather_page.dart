import 'package:flutter/material.dart';
import 'package:my_own_mvvm_with_dependency_injection_blackjack_and_hookers/dependencies.dart';
import 'package:weather_custom_mvvm_app/src/weather_view_model.dart';
import 'package:weather_repository/weather_repository.dart';

final class WeatherPage extends ViewWidget<WeatherViewModel> {
  WeatherPage({super.key});

  final _controller = TextEditingController(text: 'Manila');
  final _focusNode = FocusNode();

  @override
  WeatherViewModel viewModelFactory(Dependencies scope) {
    return WeatherViewModel(scope.get<WeatherRepository>());
  }

  @override
  void initState(BuildContext context, WeatherViewModel viewModel) {
    super.initState(context, viewModel);
    viewModel.fetchWeather(_controller.text);
  }

  @override
  void dispose(BuildContext context, WeatherViewModel viewModel) {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose(context, viewModel);
  }

  @override
  Widget build(BuildContext context, WeatherViewModel viewModel) {
    return Scaffold(
      appBar: _buildAppBar(context, viewModel),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            _buildWeatherCondition(context, viewModel),
            _buildTemperatureDisplay(context, viewModel),
            const SizedBox(height: 64),
            _buildWeatherDetails(context, viewModel),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WeatherViewModel viewModel,
  ) {
    return AppBar(
      title: EditableText(
        controller: _controller,
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.headlineSmall!,
        cursorColor: Colors.blueAccent,
        backgroundCursorColor: Colors.black,
        textAlign: TextAlign.center,
        onSubmitted: viewModel.fetchWeather,
      ),
    );
  }

  Widget _buildWeatherCondition(
    BuildContext context,
    WeatherViewModel viewModel,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: viewModel.isLoading
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
                  viewModel.weather!.current.condition.imageUrl,
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
                ),
                Text(
                  viewModel.weather!.current.condition.text,
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
    );
  }

  Widget _buildTemperatureDisplay(
    BuildContext context,
    WeatherViewModel viewModel,
  ) {
    return Column(
      children: [
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(viewModel.weather),
              viewModel.isLoading
                  ? '...'
                  : '${viewModel.weather!.current.tempC.toInt()}°',
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
              key: ValueKey(viewModel.weather),
              viewModel.isLoading
                  ? '...'
                  : 'Feels like ${viewModel.weather!.current.feelsLikeC.toInt()}°',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(
    BuildContext context,
    WeatherViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailItem(
            context,
            icon: Icons.opacity_outlined,
            value: viewModel.isLoading
                ? '...'
                : '${viewModel.weather!.current.humidity}%',
          ),
          _buildDetailItem(
            context,
            icon: Icons.air,
            value: viewModel.isLoading
                ? '...'
                : '${viewModel.weather!.current.windKph.toInt()} km/h',
          ),
          _buildDetailItem(
            context,
            icon: Icons.wb_sunny_outlined,
            value: viewModel.isLoading
                ? '...'
                : '${viewModel.weather!.current.uv} UV',
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
