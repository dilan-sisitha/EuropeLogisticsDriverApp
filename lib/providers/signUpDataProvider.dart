import 'package:flutter/material.dart';

class SignUpDataProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isValid = true;
  bool _invalidUserName = false;
  bool _invalidEmail = false;
  bool _invalidRegNo = false;
  dynamic _firstNameErrText;
  dynamic _lastNameErrText;
  dynamic _userNameErrText;
  dynamic _passwordErrText;
  dynamic _emailErrText;
  dynamic _companyNameErrText;
  dynamic _companyAddressErrText;
  dynamic _contactNoErrText;
  dynamic _vatNoErrText;
  dynamic _vanMakeErrText;
  dynamic _vanRegistrationErrText;
  dynamic _carrierNameErrText;
  dynamic _carrierEmailErrText;
  dynamic _carrierPhoneErrText;
  dynamic _bankAccountErrText;
  dynamic _swiftCodeErrText;
  dynamic _vanColourErrText;
  dynamic _vatRateErrText;
  dynamic _vanImageErrText;
  dynamic _driverImageErrText;
  dynamic _vanTypeErrText;

  bool get invalidEmail => _invalidEmail;

  set invalidEmail(bool value) {
    _invalidEmail = value;
    notifyListeners();
  }

  bool get invalidUserName => _invalidUserName;

  set invalidUserName(bool value) {
    _invalidUserName = value;
    notifyListeners();
  }

  bool get isValid => _isValid;

  set isValid(bool value) {
    _isValid = value;
    notifyListeners();
  }

  set setIsValid(bool isValid) {
    _isValid = isValid;
    notifyListeners();
  }

  dynamic get firstNameErrText => _firstNameErrText;

  set firstNameErrText(dynamic value) {
    _firstNameErrText = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  dynamic get lastNameErrText => _lastNameErrText;

  set lastNameErrText(dynamic value) {
    _lastNameErrText = value;
    notifyListeners();
  }

  dynamic get userNameErrText => _userNameErrText;

  set userNameErrText(dynamic value) {
    _userNameErrText = value;
    notifyListeners();
  }

  dynamic get passwordErrText => _passwordErrText;

  set passwordErrText(dynamic value) {
    _passwordErrText = value;
    notifyListeners();
  }

  dynamic get emailErrText => _emailErrText;

  set emailErrText(dynamic value) {
    _emailErrText = value;
    notifyListeners();
  }

  dynamic get companyNameErrText => _companyNameErrText;

  set companyNameErrText(dynamic value) {
    _companyNameErrText = value;
    notifyListeners();
  }

  dynamic get companyAddressErrText => _companyAddressErrText;

  set companyAddressErrText(dynamic value) {
    _companyAddressErrText = value;
    notifyListeners();
  }

  dynamic get contactNoErrText => _contactNoErrText;

  set contactNoErrText(dynamic value) {
    _contactNoErrText = value;
    notifyListeners();
  }

  dynamic get vatNoErrText => _vatNoErrText;

  set vatNoErrText(dynamic value) {
    _vatNoErrText = value;
    notifyListeners();
  }

  dynamic get vanMakeErrText => _vanMakeErrText;

  set vanMakeErrText(dynamic value) {
    _vanMakeErrText = value;
    notifyListeners();
  }

  dynamic get vanRegistrationErrText => _vanRegistrationErrText;

  set vanRegistrationErrText(dynamic value) {
    _vanRegistrationErrText = value;
    notifyListeners();
  }

  dynamic get carrierNameErrText => _carrierNameErrText;

  set carrierNameErrText(dynamic value) {
    _carrierNameErrText = value;
    notifyListeners();
  }

  dynamic get carrierEmailErrText => _carrierEmailErrText;

  set carrierEmailErrText(dynamic value) {
    _carrierEmailErrText = value;
    notifyListeners();
  }

  dynamic get carrierPhoneErrText => _carrierPhoneErrText;

  set carrierPhoneErrText(dynamic value) {
    _carrierPhoneErrText = value;
    notifyListeners();
  }

  dynamic get bankAccountErrText => _bankAccountErrText;

  set bankAccountErrText(dynamic value) {
    _bankAccountErrText = value;
    notifyListeners();
  }

  dynamic get swiftCodeErrText => _swiftCodeErrText;

  set swiftCodeErrText(dynamic value) {
    _swiftCodeErrText = value;
    notifyListeners();
  }

  dynamic get vanColourErrText => _vanColourErrText;

  set vanColourErrText(dynamic value) {
    _vanColourErrText = value;
    notifyListeners();
  }

  dynamic get vatRateErrText => _vatRateErrText;

  set vatRateErrText(dynamic value) {
    _vatRateErrText = value;
    notifyListeners();
  }

  dynamic get vanImageErrText => _vanImageErrText;

  set vanImageErrText(dynamic value) {
    _vanImageErrText = value;
    notifyListeners();
  }

  dynamic get driverImageErrText => _driverImageErrText;

  set driverImageErrText(dynamic value) {
    _driverImageErrText = value;
    notifyListeners();
  }

  dynamic get vanTypeErrText => _vanTypeErrText;

  set vanTypeErrText(dynamic value) {
    _vanTypeErrText = value;
    notifyListeners();
  }

  bool get invalidRegNo => _invalidRegNo;

  set invalidRegNo(bool value) {
    _invalidRegNo = value;
    notifyListeners();
  }
}
