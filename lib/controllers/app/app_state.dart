part of 'app_controller.dart';

class AppStateStore extends BlocStateStore {
  AppStateStore();

  @override
  void dispose() {}
}

class AppState extends BlocState<AppStateStore> {
  AppState({
    super.event = const AppInitialEvent(),
    super.eventStatus,
    super.message,
    super.data,
    this.location,
    AppStateStore? store,
  }) : super(store: store ?? AppStateStore());

  final GoogleAddressComponent? location;

  @override
  AppState copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    dynamic data,
    GoogleAddressComponent? location,
  }) {
    return AppState(
      store: store,
      event: event,
      message: message,
      data: data,
      eventStatus: eventStatus ?? this.eventStatus,
      location: location ?? this.location,
    );
  }

  AppState loading(AppEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.loading), event: event);
  AppState success(AppEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.success), event: event);
  AppState failure(AppEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.failure), event: event);
  AppState none(AppEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.none), event: event);
}
