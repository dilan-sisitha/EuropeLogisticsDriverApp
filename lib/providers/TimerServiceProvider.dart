import 'dart:async';

import 'package:flutter/material.dart';

class TimerDataProvider extends ChangeNotifier {
  Stopwatch? _watch;
  Timer? _timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;
  String elapsedTime = '00:00:00';
  Duration _initialOffset = Duration.zero;

  set initialOffset(Duration value) {
    _initialOffset = value;
  }

  bool get isRunning => _timer != null;

  TimerDataProvider() {
    _watch = Stopwatch();
  }

  void _onTick(Timer timer) {
    _currentDuration = _watch!.elapsed + _initialOffset;
    elapsedTime = _printDuration(currentDuration);

    // notify all listening widgets
    notifyListeners();
  }

  void start() {
    if (_timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
      _watch!.start();

      notifyListeners();
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _watch!.stop();
    _currentDuration = _watch!.elapsed;
    notifyListeners();
  }

  void reset() {
    stop();
    _watch!.reset();
    _currentDuration = Duration.zero;
    _initialOffset = Duration.zero;
    elapsedTime = _printDuration(currentDuration);
    notifyListeners();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
