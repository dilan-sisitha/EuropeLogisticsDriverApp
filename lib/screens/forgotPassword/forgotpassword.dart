import 'package:euex/api/api.dart';
import 'package:euex/components/customAlertDialog.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/providers/passwordResetProvider.dart';
import 'package:euex/screens/forgotPassword/verificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final phoneTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return ChangeNotifierProvider(
      create: (context) => PasswordResetProvider(),
      child: Scaffold(
        backgroundColor: bPrimaryColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const NetworkStatus(),
            ),
            AppBar(
              title: Text(
                AppLocalizations.of(context)!.forgotPassword,
                style: TextStyle(fontFamily: "openSansB"),
              ),
              elevation: 0,
              backgroundColor: bPrimaryColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .dontWorryItHappens,
                                      style: normalBoldText,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 18.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .pleaseEnterYourEmail,
                                      style: normalLightText,
                                    ),
                                  ),
                                  Consumer<PasswordResetProvider>(
                                      builder: (context, value, child) {
                                    return TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: emailTextController,
                                      style: const TextStyle(
                                        fontSize: 17.0,
                                      ),
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                AppLocalizations.of(context)!
                                                    .thisFieldIsRequired)
                                      ]),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)!
                                            .userNameOrEmail,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 15),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.grey[600],
                                        ),
                                        errorText:
                                            value.verificationContactErrorText,
                                      ),
                                      onChanged: (val) {
                                        value.verificationContactErrorText =
                                            null;
                                      },
                                    );
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: Consumer<PasswordResetProvider>(
                                          builder: (context, value, child) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: value
                                                    .isLoadingVerificationButton
                                                ? yPrimarytColorLoading
                                                : yPrimarytColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          onPressed: () {
                                            if (Provider.of<
                                                        NetworkConnectivityProvider>(
                                                    context,
                                                    listen: false)
                                                .isOnline) {
                                              if (!value
                                                      .isLoadingVerificationButton &&
                                                  _formKey.currentState!
                                                      .validate()) {
                                                value.isLoadingVerificationButton =
                                                    true;
                                                sendVerificationMessage(
                                                    context);
                                              }
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: value
                                                    .isLoadingVerificationButton
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                        const SizedBox(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ),
                                                          height: 19.0,
                                                          width: 19.0,
                                                        ),
                                                        const SizedBox(width: 7),
                                                        Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .loading,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'openSansB',
                                                              fontSize: 18.0,
                                                            ))
                                                      ])
                                                : Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .submit,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'openSansB',
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendVerificationMessage(context) async {
    Map response = await Api()
        .requestVerificationCode({'email': emailTextController.text});
    final String status = response['status'];
    //  final String status ="success";
    Provider.of<PasswordResetProvider>(context, listen: false)
        .isLoadingVerificationButton = false;

    switch (status) {
      case "success":
        {
          Provider.of<PasswordResetProvider>(context, listen: false).reset();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: Provider.of<PasswordResetProvider>(context),
                  child: Verification(
                    text: emailTextController.text,
                  ),
                ),
              ));
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
