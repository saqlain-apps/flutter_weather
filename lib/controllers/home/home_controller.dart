import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/geocoding/models/google_address.dart';
import 'package:weather/_libraries/geocoding/models/place_prediction.dart';
import 'package:weather/_libraries/task_handler/task_handler.dart';
import 'package:weather/_libraries/weather/models/weather_condition.dart';
import 'package:weather/repositories/location_repository/location_repository.dart';

import '/_libraries/bloc/bloc_event.dart';
import '/_libraries/bloc/bloc_state.dart';
import '/_libraries/generic_status.dart';
import '/utils/app_helpers/_app_helper_import.dart';
import '../app/app_controller.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeController extends Bloc<HomeEvent, HomeState> {
  final AppController appController;
  HomeController(this.appController)
      : super(HomeState(location: appController.state.location)) {
    printPersistent('HomeController Initialized');

    on<HomeSyncEvent>(sync);
    on<HomeFetchWeatherEvent>(fetchWeather);
    on<HomeSelectLocationEvent>(selectLocation);

    _init();
  }

  final TimedTaskHandler debouncer = TimedTaskHandler(400);
  StreamSubscription<AppState>? sub;
  LocationRepository get locationRepo => getit.get<LocationRepository>();

  void _init() {
    if (state.location != null) {
      add(const HomeFetchWeatherEvent());
    }

    sub = appController.stream.listen((state) {
      add(HomeSyncEvent(state));
    });
  }

  void sync(
    HomeSyncEvent event,
    Emitter<HomeState> emit,
  ) {
    final updatedLocation = event.appState.location;
    final didUpdateLocation =
        updatedLocation?.coordinates != state.location?.coordinates;
    emit(state.copyWith(
      event: event,
      location: updatedLocation,
    ));

    if (didUpdateLocation) {
      add(const HomeFetchWeatherEvent(reset: true));
    }
  }

  FutureOr<void> fetchWeather(
    HomeFetchWeatherEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (event.reset) {
        emit(state.copyWith(event: event, forecast: () => null));
      }

      emit(state.loading(event));

      final forecast = await locationRepo
          .weatherForecastFromNow(state.location!.coordinates);

      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.success),
        forecast: () => forecast,
      ));
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> selectLocation(
    HomeSelectLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.loading(event));
      final location = await locationRepo.fetchPlaceWithId(event.place.id);
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.success),
        location: location,
      ));
      if (location != null) {
        add(const HomeFetchWeatherEvent(reset: true));
      }
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> baseEventCallback(
    HomeEvent event,
    Emitter<HomeState> emit,
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

  Future<List<PlacePrediction>> autocomplete(String query) async {
    if (query.isEmpty) return [];
    final res = await debouncer.handleReturn<List<PlacePrediction>?>(
        () => locationRepo.fetchPlaceAutoComplete(query));
    return res ?? [];
  }

  @override
  Future<void> close() {
    printPersistent('HomeController Disposed');
    sub?.cancel();
    state.store.dispose();
    return super.close();
  }
}
