import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/geocoding/location_services.dart';
import 'package:weather/_libraries/geocoding/models/google_address.dart';
import 'package:weather/repositories/location_repository/location_repository.dart';

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
    Messenger().appNavigator.init(AppRoutes.home.name);
  }

  Future<void> fetchLocation() async {
    final locationRepo = getit.get<LocationRepository>();
    try {
      final coordinates = (await locationRepo.currentPosition()).coordinates;
      location = await locationRepo.fetchPlaceWithCoordinates(coordinates);
    } catch (e) {
      location = null;
    }
  }

  late final GoogleAddressComponent? location;

  @override
  Widget build() {
    return Weather(currentLocation: location);
  }
}
