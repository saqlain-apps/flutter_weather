import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/bloc/bloc_event.dart';
import 'package:weather/_libraries/bloc/bloc_state.dart';
import 'package:weather/_libraries/generic_status.dart';
import 'package:weather/_libraries/geocoding/models/coordinates.dart';
import 'package:weather/_libraries/geocoding/models/google_address.dart';
import 'package:weather/_libraries/pagination_interface.dart';
import 'package:weather/repositories/location_repository/location_repository.dart';
import 'package:weather/utils/app_helpers/_app_helper_import.dart';

part 'checkin_screen_event.dart';
part 'checkin_screen_state.dart';

class LocationCheckInScreenController
    extends Bloc<CheckInScreenEvent, CheckInScreenState> {
  LocationCheckInScreenController() : super(CheckInScreenState()) {
    on<FetchPlacesData>(_fetchPlacesData);
    on<SelectPostCheckInLocation>(_onSelectPostCheckInLocation);
    on<SelectMapLocation>(_onSelectMapLocation);

    _init();
  }

  @override
  Future<void> close() {
    state.store.dispose();
    return super.close();
  }

  Future<void> _fetchPlacesData(
    FetchPlacesData event,
    Emitter<CheckInScreenState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(event: event, placesApi: List.empty()));
      return;
    }

    try {
      emit(state.loading(event));
      var result = await getit
          .get<LocationRepository>()
          .fetchPlaceWithQuery(event.query);
      if (result != null) {
        emit(state.copyWith(
          event: event,
          eventStatus: state.updateStatus(event, GenericStatus.success),
          placesApi: result,
        ));
      } else {
        emit(state.failure(event));
      }
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  void _init() {
    PaginationInterface.dynamicSearch(
      searchControllers: [state.store.searchController],
      callback: (search) {
        if (search.trim().isNotEmpty) {
          add(FetchPlacesData(state.store.searchController.text.trim()));
        }
      },
      debounceMilliseconds: 1000,
    );
  }

  FutureOr<void> _onSelectPostCheckInLocation(
    SelectPostCheckInLocation event,
    Emitter<CheckInScreenState> emit,
  ) {
    state.store.searchController.clear();
    emit(state.copyWith(
        event: event, selectedCheckInLocation: event.selectedPostLocation));
  }

  FutureOr<void> _onSelectMapLocation(
    SelectMapLocation event,
    Emitter<CheckInScreenState> emit,
  ) {
    emit(state.copyWith(event: event, coordinates: event.coordinates));
  }
}
