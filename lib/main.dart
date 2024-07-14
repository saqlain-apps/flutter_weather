import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/geocoding/location_services.dart';
import 'package:weather/_libraries/geocoding/models/coordinates.dart';
import 'package:weather/_libraries/geocoding/models/google_address.dart';
import 'package:weather/repositories/location_repository/location_repository.dart';

import '/_libraries/web_functions/web_functions.dart';
import '/controllers/app_bloc_observer.dart';
import '/utils/app_helpers/_app_helper_import.dart';
import '_main.dart';
import 'dependencies.dart';

void main() => ApplicationManager().run();

class ApplicationManager extends DependencyManager {
  ApplicationManager([super.dependencyManager]);

  @override
  Future<void> init() async {
    await super.init();
    await configureApp();
  }

  FutureOr<void> configureApp() async {
    await fetchLocation();
    Bloc.observer = AppBlocObserver();
    WebFunctions().configureUrl();
    Messenger().appNavigator.init(AppRoutes.home.name);
  }

  Future<void> fetchLocation() async {
    final locationRepo = getit.get<LocationRepository>();

    Coordinates coordinates = const Coordinates(
      latitude: 28.66004989999999,
      longitude: 77.2749894,
    );
    try {
      coordinates = (await locationRepo.currentPosition()).coordinates;
    } catch (e) {
      // Permission failed, Do Nothing
    }

    location = await locationRepo.fetchPlaceWithCoordinates(coordinates);
  }

  late final GoogleAddressComponent? location;

  @override
  Widget build() {
    return Weather(currentLocation: location);
  }
}
