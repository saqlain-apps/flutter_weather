part of 'checkin_screen_controller.dart';

class CheckInScreenStateStore extends BlocStateStore {
  CheckInScreenStateStore();

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
  }
}

class CheckInScreenState extends BlocState<CheckInScreenStateStore> {
  final List<GooglePlace>? placesApi;
  final GooglePlace? selectedCheckInLocation;
  final Coordinates? coordinates;

  CheckInScreenState({
    super.event = const CheckInScreenInitialEvent(),
    super.eventStatus,
    super.message,
    super.data,
    CheckInScreenStateStore? store,
    this.coordinates,
    this.placesApi,
    this.selectedCheckInLocation,
  }) : super(store: store ?? CheckInScreenStateStore());

  @override
  CheckInScreenState copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    List<GooglePlace>? placesApi,
    GooglePlace? selectedCheckInLocation,
    Coordinates? coordinates,
    dynamic data,
  }) {
    return CheckInScreenState(
      event: event,
      eventStatus: eventStatus ?? this.eventStatus,
      message: message,
      data: data,
      placesApi: placesApi ?? this.placesApi,
      coordinates: coordinates ?? this.coordinates,
      selectedCheckInLocation:
          selectedCheckInLocation ?? this.selectedCheckInLocation,
      store: store,
    );
  }

  CheckInScreenState loading(CheckInScreenEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.loading), event: event);

  CheckInScreenState success(CheckInScreenEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.success), event: event);

  CheckInScreenState failure(CheckInScreenEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.failure), event: event);

  CheckInScreenState none(CheckInScreenEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.none), event: event);
}
