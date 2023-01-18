import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:euex/components/button.dart';
import 'package:euex/components/defaultCardWidgetArrow.dart';
import 'package:euex/components/defaultCardWidgetTitle.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/driverData.dart';
import 'package:euex/screens/accountSettings/driverdetailsUpdate.dart';
import 'package:euex/screens/accountSettings/widgets/imageArea.dart';
import 'package:euex/screens/chat/chatButton.dart';
import 'package:euex/screens/forgotPassword/forgotpassword.dart';
import 'package:euex/screens/login/login.dart';
import 'package:euex/services/logOutService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AccountSetting extends StatelessWidget {
  const AccountSetting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    var driverDetails = Hive.box('driver_details');
    var driverName = driverDetails.containsKey("driverName")
        ? driverDetails.get("driverName")
        : "";
    var driverImage = driverDetails.containsKey("driverImage")
        ?driverDetails.get("driverImage")
        : "";
    double appBarHeight = AppBar().preferredSize.height;
    double height = MediaQuery.of(context).size.height -
        appBarHeight -
        statusBarHeight;
    double deviceHeight = MediaQuery.of(context).size.height;
    double checkHeight = 670.0;

    return Scaffold(
      floatingActionButton: const ChatButton(),
      backgroundColor: bPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: const NetworkStatus(),
          ),
          AppBar(
            title: const Text(
              "Account Settings",
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
                  height: checkHeight > deviceHeight ? checkHeight : height,
                  padding: const EdgeInsets.all(18.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60.0),
                        topRight: Radius.circular(60.0)),
                    color: whiteColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      children: [
                        driverImage!=''?
                        SettingsImage(imgUrl: driverImage):
                        Image.asset(
                          'asset/images/profile-user.png',
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                        ),
                        const Text(
                          "Hello",
                          style: lgLTextDark,
                        ),
                        Text(
                          driverName,
                          style: normalBoldText,
                          textAlign: TextAlign.center,
                        ),
                        heightSet,
                        DefaultCardWidgetArrow(
                            title: "Driver Details",
                            subtitle: "Change your details and van details",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const DriverDetailsUpdate();
                                  },
                                ),
                              );
                            }),
                        DefaultCardWidgetArrow(
                            title: "Password Reset",
                            subtitle: "Change your password",
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ForgotPassword();
                                  },
                                ),
                              );
                            }),
                        DefaultCardWidgetTitle(
                            press: () async {
                              AwesomeDialog dlg = AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Are You sure',
                                  desc: 'Do you want to exit',
                                  dismissOnBackKeyPress: false,
                                  useRootNavigator: true,
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    LogOutService().clearUserData();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return LoginScreen();
                                        },
                                      ),
                                    );
                                  },
                                  btnOkText: 'Yes',
                                  btnCancelText: 'No');
                              await dlg.show();
                            },
                            title: "Logout")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
