import 'dart:io';

// import 'dart:html';
import 'package:euex/api/api.dart';
import 'package:euex/components/customAlertDialog.dart';
import 'package:euex/components/dropDownButton.dart';
import 'package:euex/components/textFieldWidget.dart';
import 'package:euex/components/updateImageShapeIcon.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/driver.dart';
import 'package:euex/models/driverData.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/providers/signUpDataProvider.dart';
import 'package:euex/screens/home/home.dart';
import 'package:euex/services/driverService.dart';
import 'package:euex/services/signUpService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../services/driverService.dart';

class UpdateTextFeild extends StatelessWidget {
  UpdateTextFeild(
      {Key? key,
      required this.firstNameController,
      required this.lastNameController,
      required this.userNameController,
      required this.passwordController,
      required this.emailController,
      required this.companyNameController,
      required this.companyAddressController,
      required this.contactNoController,
      required this.vanMakeController,
      required this.vanRegistrationController,
      required this.carrierNameController,
      required this.carrierEmailController,
      required this.bankAccountController,
      required this.swiftCodeController,
      required this.vanColourController,
      required this.vatRateController,
      required this.carrierPhoneController,
      required this.updateFormKey,
      this.vanImage,
      this.driverImage,
      this.vanType,
      required this.focusNode})
      : super(key: key);

  final GlobalKey<FormState> updateFormKey;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController companyNameController;
  final TextEditingController companyAddressController;
  final TextEditingController contactNoController;
  final TextEditingController vanMakeController;
  final TextEditingController vanRegistrationController;
  final TextEditingController carrierNameController;
  final TextEditingController carrierEmailController;
  final TextEditingController carrierPhoneController;
  final TextEditingController bankAccountController;
  final TextEditingController swiftCodeController;
  final TextEditingController vanColourController;
  final TextEditingController vatRateController;

  File? vanImage;
  File? driverImage;

  String? vanType;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    validateForm() {
      bool isValidForm = updateFormKey.currentState!.validate();
      return isValidForm;
    }

    var driverDetails = Hive.box('driver_details').toMap();

    return Form(
      key: updateFormKey,
      child: Consumer<SignUpDataProvider>(builder: (context, value, child) {
        return Column(
          children: [
            UpdateImageShapeIcon(
              imgSrc: driverDetails["driverImage"],
              imageError: value.driverImageErrText,
              getImage: (file) {
                if (file != null) {
                  driverImage = file;
                } else {
                  driverImage = null;
                }
              },
            ),
            TextFieldWidget(
              maxLength: 80,
              hText: AppLocalizations.of(context)!.yourName,
              icon: const Icon(Icons.person),
              textFormData: driverDetails["driverName"],
              controller: firstNameController,
              updateData: true,
            ),
            TextFieldWidget(
              maxLength: 40,
              hText: AppLocalizations.of(context)!.userName,
              icon: const Icon(Icons.person),
              textFormData: driverDetails["userName"],
              controller: userNameController,
              updateData: true,
            ),
            EmailTextWidget(
                maxLength: 320,
                ehText: AppLocalizations.of(context)!.email,
                errorText: value.emailErrText,
                eicon: const Icon(Icons.email),
                emailValidmsg:
                    AppLocalizations.of(context)!.enterAValidEmailAddress,
                controller: emailController,
                textFormData: driverDetails["driverEmail"],
                updateData: true,
                onValueChange: () {
                  value.invalidEmail = false;
                  value.isValid = true;
                  value.emailErrText = null;
                },
                onFocusChange: () {
                  SignUpService().validateField(emailController.text, 'email',
                      Api().emailValidateUrl, context);
                }),
            TextFieldWidget(
              maxLength: 90,
              hText: AppLocalizations.of(context)!.company,
              icon: const Icon(Icons.business),
              textFormData: driverDetails["company"],
              controller: companyNameController,
              updateData: true,
            ),
            TextFieldWidget(
              maxLength: 250,
              hText: AppLocalizations.of(context)!.companyAddress,
              icon: const Icon(Icons.location_on),
              textFormData: driverDetails["companyAddress"],
              controller: companyAddressController,
              updateData: true,
            ),
            TelNoField(
              hText: AppLocalizations.of(context)!.contactNo,
              emptyMsg: AppLocalizations.of(context)!.thisFieldIsRequired,
              icon: const Icon(Icons.phone),
              controller: contactNoController,
              errorText: value.contactNoErrText,
              invalidTelMsg: AppLocalizations.of(context)!.invalidPhoneNumber,
              textFormData: driverDetails["contactNo"],
              updateData: true,
            ),
            UpdateImageShapeIcon(
              imgSrc: driverDetails["vanImage"],
              imageError: value.vanImageErrText,
              getImage: (file) {
                if (file != null) {
                  vanImage = file;
                } else {
                  vanImage = null;
                }
              },
            ),
            TextFieldWidget(
              maxLength: 10,
              hText: AppLocalizations.of(context)!.vanMake,
              icon: const Icon(Icons.settings),
              textFormData: driverDetails["vanMake"],
              controller: vanMakeController,
              updateData: true,
            ),
            CustomDropDownButton(
              ehText: AppLocalizations.of(context)!.vanType,
              eicon: const Icon(Icons.airport_shuttle_outlined),
              getVanType: (vanType) {
                this.vanType = vanType;
              },
              errorText: value.vanTypeErrText,
              updateData: true,
              typeId: int.parse(driverDetails["vanType"]),
            ),
            TextFieldWidget(
              maxLength: 10,
              hText: AppLocalizations.of(context)!.vanRegistration,
              icon: const Icon(Icons.password),
              textFormData: driverDetails["vanRegistration"],
              controller: vanRegistrationController,
              updateData: true,
            ),
            TextFieldWidget(
              maxLength: 20,
              hText: AppLocalizations.of(context)!.vanColour,
              icon: const Icon(Icons.add_box_sharp),
              textFormData: driverDetails["vanColor"],
              controller: vanColourController,
              updateData: true,
              isRequired: false,
            ),
            TextFieldWidget(
              maxLength: 80,
              hText: AppLocalizations.of(context)!.carrierName,
              icon: const Icon(Icons.account_balance_sharp),
              textFormData: driverDetails["carrierName"],
              controller: carrierNameController,
              updateData: true,
              isRequired: false,
            ),
            EmailTextWidget(
                maxLength: 320,
                ehText: AppLocalizations.of(context)!.carrierEmail,
                errorText: value.emailErrText,
                eicon: const Icon(Icons.email),
                emailValidmsg:
                    AppLocalizations.of(context)!.enterAValidEmailAddress,
                controller: carrierEmailController,
                textFormData: driverDetails["carrierEmail"],
                updateData: true,
                isRequired: false,
                onValueChange: () {
                  value.invalidEmail = false;
                  value.isValid = true;
                  value.emailErrText = null;
                },
                onFocusChange: () {
                  SignUpService().validateField(carrierEmailController.text,
                      'email', Api().emailValidateUrl, context);
                }),
            TelNoField(
              hText: AppLocalizations.of(context)!.carrierPhone,
              emptyMsg: AppLocalizations.of(context)!.thisFieldIsRequired,
              icon: const Icon(Icons.phone),
              controller: carrierPhoneController,
              errorText: value.contactNoErrText,
              invalidTelMsg: AppLocalizations.of(context)!.invalidPhoneNumber,
              textFormData: driverDetails["carrierPhone"],
              updateData: true,
            ),
            TextFieldWidget(
              maxLength: 34,
              hText: AppLocalizations.of(context)!.bankAccount,
              icon: const Icon(Icons.account_balance_wallet),
              textFormData: driverDetails["bankAccount"],
              controller: bankAccountController,
              updateData: true,
              isRequired: false,
            ),
            TextFieldWidget(
              maxLength: 11,
              hText: AppLocalizations.of(context)!.swiftCode,
              icon: const Icon(Icons.add_comment),
              textFormData: driverDetails["swiftCode"],
              controller: swiftCodeController,
              updateData: true,
              isRequired: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary:
                      value.isLoading || SignUpService().isFormInvalid(context)
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
                    if (validateForm()) {
                      value.isValid = true;
                      Driver.hideValidationErrors(context);
                      updateFormKey.currentState!.save();
                      value.setIsLoading = true;
                      onUpdatePressed(context);
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
                                      ? AppLocalizations.of(context)!.update
                                      : AppLocalizations.of(context)!.updating,
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
                              AppLocalizations.of(context)!.update,
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
      }),
    );
  }

  void onUpdatePressed(context) async {
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

    var data = await driver.getFormData(update: true);
    Map response = await Api().driverUpdate(data);
    Provider.of<SignUpDataProvider>(context, listen: false).setIsLoading =
        false;
    String status = response['status'];
    switch (status) {
      case "success":
        {
          DriverService().saveDriverData();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
          }));
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
