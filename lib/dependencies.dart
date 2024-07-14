import 'package:image_picker/image_picker.dart';
import 'package:weather/repositories/location_repository/location_repository.dart';

import '/repositories/api_repository/api_repository.dart';
import '/repositories/auth_repository/auth_repository.dart';
import '/repositories/persistent_repository/persistent_repository.dart';
import '_libraries/console/console_manager.dart';
import '_libraries/http_services/http_services.dart';
import '_libraries/life_cycle_manager.dart';
import '_libraries/media_access.dart';
import '_libraries/persistent_storage.dart';
import 'utils/app_helpers/_app_helper_import.dart';
import 'utils/dependency.dart';

abstract class DependencyManager<T extends Widget> extends LifeCycleManager<T> {
  static List<Dependency> buildDependencies({
    ConsoleManager? consoleManager,
    PersistentStorage? persistentStorage,
    PersistentRepository Function()? persistentRepository,
    HttpServices? httpServices,
    ApiRepository Function()? apiRepo,
    LocationRepository Function()? locationRepo,
    AuthRepository Function()? authRepo,
    MediaAccess? mediaAccess,
  }) {
    return [
      Dependency<ConsoleManager>.value(
        value: consoleManager ?? (ConsoleManager()..init()),
        dispose: (element) => element.dispose(),
      ),
      Dependency<PersistentStorage>(
        create: () async =>
            persistentStorage ?? await PersistentStorage().init(),
      ),
      Dependency<PersistentRepository>(
        create: persistentRepository ??
            () => PersistentRepository(getit.get<PersistentStorage>()),
      ),
      Dependency<HttpServices>.value(
        value: httpServices ?? HttpServices(),
        dispose: (e) => e.dispose(),
      ),
      Dependency<ApiRepository>(
        create: apiRepo ?? () => ApiRepository(getit.get<HttpServices>()),
      ),
      Dependency<LocationRepository>(
        create:
            locationRepo ?? () => LocationRepository(getit.get<HttpServices>()),
      ),
      Dependency<AuthRepository>(
        create: authRepo ?? () => AuthRepository(getit.get<ApiRepository>()),
      ),
      Dependency<MediaAccess>.value(
        value: mediaAccess ?? MediaAccess(ImagePicker()),
      ),
    ];
  }

  DependencyManager([DependencyHandler? dependencyHandler])
      : _dependencyHandler = dependencyHandler ??
            DependencyHandler(dependencies: buildDependencies());

  final DependencyHandler _dependencyHandler;

  @override
  Future<void> init() async {
    await super.init();
    await _dependencyHandler.registerDependencies();
  }

  @override
  void dispose() {
    _dependencyHandler.unregisterDependencies();
    super.dispose();
  }
}
