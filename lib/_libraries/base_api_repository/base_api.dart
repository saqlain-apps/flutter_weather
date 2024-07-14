import 'dart:io';

import '../../repositories/api_repository/api_exception_handler.dart';
import '../http_services/http_services.dart';
import 'base_api_repository.dart';

abstract class BaseApi<T extends BaseApiRepository> {
  const BaseApi(this.repository);
  final T repository;

  HttpServices get http => repository.httpService;

  errorHandler(HttpError error) => ApiExceptionHandler(error).handle();

  Q? properResponse<Q>(
    HttpResponse response, {
    required Set<int> statusCode,
    required Q Function(ApiMap json) parser,
  }) {
    try {
      var res = response.properResponse<Q>(
        statusCode,
        (json) => parser(repository.outputInterceptor(json)),
      );
      return res;
    } on HttpError catch (e) {
      errorHandler(e);
      return null;
    }
  }

  List<Q> parseList<Q>(
    Map<String, dynamic> json,
    Q Function(Map<String, dynamic> map) parser,
  ) {
    return (json as List)
        .cast<Map<String, dynamic>>()
        .map((e) => parser(e))
        .toList();
  }

  HttpRequest createRawRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    String? authorization,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    ContentType? contentType,
    ContentType? acceptType,
  }) {
    return HttpRequest(
      endpoint: endpoint,
      body: body != null ? repository.inputInterceptor(body) : null,
      authorization: authorization,
      headers: headers,
      queryParams: queryParams,
      contentType: contentType,
      acceptType: acceptType,
    );
  }
}
