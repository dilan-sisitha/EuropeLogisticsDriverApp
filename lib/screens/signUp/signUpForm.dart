import 'dart:io';

import 'package:euex/api/api.dart';
import 'package:euex/components/customAlertDialog.dart';
import 'package:euex/components/customImagePicker.dart';
import 'package:euex/components/dropDownButton.dart';
import 'package:euex/components/textFieldWidget.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/driver.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/providers/signUpDataProvider.dart';
import 'package:euex/screens/login/login.dart';
import 'package:euex/services/signUpService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm(
      {Key? key,
      required this.firstNameController,
      required this.lastNameController,
      required this.userNameController,
      required this.passwordController,
      required this.emailController,
      required this.companyNameController,
      required this.companyAddressController,
      required this.contactNoController,
      required this.vatNoController,
      required this.vanMakeController,
      required this.vanRegistrationController,
      required this.carrierNameController,
      required this.carrierEmailController,
      required this.bankAccountController,
      required this.swiftCodeController,
      required this.vanColourController,
      required this.carrierPhoneController,
      required this.formKey,
      this.vanImage,
      this.driverImage,
      this.vanType,
      required this.focusNode})
      : super(key: key);

  final GlobalKey<FormState> formKey;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController companyNameController;
  final TextEditingController companyAddressController;
  final TextEditingController contactNoController;
  final TextEditingController vatNoController;
  final TextEditingController vanMakeController;
  final TextEditingController vanRegistrationController;
  final TextEditingController carrierNameController;
  final TextEditingController carrierEmailController;
  final TextEditingController carrierPhoneController;
  final TextEditingController bankAccountController;
  final TextEditingController swiftCodeController;
  final TextEditingController vanColourController;

  File? vanImage;
  File? driverImage;

  String? vanType;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    bool _checkImageField() {
      bool val = true;
      if (vanImage == null) {
        val = false;
        Provider.of<SignUpDataProvider>(context, listen: false)
                .vanImageErrText =
            AppLocalizations.of(context)!.thisFieldIsRequired;
      } else {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .vanImageErrText = null;
      }
      if (driverImage == null) {
        val = false;
        Provider.of<SignUpDataProvider>(context, listen: false)
                .driverImageErrText =
            AppLocalizations.of(context)!.thisFieldIsRequired;
      } else {
        Provider.of<SignUpDataProvider>(context, listen: false)
            .driverImageErrText = null;
      }
      return val;
    }

    validateForm() {
      bool isValidForm = formKey.currentState!.validate();
      bool isValidImages = _checkImageField();

      return isValidForm && isValidImages;
    }

    return Form(
        key: formKey,
        child: Consumer<SignUpDataProvider>(builder: (context, value, child) {
          return Column(
            children: [
              TextFieldWidget(
                maxLength: 40,
                hText: AppLocalizations.of(context)!.firstName,
                icon: const Icon(Icons.person),
                controller: firstNameController,
                errorText: value.firstNameErrText,
              ),
              TextFieldWidget(
                  maxLength: 40,
                  hText: AppLocalizations.of(context)!.lastName,
                  icon: const Icon(Icons.person),
                  controller: lastNameController,
                  errorText: value.lastNameErrText),
              TextFieldWidget(
                maxLength: 40,
                hText: AppLocalizations.of(context)!.userName,
                icon: const Icon(Icons.accessibility_sharp),
                controller: userNameController,
                errorText: value.userNameErrText,
                validateOnChange: true,
                onFocusChange: () {
                  SignUpService().validateField(userNameController.text,
                      'user_name', Api().userNameValidateUrl, context);
                },
                onValueChange: () {
                  value.invalidUserName = false;
                  value.isValid = true;
                  value.userNameErrText = null;
                },
              ),
              EmailTextWidget(
                  maxLength: 320,
                  ehText: AppLocalizations.of(context)!.email,
                  errorText: value.emailErrText,
                  eicon: const Icon(Icons.email),
                  emailValidmsg:
                      AppLocalizations.of(context)!.enterAValidEmailAddress,
                  controller: emailController,
                  onValueChange: () {
                    value.invalidEmail = false;
                    value.isValid = true;
                    value.emailErrText = null;
                  },
                  onFocusChange: () {
                    SignUpService().validateField(emailController.text, 'email',
                        Api().emailValidateUrl, context);
                  }),
              passwordTextFeild(
                controller: passwordController,
                errorText: value.passwordErrText,
              ),
              TextFieldWidget(
                maxLength: 90,
                hText: AppLocalizations.of(context)!.company,
                icon: const Icon(Icons.business),
                controller: companyNameController,
                errorText: value.companyNameErrText,
              ),
              TextFieldWidget(
                maxLength: 250,
                hText: AppLocalizations.of(context)!.companyAddress,
                icon: const Icon(Icons.location_on),
                controller: companyAddressController,
                errorText: value.companyAddressErrText,
              ),
              TelNoField(
                hText: AppLocalizations.of(context)!.contactNo,
                emptyMsg: AppLocalizations.of(context)!.thisFieldIsRequired,
                icon: const Icon(Icons.phone),
                controller: contactNoController,
                errorText: value.contactNoErrText,
                invalidTelMsg: AppLocalizations.of(context)!.invalidPhoneNumber,
              ),
              TextFieldWidget(
                maxLength: 20,
                hText: AppLocalizations.of(context)!.vatNo,
                icon: const Icon(Icons.document_scanner),
                controller: vatNoController,
                isRequired: false,
                errorText: value.vatNoErrText,
              ),
              TextFieldWidget(
                maxLength: 20,
                hText: AppLocalizations.of(context)!.vanMake,
                icon: const Icon(Icons.settings),
                controller: vanMakeController,
                errorText: value.vanMakeErrText,
              ),
              CustomDropDownButton(
                ehText: AppLocalizations.of(context)!.vanType,
                eicon: const Icon(Icons.airport_shuttle_outlined),
                getVanType: (vanType) {
                  this.vanType = vanType;
                },
                errorText: value.vanTypeErrText,
              ),
              TextFieldWidget(
                maxLength: 25,
                hText: AppLocalizations.of(context)!.vanRegistration,
                icon: const Icon(Icons.password),
                controller: vanRegistrationController,
                errorText: value.vanRegistrationErrText,
                validateOnChange: true,
                onFocusChange: () {
                  SignUpService().validateField(vanRegistrationController.text,
                      'reg_no', Api().regNoValidateUrl, context);
                },
                onValueChange: () {
                  value.invalidRegNo = false;
                  value.vanRegistrationErrText = null;
                },
              ),
              TextFieldWidget(
                maxLength: 20,
                hText: AppLocalizations.of(context)!.vanColour,
                icon: const Icon(Icons.add_box_sharp),
                controller: vanColourController,
                isRequired: false,
                errorText: value.vanColourErrText,
              ),
              TextFieldWidget(
                maxLength: 80,
                hText: AppLocalizations.of(context)!.carrierName,
                icon: const Icon(Icons.account_balance_sharp),
                controller: carrierNameController,
                isRequired: false,
                errorText: value.carrierNameErrText,
              ),
              TextFieldWidget(
                maxLength: 320,
                hText: AppLocalizations.of(context)!.carrierEmail,
                icon: const Icon(Icons.email),
                controller: carrierEmailController,
                isRequired: false,
                errorText: value.carrierEmailErrText,
                onValueChange: () {
                  Future.delayed(Duration.zero, () {
                    value.carrierEmailErrText = null;
                  });
                },
              ),
              TelNoField(
                hText: AppLocalizations.of(context)!.carrierPhone,
                invalidTelMsg: AppLocalizations.of(context)!.invalidPhoneNumber,
                emptyMsg: AppLocalizations.of(context)!.thisFieldIsRequired,
                icon: const Icon(Icons.phone_android_outlined),
                controller: carrierPhoneController,
                errorText: value.carrierPhoneErrText,
              ),
              TextFieldWidget(
                maxLength: 34,
                hText: AppLocalizations.of(context)!.bankAccount,
                icon: const Icon(Icons.account_balance_wallet),
                controller: bankAccountController,
                isRequired: false,
                errorText: value.bankAccountErrText,
              ),
              TextFieldWidget(
                maxLength: 11,
                hText: AppLocalizations.of(context)!.swiftCode,
                icon: const Icon(Icons.add_comment),
                controller: swiftCodeController,
                isRequired: false,
                errorText: value.swiftCodeErrText,
              ),
              CustomImagePicker(
                hintText: AppLocalizations.of(context)!.yourImage,
                imageError: value.driverImageErrText,
                getImage: (file) {
                  if (file != null) {
                    Future.delayed(Duration.zero, () {
                      value.isValid = true;
                      value.driverImageErrText = null;
                    });

                    driverImage = file;
                  } else {
                    driverImage = null;
                  }
                },
              ),
              CustomImagePicker(
                hintText: AppLocalizations.of(context)!.vanImage,
                imageError: value.vanImageErrText,
                getImage: (file) {
                  if (file != null) {
                    Future.delayed(Duration.zero, () {
                      value.isValid = true;
                      value.vanImageErrText = null;
                    });

                    vanImage = file;
                  } else {
                    vanImage = null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: value.isLoading ||
                            SignUpService().isFormInvalid(context)
                        ? yPrimarytColorLoading
                        : yPrimarytColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (Provider.of<NetworkConnectivityProvider>(context,
                            listen: false)
                        .isOnline) {
                      if (validateForm() &&
                          !SignUpService().isFormInvalid(context)) {
                        value.isValid = true;
                        Driver.hideValidationErrors(context);
                        formKey.currentState!.save();
                        value.setIsLoading = true;
                        onSignUpPressed(context);
                      } else {
                        value.isValid = false;
                      }
                    } else {
                      _showMyDialog(
                          AppLocalizations.of(context)!.yourDeviceIsOffline,
                          AppLocalizations.of(context)!
                              .pleaseCheckYourInternetConnection,
                          context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: (value.isLoading ||
                            SignUpService().isFormInvalid(context))
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                !SignUpService().isFormInvalid(context)
                                    ? const SizedBox(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        height: 19.0,
                                        width: 19.0,
                                      )
                                    : Container(),
                                const SizedBox(width: 7),
                                Text(
                                    SignUpService().isFormInvalid(context)
                                        ? AppLocalizations.of(context)!.signUp
                                        : AppLocalizations.of(context)!
                                            .signingUp,
                                    style: TextStyle(
                                      color:
                                          SignUpService().isFormInvalid(context)
                                              ? Colors.black54
                                              : Colors.white,
                                      fontFamily: 'openSansB',
                                      fontSize: 18.0,
                                    ))
                              ])
                        : Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.signUp,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'openSansB',
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              Container(
                child: SignUpService().isFormInvalid(context)
                    ? Text(AppLocalizations.of(context)!.validationErrorMsg,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                        ))
                    : Container(),
              ),
            ],
          );
        }));
  }

  void onSignUpPressed(context) async {
    Driver driver = Driver(
        firstNameController.text,
        lastNameController.text,
        userNameController.text,
        emailController.text,
        passwordController.text,
        companyNameController.text,
        companyAddressController.text,
        contactNoController.text,
        vanType,
        vanMakeController.text,
        vanRegistrationController.text,
        driverImage,
        vanImage,
        vanColourController.text,
        carrierNameController.text,
        carrierEmailController.text,
        carrierPhoneController.text,
        bankAccountController.text,
        swiftCodeController.text);

    var data = await driver.getFormData();
    Map response = await Api().signUp(data);
    Provider.of<SignUpDataProvider>(context, listen: false).setIsLoading =
        false;
    String status = response['status'];
    switch (status) {
      case "success":
        {
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        }
        break;

      case "validation_errors":
        {
          Provider.of<SignUpDataProvider>(context, listen: false).isValid =
              false;
          Driver.showValidationErrors(response['errors'], context);
        }
        break;

      case "server_error":
        {
          _showMyDialog(AppLocalizations.of(context)!.somethingWentWrong,
              AppLocalizations.of(context)!.pleaseTryAgain, context);
        }
        break;

      case "app_error":
        {
          _showMyDialog(AppLocalizations.of(context)!.applicationError,
              AppLocalizations.of(context)!.pleaseTryAgain, context);
        }
        break;

      default:
        {
          _showMyDialog(AppLocalizations.of(context)!.somethingWentWrong,
              AppLocalizations.of(context)!.pleaseTryAgain, context);
        }
        break;
    }
  }

  Future<void> _showMyDialog(title, text, context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: title, body: text, btnTxt: AppLocalizations.of(context)!.ok);
      },
    );
  }
}
