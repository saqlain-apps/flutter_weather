import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/geocoding/location_services.dart';
import 'package:weather/_libraries/geocoding/models/google_address.dart';
import 'package:weather/repositories/location_repository/location_repository.dart';

import '/_libraries/bloc/bloc_event.dart';
import '/_libraries/bloc/bloc_state.dart';
import '/_libraries/generic_status.dart';
import '/utils/app_helpers/_app_helper_import.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppController extends Bloc<AppEvent, AppState> {
  AppController(GoogleAddressComponent? location)
      : super(AppState(location: location)) {
    printPersistent('AppController Initialized');

    on<AppUpdateLocationEvent>(updateLocation);
    on<AppFetchLocationEvent>(fetchLocation);
  }

  LocationRepository get locationRepo => getit.get<LocationRepository>();

  void updateLocation(
    AppUpdateLocationEvent event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(
      event: event,
      location: event.location,
    ));
  }

  FutureOr<void> fetchLocation(
    AppFetchLocationEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(state.loading(event));

      final hasAllowedLocation = await locationRepo.isLocationAccessEnabled();
      if (!hasAllowedLocation) {
        emit(state.failure(event));
        return;
      }

      final coordinates = (await locationRepo.currentPosition()).coordinates;
      final location =
          await locationRepo.fetchPlaceWithCoordinates(coordinates);
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.success),
        location: location,
      ));
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> baseEventCallback(
    AppEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(state.loading(event));
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.success),
      ));
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    state.store.dispose();
    return super.close();
  }
}
