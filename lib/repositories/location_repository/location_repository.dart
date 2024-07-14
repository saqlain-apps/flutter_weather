import 'package:weather/_libraries/base_api_repository/base_api_repository.dart';
import 'package:weather/_libraries/weather/weather.dart';

import '/_libraries/geocoding/geocoding.dart';
import '/_libraries/geocoding/location_services.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class LocationRepository extends BaseApiRepository
    with LocationServices, Geocoding, Weather {
  LocationRepository(super.httpService);

  @override
  String get geocodingApiKey => AppKeys.googleApiKey;

  @override
  String get weatherApiKey => AppKeys.weatherApiKey;

  @override
  void permissionDeniedForever(void Function() openAppSettings) {
    Messenger().snackbarMessenger.infoSnackbar.showAdvanced(
          message:
              'Location permissions are permanently denied, please allow from settings.',
          action: TextButton(
            onPressed: openAppSettings,
            child: const Text("Open"),
          ),
          duration: const Duration(seconds: 6),
        );
  }
}
