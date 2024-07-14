import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/_libraries/widgets/notification_messenger/notification_manager.dart';
import '/controllers/app/app_controller.dart';
import '/global/app_config.dart';
import '_libraries/console/console_manager.dart';
import '_libraries/geocoding/models/google_address.dart';
import 'utils/app_helpers/_app_helper_import.dart';
import 'utils/app_helpers/app_themes/theme_store.dart';

class Weather extends StatelessWidget {
  const Weather({required this.currentLocation, super.key});

  final GoogleAddressComponent? currentLocation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppController(currentLocation),
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeStore(
      child: Builder(builder: (context) {
        return MaterialApp.router(
          restorationScopeId: 'root',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: Messenger().messengerKey,
          localizationsDelegates: const [
            AppStrings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppStrings.delegate.supportedLocales,
          onGenerateTitle: (context) => AppStrings.of(context).appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.of(context).primary,
            ),
            useMaterial3: true,
          ),
          builder: (context, child) {
            var result = child ?? nothing;
            if (AppKeys.debug) {
              result = ConsoleView(
                manager: getit.get<ConsoleManager>(),
                options: (context, manager, refresh) =>
                    AppConfigSwitcher(refreshConsole: refresh),
                child: result,
              );
            }
            return NotificationManager(
              controller: Messenger().notificationMessenger,
              child: result,
            );
          },
          routerConfig: Messenger().appNavigator.routerConfig,
        );
      }),
    );
  }
}
