import 'dart:io';

import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/providers/signUpDataProvider.dart';
import 'package:euex/screens/signUp/signUpForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final contactNoController = TextEditingController();
  final vatNoController = TextEditingController();
  final vanTypeController = TextEditingController();
  final vanMakeController = TextEditingController();
  final vanRegistrationController = TextEditingController();
  final bankAccountController = TextEditingController();
  final vanColourController = TextEditingController();
  final carrierNameController = TextEditingController();
  final carrierEmailController = TextEditingController();
  final carrierPhoneController = TextEditingController();
  final swiftCodeController = TextEditingController();
  File? vanImage;
  File? driverImage;
  String? vanType;

  final _formKey = GlobalKey<FormState>();
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    contactNoController.dispose();
    vatNoController.dispose();
    vanTypeController.dispose();
    vanMakeController.dispose();
    vanRegistrationController.dispose();
    bankAccountController.dispose();
    vanColourController.dispose();
    carrierNameController.dispose();
    carrierEmailController.dispose();
    carrierPhoneController.dispose();
    swiftCodeController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return ChangeNotifierProvider(
      create: (context) => SignUpDataProvider(),
      child: Scaffold(
        backgroundColor: darkPrimaryColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const NetworkStatus(),
            ),
            AppBar(
              title: Text(
                AppLocalizations.of(context)!.createYourAccount,
                style: const TextStyle(fontFamily: "openSansB"),
              ),
              elevation: 0,
              backgroundColor: darkPrimaryColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            heightSet,
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                AppLocalizations.of(context)!.letsSetUp,
                                style: normalBoldText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                AppLocalizations.of(context)!.yourDriverAccount,
                                style: normalBTextDark,
                              ),
                            ),
                            heightSet,
                            SignUpForm(
                              formKey: _formKey,
                              focusNode: focusNode,
                              firstNameController: firstNameController,
                              lastNameController: lastNameController,
                              userNameController: userNameController,
                              passwordController: passwordController,
                              emailController: emailController,
                              companyNameController: companyNameController,
                              companyAddressController:
                                  companyAddressController,
                              contactNoController: contactNoController,
                              vatNoController: vatNoController,
                              vanMakeController: vanMakeController,
                              vanRegistrationController:
                                  vanRegistrationController,
                              bankAccountController: bankAccountController,
                              vanColourController: vanColourController,
                              carrierNameController: carrierNameController,
                              carrierEmailController: carrierEmailController,
                              swiftCodeController: swiftCodeController,
                              carrierPhoneController: carrierPhoneController,
                              vanImage: vanImage,
                              driverImage: driverImage,
                              vanType: vanType,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
