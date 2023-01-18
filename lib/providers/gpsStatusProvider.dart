import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsStatusProvider extends ChangeNotifier {
  bool _gpsIsEnabled = true;
  bool _previousGpsState = true;

  bool get gpsIsEnabled => _gpsIsEnabled;

  bool get previousGpsState => _previousGpsState;

  set gpsIsEnabled(bool gpsIsEnabled) {
    _gpsIsEnabled = gpsIsEnabled;
    notifyListeners();
  }

  GpsStatusProvider() {
    checkGps();
  }

  checkGps() async {
    Timer.periodic(const Duration(seconds: 4), (timer) async {
      await _tryGps();
    });
  }

  Future<void> _tryGps() async {
    try {
      _previousGpsState = _gpsIsEnabled;
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (isLocationEnabled) {
        _gpsIsEnabled = true;
      } else {
        _gpsIsEnabled = false;
      }
    } on SocketException catch (e) {
      _gpsIsEnabled = false;
    }
    notifyListeners();
  }
}
