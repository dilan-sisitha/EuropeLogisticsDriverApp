import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class NetworkConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _previousState = true;

  bool get isOnline => _isOnline;

  bool get previousState => _previousState;

  set isOnline(bool isOnline) {
    _isOnline = isOnline;
    notifyListeners();
  }

  NetworkConnectivityProvider() {
    checkConnection();
  }

  checkConnection() async {
    Timer.periodic(const Duration(seconds: 4), (timer) async {
      await tryConnection();
    });
  }

  Future<bool> tryConnection() async {
    try {
      _previousState = _isOnline;
      final response = await InternetAddress.lookup('www.google.com')
          .timeout(const Duration(seconds: 3));
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        _isOnline = true;
      } else {
        _isOnline = false;
      }
    } on SocketException catch (e) {
      _isOnline = false;
    }
    notifyListeners();
    return _isOnline;
  }
}
