import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:weather_async_redux_app/src/weather_actions.dart';
import 'weather_state.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.dispatch(FetchWeatherAction(location: _controller.text));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<WeatherState, WeatherState>(
      converter: (store) => store.state,
      builder: (context, state) {
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
      },
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
        onSubmitted: (value) =>
            context.dispatch(FetchWeatherAction(location: value)),
      ),
    );
  }

  Widget _buildWeatherCondition() {
    final state = context.getState<WeatherState>();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: state.isLoading
          ? SizedBox(
              height: 52,
              child: Text(
                'Fetching...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : state.weather == null
              ? const SizedBox.shrink()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      state.weather!.current.condition.imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      state.weather!.current.condition.text,
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
    );
  }

  Widget _buildTemperatureDisplay() {
    final state = context.getState<WeatherState>();

    return Column(
      children: [
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(state.weather),
              state.isLoading
                  ? '...'
                  : state.weather == null
                      ? ''
                      : '${state.weather!.current.tempC.toInt()}°',
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
              key: ValueKey(state.weather),
              state.isLoading
                  ? '...'
                  : state.weather == null
                      ? ''
                      : 'Feels like ${state.weather!.current.feelsLikeC.toInt()}°',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    final state = context.getState<WeatherState>();

    if (state.weather == null && !state.isLoading) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDetailItem(
            icon: Icons.opacity_outlined,
            value:
                state.isLoading ? '...' : '${state.weather!.current.humidity}%',
          ),
          _buildDetailItem(
            icon: Icons.air,
            value: state.isLoading
                ? '...'
                : '${state.weather!.current.windKph.toInt()} km/h',
          ),
          _buildDetailItem(
            icon: Icons.wb_sunny_outlined,
            value: state.isLoading ? '...' : '${state.weather!.current.uv} UV',
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
