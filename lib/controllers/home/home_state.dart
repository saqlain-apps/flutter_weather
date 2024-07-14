part of 'home_controller.dart';

class HomeStateStore extends BlocStateStore {
  HomeStateStore({
    bool searchFieldOpen = false,
  }) : searchFieldOpen = ValueNotifier(searchFieldOpen);

  final ValueNotifier<bool> searchFieldOpen;

  @override
  void dispose() {
    searchFieldOpen.dispose();
  }
}

class HomeState extends BlocState<HomeStateStore> {
  HomeState({
    super.event = const HomeInitialEvent(),
    super.eventStatus,
    super.message,
    super.data,
    this.location,
    this.forecast,
    HomeStateStore? store,
  }) : super(store: store ?? HomeStateStore(searchFieldOpen: location == null));

  final GoogleAddressComponent? location;
  final WeatherForecast? forecast;

  @override
  HomeState copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    dynamic data,
    GoogleAddressComponent? location,
    WeatherForecast? Function()? forecast,
  }) {
    return HomeState(
      store: store,
      event: event,
      message: message,
      data: data,
      eventStatus: eventStatus ?? this.eventStatus,
      location: location ?? this.location,
      forecast: forecast != null ? forecast() : this.forecast,
    );
  }

  HomeState loading(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.loading), event: event);
  HomeState success(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.success), event: event);
  HomeState failure(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.failure), event: event);
  HomeState none(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.none), event: event);
}
