import '/repositories/api_repository/api.dart';
import '../../../_libraries/http_services/http_services.dart';

class ExampleApi extends Api {
  const ExampleApi(super.repository);

  Future<String?> call() async {
    var res = await raw();
    return properResponse<String>(
      res,
      statusCode: {200},
      parser: (json) => json['example'],
    );
  }

  Future<HttpResponse> raw() async {
    return http.get(createRequest(url('endpoint')));
  }
}
