import 'dart:async';

class InputDelayModel {
  static final Map<String, InputDelayModel> _map = {};
  static InputDelayModel getModel(String key) {
    if (_map.containsKey(key)) {
      return _map[key]!;
    }

    _map[key] = InputDelayModel._instance();
    return _map[key]!;
  }

  /// Constructor is set private
  InputDelayModel._instance();

  static void delete(String key) {
    _map.remove(key);
  }

  InputDelayTimer _timer = InputDelayTimer();

  //  Getters, setters
  InputDelayTimer get timer => _timer;

  void start({
    required Future Function(InputDelayTimer myTimer) cb,
    int duration = 500,
  }) {
    /// Here, every call to start cancels the previous operation.
    if (_timer._status == InputDelayStatus.timerStarted ||
        _timer.status == InputDelayStatus.operating) {
      _timer.cancel();
    }

    _timer = InputDelayTimer();
    _timer._start(
      cb: cb,
      duration: duration,
    );
  }
}

class InputDelayTimer {
  late final Timer _timer;
  InputDelayStatus _status = InputDelayStatus.init;

  //  Getters, setters
  InputDelayStatus get status => _status;

  Timer? get timer => _timer;

  void _start({
    required Future Function(InputDelayTimer myTimer) cb,
    int duration = 500,
  }) {
    _status = InputDelayStatus.timerStarted;
    _timer = Timer(
      Duration(milliseconds: duration),
      () async {
        _status = InputDelayStatus.operating;
        await cb(this);
        if (_status != InputDelayStatus.canceled) {
          _status = InputDelayStatus.completed;
        }
      },
    );
  }

  void cancel() {
    _timer.cancel();
    _status = InputDelayStatus.canceled;
  }
}

enum InputDelayStatus {
  init,
  timerStarted,
  operating,
  completed,
  canceled,
}
