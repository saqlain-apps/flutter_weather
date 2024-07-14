part of 'task_handler.dart';

class TimedTaskHandler extends TaskHandler {
  final int milliseconds;
  TimedTaskHandler(this.milliseconds) : super._();

  Timer? _timer;
  Completer? _completer;

  void _end([dynamic result]) {
    if (_completer?.isCompleted == false) {
      _completer?.complete(result);
    }
  }

  @override
  void reset() {
    _timer?.cancel();
    _timer = null;

    _end(null);
    _completer = null;
  }

  void run<T>(FutureOr<T> Function() task) {
    if (_timer != null || _completer != null) reset();

    _completer = Completer<T>();
    _timer = Timer(
      Duration(milliseconds: milliseconds),
      () => _complete<T>(task),
    );
  }

  void _complete<T>(FutureOr<T> Function() task) async {
    var result = await task();
    _end(result);
  }

  @override
  Future<void> handle(FutureOr<void> Function() task) async {
    run<void>(task);
    if (_completer != null) {
      await _completer?.future;
    }
  }

  @override
  Future<T?> handleReturn<T>(FutureOr<T> Function() task) async {
    run<T>(task);
    var result = _completer != null ? await _completer?.future : null;

    return result is T ? result : null;
  }
}
