part of 'checkin_screen_controller.dart';

sealed class CheckInScreenEvent extends BlocEvent {
  const CheckInScreenEvent();
}

class CheckInScreenInitialEvent extends CheckInScreenEvent {
  const CheckInScreenInitialEvent();
}

class FetchPlacesData extends CheckInScreenEvent {
  final String query;
  const FetchPlacesData(this.query);
}

class SelectPostCheckInLocation extends CheckInScreenEvent {
  final GooglePlace? selectedPostLocation;
  const SelectPostCheckInLocation(this.selectedPostLocation);
}

class SelectMapLocation extends CheckInScreenEvent {
  final Coordinates? coordinates;
  const SelectMapLocation(this.coordinates);
}
