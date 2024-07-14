import '/user_interface/components/generic_components/toggle_switch.dart';
import '/utils/app_helpers/_app_helper_import.dart';

enum AppConfigType {
  dev,
  testing,
  qa,
  stage,
  prod;

  bool get isDevelopment => this == dev;
  bool get isTesting => this == testing;
  bool get isQA => this == qa;
  bool get isRelease => this == stage || this == prod;

  AppConfig get config {
    return switch (this) {
      dev => const DevConfig(),
      _ => const TestingConfig(),
    };
  }
}

abstract class AppConfig {
  const AppConfig._internal();

  factory AppConfig.custom(AppConfigType mode) {
    return mode.config;
  }

  factory AppConfig() => AppConfig.custom(globalModeType);

  AppConfigType get modeType;
  String get mode => modeType.name;

  String get googlePlacesApiKey =>
      const String.fromEnvironment('google_places_api_key');
  String get weatherApiKey => const String.fromEnvironment('weather_api_key');

  static AppConfigType get globalModeType =>
      AppConfigType.values.firstWhere((e) => e.name == globalMode);
  static const String globalMode =
      String.fromEnvironment('mode', defaultValue: 'testing');
  static const bool debug = bool.fromEnvironment('debug');
}

class DevConfig extends AppConfig {
  const DevConfig() : super._internal();

  @override
  AppConfigType get modeType => AppConfigType.dev;
}

class TestingConfig extends AppConfig {
  const TestingConfig() : super._internal();

  @override
  AppConfigType get modeType => AppConfigType.testing;
}

class AppConfigSwitcher extends StatelessWidget {
  const AppConfigSwitcher({required this.refreshConsole, super.key});

  final VoidCallback refreshConsole;

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      currentIndex: AppConfigType.values.indexOf(AppKeys.config.modeType),
      length: AppConfigType.values.length,
      builder: (context, index, isSelected) {
        var type = AppConfigType.values[index];
        Widget child = Center(
          child: Text(
            type.name[0].toUpperCase(),
            style: AppStyles.of(context).colored(
                isSelected ? AppColors.white : AppColors.of(context).primary),
          ),
        );

        if (isSelected) {
          child = Container(
            decoration: BoxDecoration(
              color: AppColors.of(context).primary,
              borderRadius: BorderRadius.circular(99),
            ),
            child: child,
          );
        }
        child = GestureDetector(
          onTap: () {
            AppKeys.config = AppConfig.custom(type);
            refreshConsole();
          },
          child: Container(
            color: Colors.transparent,
            width: 32,
            child: child,
          ),
        );

        return child;
      },
    );
  }
}
