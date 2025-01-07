# Flutter Weather App - State Management Demo

This repository showcases different state management approaches in Flutter through a collection of weather applications. Each implementation demonstrates the same functionality using different state management solutions, making it an excellent resource for comparing various approaches.

## 🌦 Features

- Weather information display using WeatherAPI.com
- Search functionality for different locations
- Consistent UI across all implementations
- Demonstrates proper architecture and dependency injection patterns

## 📱 Available Implementations

1. **SetState** (`weather_set_state_app`)
   - Basic Flutter state management
   - Simple and straightforward approach

2. **ChangeNotifier** (`weather_change_notifier_app`)
   - Provider-based implementation
   - Uses Flutter's built-in ChangeNotifier

3. **ValueListenable** (`weather_value_listenable_app`)
   - Lightweight alternative to ChangeNotifier
   - Efficient value-based state management

4. **Riverpod** (`weather_riverpod_app`)
   - Modern dependency injection and state management
   - Type-safe and maintainable approach

5. **Bloc** (`weather_bloc_app`)
   - Robust state management pattern
   - Clear separation of business logic

6. **GetX** (`weather_getx_app`)
   - Feature-rich state management solution
   - Includes routing and dependency injection

7. **MobX** (`weather_mobx_app`)
   - Observable-based state management
   - Reactive programming approach

8. **Flutter Hooks** (`weather_flutter_hooks_app`)
   - React-like state management
   - Reduces boilerplate in StatefulWidgets

9. **Async Redux** (`weather_async_redux_app`)
   - Redux implementation for Flutter
   - Handles async operations elegantly

10. **Watch_it** (`weather_watch_it_app`)
    - Lightweight dependency injection
    - Simple state management solution

11. **Custom MVVM** (`my_own_mvvm_with_dependency_injection_blackjack_and_hookers`)
    - Crazy name, but it's a custom MVVM implementation
    - Demonstrates architectural principles

12. **Very Simple State Manager** (`very_simple_state_manager`)
    - Simple and efficient state management (created by me!)
    - Aptly named!

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (version 3.27.1)
- WeatherAPI.com API key (get it from [https://www.weatherapi.com/](https://www.weatherapi.com/))

### Running the Apps

1. Clone the repository:
   ```bash
   git clone https://github.com/sunenvidiado-nx/flutter-state-management-demo.git
   cd flutter-state-management-demo
   ```

2. Set up Flutter version:
   ```bash
   fvm install 3.27.1
   fvm use 3.27.1
   ```

3. Run any app using VS Code launch configurations or via command line:
   ```bash
   cd apps/[app_name]
   flutter run --dart-define WEATHER_API_KEY=your_api_key_here
   ```

## 📚 Project Structure

```
flutter-state-management-demo/
├── apps/
│   ├── weather_set_state_app/
│   ├── weather_change_notifier_app/
│   ├── weather_value_listenable_app/
│   └── ... (other implementations)
└── packages/
    └── weather_repository/
```
