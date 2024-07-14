import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/http_services/http_services.dart';
import '/utils/app_helpers/_app_helper_import.dart';
import 'api_error_handler.dart';
import 'api_repository.dart';

abstract class Api extends BaseApi<ApiRepository> {
  const Api(super.repository);

  @override
  errorHandler(HttpError error) {
    var unhandledError = super.errorHandler(error);
    if (unhandledError == null) return;
    return ApiErrorHandler(unhandledError).handle();
  }

  HttpRequest createRequest(
    String endpoint, {
    String? token,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) {
    1;
    return createRawRequest(
      endpoint,
      body: body,
      authorization: isNotBlank(token) ? _buildAuthorization(token!) : null,
      headers: _buildHeaders(additionalHeaders: headers ?? {}),
      queryParams: queryParams,
    );
  }

  Map<String, String> _buildHeaders({
    Map<String, String> additionalHeaders = const {},
  }) {
    var headers = <String, String>{
      'platform': platform,
      'accept-language': languageCode,
    };
    headers.addAll(additionalHeaders);
    return headers;
  }

  String _buildAuthorization(String token) {
    return 'Bearer $token';
  }

  String url(String endpoint) => baseUrl + endpoint;
  String get baseUrl => '';

  String get languageCode =>
      Intl.getCurrentLocale().substring(0, 2).toLowerCase();
  String get platform {
    var platform = switch (defaultTargetPlatform) {
      TargetPlatform.android => 1,
      TargetPlatform.iOS => 2,
      _ => 3
    };
    return platform.toString();
  }

  String get deviceId => "1234";
  String get deviceToken => "12345";
}
