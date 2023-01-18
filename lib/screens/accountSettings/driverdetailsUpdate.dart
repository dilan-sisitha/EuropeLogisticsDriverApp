import 'dart:io';

import 'package:euex/components/gpsStatus.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/providers/signUpDataProvider.dart';
import 'package:euex/screens/accountSettings/widgets/updateForm.dart';
import 'package:euex/screens/chat/chatButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverDetailsUpdate extends StatefulWidget {
  const DriverDetailsUpdate({Key? key}) : super(key: key);

  @override
  State<DriverDetailsUpdate> createState() => _DriverDetailsUpdateState();
}

class _DriverDetailsUpdateState extends State<DriverDetailsUpdate> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final contactNoController = TextEditingController();
  final vanTypeController = TextEditingController();
  final vanMakeController = TextEditingController();
  final vanRegistrationController = TextEditingController();
  final bankAccountController = TextEditingController();
  final vatRateController = TextEditingController();
  final vanColourController = TextEditingController();
  final carrierNameController = TextEditingController();
  final carrierEmailController = TextEditingController();
  final carrierPhoneController = TextEditingController();
  final swiftCodeController = TextEditingController();
  File? vanImage;
  File? driverImage;
  String? vanType;

  final _updateFormKey = GlobalKey<FormState>();
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
    vanTypeController.dispose();
    vanMakeController.dispose();
    vanRegistrationController.dispose();
    bankAccountController.dispose();
    vatRateController.dispose();
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
        floatingActionButton: const ChatButton(),
        backgroundColor: bPrimaryColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const NetworkStatus(),
            ),
            const GpsStatus(),
            AppBar(
              title: const Text(
                "Update Driver Details",
                style: TextStyle(fontFamily: "openSansB", color: whiteColor),
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
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60.0),
                          topRight: Radius.circular(60.0)),
                      color: whiteColor,
                    ),
                    child: Column(
                      children: [
                        heightSet,
                        UpdateTextFeild(
                          updateFormKey: _updateFormKey,
                          focusNode: focusNode,
                          firstNameController: firstNameController,
                          lastNameController: lastNameController,
                          userNameController: userNameController,
                          passwordController: passwordController,
                          emailController: emailController,
                          companyNameController: companyNameController,
                          companyAddressController: companyAddressController,
                          contactNoController: contactNoController,
                          vanMakeController: vanMakeController,
                          vanRegistrationController: vanRegistrationController,
                          bankAccountController: bankAccountController,
                          vatRateController: vatRateController,
                          vanColourController: vanColourController,
                          carrierNameController: carrierNameController,
                          carrierEmailController: carrierEmailController,
                          swiftCodeController: swiftCodeController,
                          carrierPhoneController: carrierPhoneController,
                          vanImage: vanImage,
                          driverImage: driverImage,
                          vanType: vanType,
                        ),
                        heightSet
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
