import 'package:euex/api/api.dart';
import 'package:euex/components/contactUs.dart';
import 'package:euex/components/customAlertDialog.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/reTypePasswordFeild.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/providers/passwordResetProvider.dart';
import 'package:euex/screens/forgotPassword/widget/countDownTime.dart';
import 'package:euex/screens/forgotPassword/widget/otpTextField.dart';
import 'package:euex/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Verification extends StatefulWidget {
  const Verification({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  FocusNode otpErrorFocusNode = FocusNode();
  final firstDigitController = TextEditingController();
  final secondDigitController = TextEditingController();
  final thirdDigitController = TextEditingController();
  final fourthDigitController = TextEditingController();
  final fifthDigitController = TextEditingController();
  final sixthDigitController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    firstDigitController.dispose();
    secondDigitController.dispose();
    thirdDigitController.dispose();
    fourthDigitController.dispose();
    fifthDigitController.dispose();
    sixthDigitController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    otpErrorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double appBarHeight = AppBar().preferredSize.height;
    double height = MediaQuery.of(context).size.height -
        appBarHeight -
        statusBarHeight -
        32;
    double deviceHeight = MediaQuery.of(context).size.height;
    double checkHeight = 670.0;

    return Scaffold(
      backgroundColor: bPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: const NetworkStatus(),
          ),
          AppBar(
            title: Text(
              AppLocalizations.of(context)!.verification,
              style: const TextStyle(fontFamily: "openSansB", color: whiteColor),
            ),
            elevation: 0,
            backgroundColor: bPrimaryColor,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: checkHeight > deviceHeight ? checkHeight : height,
                  decoration: const BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      )),
                  child: Consumer<PasswordResetProvider>(
                      builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: widget.text,
                                  style: DarkWieghtFont,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              /*Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "We have sent you the code verification.",
                                          style: DarkFont,
                                        ),
                                      ),
                                    ),*/
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: AppLocalizations.of(context)!
                                                    .please +
                                                " "),
                                        ContactUs(AppLocalizations.of(context)!
                                            .contactUs),
                                        TextSpan(
                                            text: " " +
                                                AppLocalizations.of(context)!
                                                    .ifYouDidNotReceiveVerificationCode)
                                      ],
                                      style: DarkFont,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OTPText(
                                  controller: firstDigitController,
                                  hasError: value.firstDigitError,
                                  onTap: () {
                                    _isCompleteOtp();
                                    value.firstDigitError = false;
                                  },
                                ),
                                OTPText(
                                  controller: secondDigitController,
                                  hasError: value.secondDigitError,
                                  onTap: () {
                                    _isCompleteOtp();
                                    value.secondDigitError = false;
                                  },
                                ),
                                OTPText(
                                  controller: thirdDigitController,
                                  hasError: value.thirdDigitError,
                                  onTap: () {
                                    _isCompleteOtp();
                                    value.thirdDigitError = false;
                                  },
                                ),
                                OTPText(
                                  controller: fourthDigitController,
                                  hasError: value.fourthDigitError,
                                  onTap: () {
                                    _isCompleteOtp();
                                    value.fourthDigitError = false;
                                  },
                                ),
                                OTPText(
                                  controller: fifthDigitController,
                                  hasError: value.fifthDigitError,
                                  onTap: () {
                                    _isCompleteOtp();
                                    value.fifthDigitError = false;
                                  },
                                ),
                                OTPText(
                                  controller: sixthDigitController,
                                  hasError: value.sixthDigitError,
                                  onTap: () {
                                    _isCompleteOtp();
                                    value.sixthDigitError = false;
                                  },
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: value.isOTPError
                                ? Focus(
                                    child: Text(
                                      value.otpErrorText!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    focusNode: otpErrorFocusNode,
                                  )
                                : Container(),
                          )
                        ]),
                        OTPTimer(onResend: resendOtpCode),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 28.0, 20, 20),
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: AppLocalizations.of(context)!
                                    .stringPasswordIncludes,
                                style: DarkFont,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 18.0, right: 18.0),
                          child: RetypePasswordTextField(
                            controller: confirmPasswordController,
                            hintTextRetype:
                                AppLocalizations.of(context)!.enterNewPassword,
                            onTap: () {
                              validateOTP();
                              value.newPwdErrorText = null;
                            },
                            errorText: value.newPwdErrorText,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: RetypePasswordTextField(
                            controller: newPasswordController,
                            hintTextRetype: AppLocalizations.of(context)!
                                .confirmNewPassword,
                            onTap: () {
                              validateOTP();
                              value.confirmPwdErrorText = null;
                            },
                            errorText: value.confirmPwdErrorText,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: value.isLoadingResetBtn
                                  ? yPrimarytColorLoading
                                  : yPrimarytColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              if (context
                                  .read<NetworkConnectivityProvider>()
                                  .isOnline) {
                                _onVerificationSubmit();
                              } else {
                                _showMyDialog(
                                    AppLocalizations.of(context)!
                                        .yourDeviceIsOffline,
                                    AppLocalizations.of(context)!
                                        .pleaseCheckYourInternetConnection,
                                    context);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: (value.isLoadingResetBtn)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                          const SizedBox(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                            height: 19.0,
                                            width: 19.0,
                                          ),
                                          const SizedBox(width: 7),
                                          Text(
                                              value.isLoadingResetBtn
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .loading
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .resetPassword,
                                              style: TextStyle(
                                                color: value.isLoadingResetBtn
                                                    ? Colors.white
                                                    : Colors.black54,
                                                fontFamily: 'openSansB',
                                                fontSize: 18.0,
                                              ))
                                        ])
                                  : Container(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .resetPassword,
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
                      ],
                    );
                  }),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  bool _matchPasswords() {
    if (newPasswordController.text == confirmPasswordController.text) {
      return true;
    }
    context.read<PasswordResetProvider>().confirmPwdErrorText =
        AppLocalizations.of(context)!.passwordsDoNotMatch;
    return false;
  }

  bool _checkPasswords() {
    if (newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      context.read<PasswordResetProvider>().newPwdErrorText = null;
      context.read<PasswordResetProvider>().confirmPwdErrorText = null;
      return true;
    } else {
      if (newPasswordController.text.isEmpty) {
        context.read<PasswordResetProvider>().newPwdErrorText =
            AppLocalizations.of(context)!.thisFieldIsRequired;
      }
      if (newPasswordController.text.isEmpty) {
        context.read<PasswordResetProvider>().confirmPwdErrorText =
            AppLocalizations.of(context)!.thisFieldIsRequired;
      }
      return false;
    }
  }

  _onVerificationSubmit() {
    context.read<PasswordResetProvider>().newPwdErrorText = null;
    context.read<PasswordResetProvider>().confirmPwdErrorText = null;
    validateOTP();
    bool invalidOtp = context.read<PasswordResetProvider>().isOTPError;
    bool completePasswords = _checkPasswords();
    if (!invalidOtp && completePasswords) {
      if (_matchPasswords()) {
        resetPassword();
      }
    }
  }

  String getOtp() {
    return firstDigitController.text +
        secondDigitController.text +
        thirdDigitController.text +
        fourthDigitController.text +
        fifthDigitController.text +
        sixthDigitController.text;
  }

  bool _isCompleteOtp() {
    if (firstDigitController.text.isNotEmpty &&
        secondDigitController.text.isNotEmpty &&
        thirdDigitController.text.isNotEmpty &&
        fourthDigitController.text.isNotEmpty &&
        fifthDigitController.text.isNotEmpty &&
        sixthDigitController.text.isNotEmpty) {
      context.read<PasswordResetProvider>().isOTPError = false;
      return true;
    }
    return false;
  }

  validateOTP() {
    if (_isCompleteOtp()) {
      context.read<PasswordResetProvider>().isOTPError = false;
      context.read<PasswordResetProvider>().otpErrorText = null;
    } else {
      context.read<PasswordResetProvider>().isOTPError = true;
      context.read<PasswordResetProvider>().otpErrorText =
          AppLocalizations.of(context)!.verificationCodeMustBECompleted;
      if (firstDigitController.text.isEmpty) {
        context.read<PasswordResetProvider>().firstDigitError = true;
      }
      if (secondDigitController.text.isEmpty) {
        context.read<PasswordResetProvider>().secondDigitError = true;
      }
      if (thirdDigitController.text.isEmpty) {
        context.read<PasswordResetProvider>().thirdDigitError = true;
      }
      if (fourthDigitController.text.isEmpty) {
        context.read<PasswordResetProvider>().fourthDigitError = true;
      }
      if (fifthDigitController.text.isEmpty) {
        context.read<PasswordResetProvider>().fifthDigitError = true;
      }
      if (sixthDigitController.text.isEmpty) {
        context.read<PasswordResetProvider>().sixthDigitError = true;
      }
    }
  }

  void resetPassword() async {
    context.read<PasswordResetProvider>().isLoadingResetBtn = true;
    var data = {
      'otp': getOtp(),
      'password': newPasswordController.text,
      'password_confirmation': confirmPasswordController.text
    };
    Map response = await Api().restPassword(data);
    context.read<PasswordResetProvider>().isLoadingResetBtn = false;
    String status = response['status'];
    switch (status) {
      case "success":
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen(
                  showResetBanner: true,
                );
              },
            ),
          );
        }
        break;
      case "invalid_otp":
        {
          otpErrorFocusNode.requestFocus();
          context.read<PasswordResetProvider>().otpErrorText =
              AppLocalizations.of(context)!.invalidVerificationCode;
          context.read<PasswordResetProvider>().isOTPError = true;
        }
        break;
      case "otp_expired":
        {
          otpErrorFocusNode.requestFocus();
          context.read<PasswordResetProvider>().otpErrorText =
              AppLocalizations.of(context)!.verificationCodeHasExpired;
          context.read<PasswordResetProvider>().isOTPError = true;
        }
        break;
      case "validation_errors":
        {}
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

  Future<String> resendOtpCode() async {
    final String status;
    if (Provider.of<NetworkConnectivityProvider>(context, listen: false)
        .isOnline) {
      context.read<PasswordResetProvider>().isLoadingResendCode = true;
      Map response =
          await Api().requestVerificationCode({'email': widget.text});
      status = response['status'];
      Provider.of<PasswordResetProvider>(context, listen: false)
          .isLoadingResendCode = false;
    } else {
      status = "no_internet";
    }
    Provider.of<PasswordResetProvider>(context, listen: false)
        .isLoadingResendCode = false;
    switch (status) {
      case "success":
        {}
        break;
      case "server_error":
        {
          context.read<PasswordResetProvider>().otpErrorText =
              AppLocalizations.of(context)!.resendingVerificationCodeFailed;
        }
        break;

      case "app_error":
        {
          _showMyDialog(AppLocalizations.of(context)!.applicationError,
              AppLocalizations.of(context)!.pleaseTryAgain, context);
        }
        break;
      case "no_internet":
        {
          _showMyDialog(
              AppLocalizations.of(context)!.yourDeviceIsOffline,
              AppLocalizations.of(context)!.pleaseCheckYourInternetConnection,
              context);
        }
        break;

      default:
        {
          _showMyDialog(AppLocalizations.of(context)!.somethingWentWrong,
              AppLocalizations.of(context)!.pleaseTryAgain, context);
        }
        break;
    }
    return status;
  }
}
