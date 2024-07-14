import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/http_services/http_services.dart';
import '../models/coordinates.dart';
import '../models/google_address.dart';

enum LocationFilterType { bias, restrict }

class LocationFilter {
  const LocationFilter({
    required this.center,
    required this.radius,
    required this.type,
  });

  final Coordinates center;
  final double radius;
  final LocationFilterType type;
}

class GooglePlacesAutoCompleteApi extends BaseApi {
  const GooglePlacesAutoCompleteApi(super.repository);

  Future<List<GooglePlace>?> call(
    String query,
    String apiKey, {
    LocationFilter? filter,
  }) async {
    var res = await raw(query, apiKey, filter);
    return properResponse<List<GooglePlace>>(
      res,
      statusCode: {200},
      parser: (json) => parseList(json['places'], GooglePlace.fromMap),
    );
  }

  Future<HttpResponse> raw(
    String query,
    String apiKey,
    LocationFilter? filter,
  ) async {
    return await http.post(
      createRawRequest(
        'https://places.googleapis.com/v1/places:autocomplete',
        headers: {"X-Goog-Api-Key": apiKey},
        body: {
          "input": query,
          if (filter != null)
            switch (filter.type) {
              LocationFilterType.bias => "locationBias",
              LocationFilterType.restrict => "locationRestriction",
            }: {
              "circle": {
                "center": {
                  "latitude": filter.center.latitude,
                  "longitude": filter.center.longitude,
                },
                "radius": filter.radius,
              }
            },
        },
      ),
    );
  }
}
