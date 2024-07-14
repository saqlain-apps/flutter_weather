import '/repositories/api_repository/apis/example.dart';
import '../../_libraries/base_api_repository/base_api_repository.dart';

class ApiRepository extends BaseApiRepository {
  ApiRepository(super.httpService);
  //----------------------------------------------------------------------------

  late final ExampleApi example = ExampleApi(this);
}
