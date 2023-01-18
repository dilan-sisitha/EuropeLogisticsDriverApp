import 'dart:io';

import 'package:dio/dio.dart';
import 'package:euex/providers/signUpDataProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/driverService.dart';

class Driver {
  Driver(
      this.firstName,
      this.lastName,
      this.userName,
      this.email,
      this.password,
      this.companyName,
      this.companyAddress,
      this.contactNo,
      this.vanType,
      this.vanMake,
      this.vanRegistration,
      this.driverPhoto,
      this.vanPhoto,
      this.vanColour,
      this.carrierName,
      this.carrierEmail,
      this.carrierPhone,
      this.bankAccount,
      this.swiftCode);

  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? password;
  final String? companyName;
  final String? companyAddress;
  final String? contactNo;
  final String? vanType;
  final String? vanMake;
  final String? vanRegistration;
  final String? vanColour;
  final String? carrierName;
  final String? carrierEmail;
  final String? carrierPhone;
  final String? bankAccount;
  final String? swiftCode;
  final File? driverPhoto;
  final File? vanPhoto;

  Future<FormData> getFormData({bool update = false}) async {
    var list = {
      'reg_no': vanRegistration,
      'driver_name': firstName! + " " + lastName!,
      'driver_user_name': userName,
      'email': email,
      'phone': contactNo,
      'address': companyAddress,
      'van_type_id': vanType,
      'password': password,
      'driver_company': companyName,
      'van_make': vanMake,
      'carrier_name': carrierName,
      'carrier_email': carrierEmail,
      'carrier_phone': carrierPhone,
      'bank_account': bankAccount,
      'swift_code': swiftCode,
      'van_color': vanColour,
      'photo': driverPhoto != null
          ? await MultipartFile.fromFile(driverPhoto!.path, filename: 'test')
          : null,
      'van_photo': vanPhoto != null
          ? await MultipartFile.fromFile(vanPhoto!.path, filename: 'test2')
          : null
    };
    if (update) {
      list['driver_id'] = DriverService().driverId;
    }

    var formData = FormData.fromMap(list);
    return formData;
  }

  static showValidationErrors(errors, context) {
    Map<String, dynamic> validationErrors = errors;
    validationErrors.forEach((key, value) {
      List errMsg = value;
      if (key == 'driver_user_name') {
        errMsg.forEach((element) {
          if (element.toString().contains('already been taken')) {
            Provider.of<SignUpDataProvider>(context, listen: false)
                    .userNameErrText =
                AppLocalizations.of(context)!.uniqueUserNameError;
          }
        });
      }
      if (key == 'reg_no') {
        errMsg.forEach((element) {
          if (element.toString().contains('already taken')) {
            Provider.of<SignUpDataProvider>(context, listen: false)
                    .vanRegistrationErrText =
                AppLocalizations.of(context)!.uniqueUserNameError;
          }
        });
      }
      if (key == 'driver_name') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .lastNameErrText = value.join(', ');
      }
      if (key == 'email') {
        Provider.of<SignUpDataProvider>(context, listen: false).emailErrText =
            value.join(', ');
      }
      if (key == 'phone') {
        errMsg.forEach((element) {
          if (element.toString().contains('invalid')) {
            Provider.of<SignUpDataProvider>(context, listen: false)
                    .contactNoErrText =
                AppLocalizations.of(context)!.invalidPhoneNumber;
          }
        });
      }
      if (key == 'address') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .companyAddressErrText = value.join(', ');
      }
      if (key == 'van_type_id') {
        Provider.of<SignUpDataProvider>(context, listen: false).vanTypeErrText =
            value.join(', ');
      }
      if (key == 'password') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .passwordErrText = value.join(', ');
      }
      if (key == 'driver_vat_no') {
        Provider.of<SignUpDataProvider>(context, listen: false).vatNoErrText =
            value.join(', ');
      }
      if (key == 'driver_company') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .companyNameErrText = value.join(', ');
      }
      if (key == 'van_make') {
        Provider.of<SignUpDataProvider>(context, listen: false).vanMakeErrText =
            value.join(', ');
      }
      if (key == 'carrier_name') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .carrierNameErrText = value.join(', ');
      }
      if (key == 'carrier_email') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .carrierEmailErrText = value.join(', ');
      }
      if (key == 'carrier_phone') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .carrierPhoneErrText = value.join(', ');
      }
      if (key == 'carrier_email') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .carrierEmailErrText = value.join(', ');
      }
      if (key == 'bank_account') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .bankAccountErrText = value.join(', ');
      }
      if (key == 'swift_code') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .swiftCodeErrText = value.join(', ');
      }
      if (key == 'van_color') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .carrierEmailErrText = value.join(', ');
      }
      if (key == 'vat_rate') {
        Provider.of<SignUpDataProvider>(context, listen: false).vatRateErrText =
            value.join(', ');
      }
      if (key == 'photo') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .driverImageErrText = value.join(', ');
      }
      if (key == 'van_photo') {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .vanImageErrText = value.join(', ');
      }
    });
  }

  static hideValidationErrors(context) {
    Provider.of<SignUpDataProvider>(context, listen: false).userNameErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false)
        .vanRegistrationErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false).firstNameErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).lastNameErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).emailErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false).contactNoErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false)
        .companyAddressErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false).vanTypeErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).passwordErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).vatNoErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false).companyNameErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).vanMakeErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).carrierNameErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false)
        .carrierEmailErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false)
        .carrierPhoneErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false)
        .carrierEmailErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false).bankAccountErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).swiftCodeErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false)
        .carrierEmailErrText = null;
    Provider.of<SignUpDataProvider>(context, listen: false).vatRateErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).driverImageErrText =
        null;
    Provider.of<SignUpDataProvider>(context, listen: false).vanImageErrText =
        null;
  }
}
