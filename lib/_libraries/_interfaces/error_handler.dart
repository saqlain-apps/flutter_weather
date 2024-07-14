abstract class ErrorHandler {
  const ErrorHandler();

  dynamic handle();
  void showError({required String message, String? body});
}
