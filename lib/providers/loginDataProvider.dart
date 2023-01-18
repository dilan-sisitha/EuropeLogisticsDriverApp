import 'package:flutter/material.dart';

class LoginDataProvider extends ChangeNotifier {
  dynamic _unameError, _pwdError;
  bool _isLoading = false;
  bool _isHidden = true;
  bool _isDisabledUser = false;

  bool get isDisabledUser => _isDisabledUser;

  set isDisabledUser(bool value) {
    _isDisabledUser = value;
    notifyListeners();
  }

  dynamic get unameError => _unameError;

  dynamic get pwdError => _pwdError;

  bool get isLoading => _isLoading;

  bool get isHidden => _isHidden;

  set setUnameError(error) {
    _unameError = error;
    notifyListeners();
  }

  set setPwdError(error) {
    _pwdError = error;
    notifyListeners();
  }

  set setIsHidden(bool isHidden) {
    _isHidden = isHidden;
    notifyListeners();
  }

  set setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
