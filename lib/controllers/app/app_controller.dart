import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/geocoding/models/google_address.dart';

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
