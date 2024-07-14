import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/http_services/http_services.dart';
import '../models/google_address.dart';

class GooglePlacesSearchApi extends BaseApi {
  const GooglePlacesSearchApi(super.repository);

  Future<List<GooglePlace>?> call(String query, String apiKey) async {
    var res = await raw(query, apiKey);
    return properResponse<List<GooglePlace>>(
      res,
      statusCode: {200},
      parser: (json) => parseList(json['places'], GooglePlace.fromMap),
    );
  }

  Future<HttpResponse> raw(String query, String apiKey) async {
    return await http.post(
      createRawRequest(
        'https://places.googleapis.com/v1/places:searchText',
        headers: {"X-Goog-Api-Key": apiKey},
        body: {
          "textQuery": query,
          "X-Goog-FieldMask": [
            "places.id",
            "places.displayName",
            "places.formattedAddress",
            "places.shortFormattedAddress",
            "places.addressComponents",
            "places.location",
            "places.googleMapsUri",
          ].join(","),
        },
      ),
    );
  }
}
