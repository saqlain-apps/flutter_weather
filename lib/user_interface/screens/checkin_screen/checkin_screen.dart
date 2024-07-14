import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/_libraries/bloc/bloc_view.dart';
import 'package:weather/_libraries/widgets/remote_data_builder.dart';
import 'package:weather/_libraries/widgets/tap_unfocus.dart';
import 'package:weather/user_interface/components/app_components/multi_field/_src.dart';

import '/utils/app_helpers/_app_helper_import.dart';
import '../../../controllers/checkin_screen/checkin_screen_controller.dart';

class LocationCheckInScreen
    extends BlocView<LocationCheckInScreenController, CheckInScreenState> {
  static Widget get provider {
    return BlocProvider(
      create: (context) => LocationCheckInScreenController(),
      child: const LocationCheckInScreen(),
    );
  }

  const LocationCheckInScreen({super.key});

  @override
  void blocListener(
    BuildContext context,
    CheckInScreenState state,
    LocationCheckInScreenController controller,
  ) {
    if (state.status.isSuccess) {
      // Success
    } else if (state.status.isFailed) {
      // Failed
      var failureMessage = state.message;
      if (isNotBlank(failureMessage)) {
        Messenger().notificationMessenger.errorMessage.show(failureMessage!);
      }
    }
  }

  @override
  Widget buildContent(
    BuildContext context,
    CheckInScreenState state,
    LocationCheckInScreenController controller,
  ) {
    return TapUnfocus(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text(
            "Select Location",
            style: AppStyles.of(context).sized(17).wSemiBold,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: SearchTextField(
                autofocus: true,
                hintText: "Search for an area",
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.sp)),
                controller: state.store.searchController,
              ),
            ),
            if ((state.store.searchController.text.isNotEmpty))
              if ((state.placesApi == null || state.placesApi!.isEmpty) &&
                  !state.isLoading())
                Expanded(
                  child: RemoteDataBuilder.defaultFailureBuilder(context,
                      text: "No Locations Found"),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      final placesData = state.placesApi![index];
                      return InkWell(
                        onTap: () {
                          controller.add(SelectPostCheckInLocation(placesData));
                          Messenger().navigator.pop(placesData);
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.all(8.w),
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.black,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    placesData.name,
                                    style:
                                        AppStyles.of(context).wSemiBold.cBlack,
                                    maxLines: 4,
                                    softWrap: true, // Add this line
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.84,
                                  child: Text(
                                    placesData.address,
                                    maxLines: 4,
                                    softWrap: true, // Add this line
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const Divider();
                    },
                    itemCount: state.placesApi?.length ?? 0,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                  ),
                ),
            if (state.isLoading() && state.event is FetchPlacesData) ...[
              // (state.placesApi == null || state.placesApi!.isEmpty)

              const Expanded(
                  flex: 6,
                  child: Center(child: CircularProgressIndicator.adaptive())),
              Gap(80.h)
            ]
          ],
        ),
      ),
    );
  }
}
