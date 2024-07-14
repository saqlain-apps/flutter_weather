import '/global/app_config.dart';

abstract class AppKeys {
  static AppConfig config = AppConfig();
  static String get googleApiKey => config.googlePlacesApiKey;
  static String get weatherApiKey => config.weatherApiKey;
  static AppConfigType get mode => config.modeType;
  static bool get debug => AppConfig.debug;
}
