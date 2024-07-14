part of 'app_controller.dart';

sealed class AppEvent extends BlocEvent {
  const AppEvent();
}

class AppInitialEvent extends AppEvent {
  const AppInitialEvent();
}

class AppUpdateLocationEvent extends AppEvent {
  const AppUpdateLocationEvent(this.location);
  final GoogleAddressComponent location;
}

class AppFetchLocationEvent extends AppEvent {
  const AppFetchLocationEvent();
}
