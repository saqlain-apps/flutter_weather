import '/models/app_exception.dart';
import '/repositories/app_error_handler.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class ApiErrorHandler extends AppErrorHandler {
  const ApiErrorHandler(this.body);

  final Map<String, dynamic> body;

  @override
  handle() {
    printError(body);

    if (body.containsKey('error_code')) {
      var errorCode = body['error_code'] as int;

      if (errorCode == 0) {
        var validation = (body['errors'] as Map)
            .cast<String, List>()
            .entries
            .map((e) => '${e.key}: ${e.value.first}')
            .join('\n');

        showError(message: body['message'], body: validation);
      } else {
        throw AppException(
          errorCode: errorCode,
          message: body['message'],
          exception: body['exception'],
        );
      }
    } else {
      showError(message: body['message']);
    }
  }
}
