part of 'app_controller.dart';

sealed class AppEvent extends BlocEvent {
  const AppEvent();
}

class AppInitialEvent extends AppEvent {
  const AppInitialEvent();
}