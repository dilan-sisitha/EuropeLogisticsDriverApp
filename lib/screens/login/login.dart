import 'package:euex/components/contactUs.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/providers/loginDataProvider.dart';
import 'package:euex/screens/forgotPassword/forgotpassword.dart';
import 'package:euex/screens/login/widgets/LoginBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../components/cons.dart';
import '../signUp/signup.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    this.navigatorKey,
    Key? key,
    this.showResetBanner = false,
  }) : super(key: key);
  bool showResetBanner;

  final navigatorKey;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  dynamic usernameError;
  dynamic passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double Height1 = MediaQuery.of(context).size.height;
    final panelHeight1 = MediaQuery.of(context).size.height * 0.18;
    final panelHeightw1 = MediaQuery.of(context).size.height * 0.82;
    final panelHeight = MediaQuery.of(context).size.height * 0.25;
    final panelHeightw = MediaQuery.of(context).size.height * 0.75;
    var height = MediaQuery.of(context).viewPadding.top;

    if (widget.showResetBanner) {
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          widget.showResetBanner = false;
        });
      });
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginDataProvider()),
      ],
      builder: (context, child) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
              backgroundColor: darkPrimaryColor,
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height),
                    child: const NetworkStatus(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            height: Height1 < 700 ? panelHeight1 : panelHeight,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Image.asset(
                                    "asset/images/logo.png",
                                    width: size.width * 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: Height1 < 700 ? panelHeightw1 : panelHeightw,
                            margin: Height1 < 700
                                ? EdgeInsets.only(top: panelHeight1)
                                : EdgeInsets.only(top: panelHeight),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  widget.showResetBanner
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: lightGreenColor),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.only(right: 20),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: const Icon(
                                                    Icons.done,
                                                    color: lightGreenColor,
                                                  ),
                                                ),
                                                Text(AppLocalizations.of(context)!
                                                    .passwordUpdatedSuccessfully)
                                              ],
                                            ),
                                          ))
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalizations.of(context)!.welcomeBack,
                                      style: HomeBannerTxt,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .europeExpressDriverApp,
                                      style: BnormalBTextDark,
                                    ),
                                  ),
                                  heightSet,
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Consumer<LoginDataProvider>(
                                            builder: (context, value, child) {
                                          return TextField(
                                            keyboardType: TextInputType.name,
                                            controller: emailController,
                                            onTap: () {
                                              value.setUnameError = null;
                                              value.isDisabledUser = false;
                                            },
                                            style: const TextStyle(
                                              fontSize: 17.0,
                                            ),
                                            decoration: InputDecoration(
                                                labelText:
                                                    AppLocalizations.of(context)!
                                                        .userName,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 15),
                                                prefixIcon:
                                                    const Icon(Icons.account_circle),
                                                errorText: value.unameError),
                                          );
                                        }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Consumer<LoginDataProvider>(
                                            builder: (context, value, child) {
                                          return TextField(
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            obscureText: value.isHidden,
                                            controller: passwordController,
                                            onTap: () {
                                              value.setPwdError = null;
                                              value.isDisabledUser = false;
                                            },
                                            style: const TextStyle(
                                              fontSize: 17.0,
                                            ),
                                            decoration: InputDecoration(
                                                labelText:
                                                    AppLocalizations.of(context)!
                                                        .password,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 15),
                                                prefixIcon:
                                                    const Icon(Icons.lock),
                                                suffix: InkWell(
                                                  onTap: () {
                                                    value.setIsHidden =
                                                        !value.isHidden;
                                                  },
                                                  child: Icon(
                                                    value.isHidden
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  ),
                                                ),
                                                errorText: value.pwdError),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const ForgotPassword();
                                            }));
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .forgotPassword,
                                            style: linkText,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Consumer<LoginDataProvider>(
                                      builder: (context, value, child) {
                                    return value.isDisabledUser
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, left: 8, right: 8),
                                            child: Center(
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: AppLocalizations.of(
                                                                context)!
                                                            .yourAccIsDisabled),
                                                    TextSpan(
                                                        text: " " +
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .please +
                                                            " "),
                                                    ContactUs(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .contactSupport,
                                                        16.0),
                                                  ],
                                                  style: ErrorText,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Container(
                                        width: double.infinity,
                                        child: LoginBtn(
                                            emailController: emailController,
                                            passwordController:
                                                passwordController)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(AppLocalizations.of(context)!
                                          .dontHaveAnAccount),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const SignUp();
                                          }));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.signUp,
                                          style: linkText,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
