import 'package:flutter/material.dart';

class PasswordResetProvider extends ChangeNotifier {
  bool _isLoadingVerificationButton = false;
  bool _firstDigitError = false;
  bool _secondDigitError = false;
  bool _fourthDigitError = false;
  bool _fifthDigitError = false;
  bool _thirdDigitError = false;
  bool _sixthDigitError = false;
  bool _isOTPError = false;
  String? _otpErrorText;
  String? _newPwdErrorText;
  String? _confirmPwdErrorText;
  bool _isLoadingResetBtn = false;
  bool _isLoadingResendCode = false;

  bool get isLoadingResendCode => _isLoadingResendCode;

  set isLoadingResendCode(bool value) {
    _isLoadingResendCode = value;
    notifyListeners();
  }

  bool get isLoadingResetBtn => _isLoadingResetBtn;

  set isLoadingResetBtn(bool value) {
    _isLoadingResetBtn = value;
    notifyListeners();
  }

  String? get newPwdErrorText => _newPwdErrorText;

  set newPwdErrorText(String? value) {
    _newPwdErrorText = value;
    notifyListeners();
  }

  String? get otpErrorText => _otpErrorText;

  set otpErrorText(String? value) {
    _otpErrorText = value;
    notifyListeners();
  }

  bool get isOTPError => _isOTPError;

  set isOTPError(bool value) {
    _isOTPError = value;
    notifyListeners();
  }

  bool get firstDigitError => _firstDigitError;

  set firstDigitError(bool value) {
    _firstDigitError = value;
  }

  dynamic _verificationContactErrorText;

  dynamic get verificationContactErrorText => _verificationContactErrorText;

  set verificationContactErrorText(dynamic value) {
    _verificationContactErrorText = value;
    notifyListeners();
  }

  bool get isLoadingVerificationButton => _isLoadingVerificationButton;

  set isLoadingVerificationButton(bool value) {
    _isLoadingVerificationButton = value;
    notifyListeners();
  }

  bool get secondDigitError => _secondDigitError;

  set secondDigitError(bool value) {
    _secondDigitError = value;
    notifyListeners();
  }

  bool get fourthDigitError => _fourthDigitError;

  set fourthDigitError(bool value) {
    _fourthDigitError = value;
    notifyListeners();
  }

  bool get fifthDigitError => _fifthDigitError;

  set fifthDigitError(bool value) {
    _fifthDigitError = value;
    notifyListeners();
  }

  bool get thirdDigitError => _thirdDigitError;

  set thirdDigitError(bool value) {
    _thirdDigitError = value;
    notifyListeners();
  }

  bool get sixthDigitError => _sixthDigitError;

  set sixthDigitError(bool value) {
    _sixthDigitError = value;
  }

  String? get confirmPwdErrorText => _confirmPwdErrorText;

  set confirmPwdErrorText(String? value) {
    _confirmPwdErrorText = value;
    notifyListeners();
  }

  void reset() {
    _isLoadingVerificationButton = false;
    _firstDigitError = false;
    _secondDigitError = false;
    _fourthDigitError = false;
    _fifthDigitError = false;
    _thirdDigitError = false;
    _sixthDigitError = false;
    _isOTPError = false;
    _otpErrorText = null;
    _newPwdErrorText = null;
    _confirmPwdErrorText = null;
    _isLoadingResetBtn = false;
    _isLoadingResendCode = false;
    notifyListeners();
  }
}
