import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/weather/models/weather_condition.dart';
import 'package:weather/_libraries/widgets/remote_data_builder.dart';
import 'package:weather/_libraries/widgets/value_transitioned_builder.dart';
import 'package:weather/controllers/app/app_controller.dart';
import 'package:weather/utils/app_helpers/_app_helper_import.dart';

import '/_libraries/bloc/bloc_view.dart';
import '/controllers/home/home_controller.dart';

class HomeScreen extends BlocView<HomeController, HomeState> {
  static Widget get provider {
    return BlocProvider(
      create: (context) => HomeController(context.read<AppController>()),
      child: const HomeScreen(),
    );
  }

  const HomeScreen({super.key});

  @override
  void blocListener(
    BuildContext context,
    HomeState state,
    HomeController controller,
  ) {
    if (state.status.isSuccess) {
      // Success
    } else if (state.status.isFailed) {
      // Failed
    }
  }

  @override
  Widget buildContent(
    BuildContext context,
    HomeState state,
    HomeController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.of(context).primary,
            AppColors.of(context).secondary,
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.of(context).transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Gap(16),
                Row(
                  children: [
                    if (state.location != null) ...[
                      const Icon(
                        Icons.place_outlined,
                        color: AppColors.white,
                      ),
                      const Gap(16),
                      Text(
                        state.location?.consolidatedCity ?? '',
                        style: AppStyles.of(context).heading.cWhite,
                      )
                    ],
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Messenger()
                            .snackbarMessenger
                            .infoSnackbar
                            .show("Under Development");
                        // var res = Messenger()
                        //     .navigator
                        //     .pushNamed(AppRoutes.checkinLocation.name);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const Gap(24),
                if (state.location == null)
                  Text(
                    "No location selected",
                    style: AppStyles.of(context).sLarge.wBolder.cWhite,
                  )
                else
                  Expanded(
                    child: RemoteDataBuilder(
                      data: state.forecast,
                      isLoading: state.isLoading(HomeFetchWeatherEvent),
                      loadingIndicator: (context) => const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: AppColors.white,
                        ),
                      ),
                      failureBuilder: (context) => Center(
                        child: Text(
                          "No data found",
                          style: AppStyles.of(context).sLarge.wBolder.cWhite,
                        ),
                      ),
                      builder: (context, forecast) {
                        return Column(
                          children: [
                            _currentConditions(forecast),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _currentConditions(WeatherForecast forecast) {
    return Builder(builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white.withOpacity(.3),
              AppColors.white.withOpacity(0)
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.white.withOpacity(.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              forecast.time.convertDate("dd MMMM"),
              style: AppStyles.of(context).heading.cWhite,
            ),
            // °
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ValueTransitionedBuilder(
                initialValue: true,
                builder: (context, isCelsius, update, child) {
                  final celsius = forecast.current.temp - 273.15;
                  final fahrenheit = celsius * 9 / 5 + 32;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => update(!isCelsius),
                        child: Text(
                          "${(isCelsius ? celsius : fahrenheit).toInt()}",
                          style: AppStyles.of(context).sized(64).cWhite,
                        ),
                      ),
                      const Gap(4),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Text(
                          "°${isCelsius ? "C" : "F"}",
                          style: AppStyles.of(context).sLarge.cWhite,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Text(
              forecast.current.conditions.values.first.capitalize,
              style: AppStyles.of(context).heading.cWhite,
            ),
            const Gap(8),
            IconTheme.merge(
              data: const IconThemeData(
                color: AppColors.white,
                size: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _measurements(
                    icon: const Icon(Icons.thermostat),
                    title: "Feels Like",
                    value:
                        "${(forecast.current.feelsLikeTemp - 273).toInt()} °C",
                  ),
                  const Gap(6),
                  _measurements(
                    icon: const Icon(Icons.air),
                    title: "Wind Speed",
                    value: "${(forecast.current.windSpeed).toInt()} km / h",
                  ),
                  const Gap(6),
                  _measurements(
                    icon: const Icon(Icons.water_drop),
                    title: "Humidity",
                    value: "${(forecast.current.humidity).toInt()} %",
                  ),
                  const Gap(6),
                  _measurements(
                    icon: const Icon(Icons.visibility),
                    title: "Visibility",
                    value: "${(forecast.current.visibility).toInt()} m",
                  ),
                  const Gap(6),
                  _measurements(
                    icon: const Icon(Icons.cloudy_snowing),
                    title: "Probability of Rain",
                    value:
                        "${(forecast.current.probabilityOfPrecipitation * 100).toInt()} %",
                  ),
                  const Gap(6),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _measurements({
    required Widget icon,
    required String title,
    required String value,
  }) {
    return IntrinsicHeight(
      child: Builder(builder: (context) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const Gap(6),
            Text(title, style: AppStyles.of(context).cWhite),
            const Gap(12),
            Text(value, style: AppStyles.of(context).cWhite),
          ],
        );
      }),
    );
  }
}
