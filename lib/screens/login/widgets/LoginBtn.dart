import 'package:euex/api/api.dart';
import 'package:euex/components/customAlertDialog.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/providers/loginDataProvider.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../providers/authProvider.dart';

class LoginBtn extends StatefulWidget {
  final TextEditingController emailController, passwordController;

  const LoginBtn({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  State<LoginBtn> createState() => _LoginBtnState();
}

class _LoginBtnState extends State<LoginBtn> with LoginService {
  bool isLoading = false;

  Future<void> onLoginPressed() async {
    bool isOnline =
        Provider.of<NetworkConnectivityProvider>(context, listen: false)
            .isOnline;
    if (!isOnline) {
      _showMyDialog(AppLocalizations.of(context)!.yourDeviceIsOffline,
          AppLocalizations.of(context)!.pleaseCheckYourInternetConnection);
    } else {
      if (widget.emailController.text.isNotEmpty &&
          widget.passwordController.text.isNotEmpty) {
        Provider.of<LoginDataProvider>(context, listen: false).setIsLoading =
            true;
        Provider.of<LoginDataProvider>(context, listen: false).isDisabledUser =
            false;
        try{
          await _submitLogin();
          Provider.of<LoginDataProvider>(context, listen: false).setIsLoading =
          false;
        }catch(e){
          _showMyDialog(AppLocalizations.of(context)!.somethingWentWrong,
              AppLocalizations.of(context)!.pleaseTryAgain);
          Provider.of<LoginDataProvider>(context, listen: false).setIsLoading =
          false;
        }

      } else {
        if (widget.emailController.text.isEmpty) {
          Provider.of<LoginDataProvider>(context, listen: false).setUnameError =
              AppLocalizations.of(context)!.userNameIsRequired;
        }
        if (widget.passwordController.text.isEmpty) {
          Provider.of<LoginDataProvider>(context, listen: false).setPwdError =
              AppLocalizations.of(context)!.passwordIsRequired;
        }
      }
    }
  }

  Future<void> _submitLogin() async {
    final email = widget.emailController.text;
    final password = widget.passwordController.text;
    final data = {'email': email, 'password': password};
    Provider.of<LoginDataProvider>(context, listen: false).setUnameError = null;
    Provider.of<LoginDataProvider>(context, listen: false).setPwdError = null;
    final response = await Api().login(data);
    print(response);
    switch (response['status']) {
      case "success":
        {
          GlobalKey<NavigatorState> key = Provider.of<AuthProvider>(context, listen: false).navigationKey;
          await LoginService().processLogin(context, response['data'],data,key);
        }
        break;
      case "disabled":
        {
          Provider.of<LoginDataProvider>(context, listen: false)
              .isDisabledUser = true;
        }
        break;
      case "invalid":
        {
          Provider.of<LoginDataProvider>(context, listen: false).setUnameError =
              AppLocalizations.of(context)!.invalidCredentials;
          Provider.of<LoginDataProvider>(context, listen: false).setPwdError =
              AppLocalizations.of(context)!.invalidCredentials;
        }
        break;

      case "server_error":
        {
          _showMyDialog(AppLocalizations.of(context)!.somethingWentWrong,
              AppLocalizations.of(context)!.pleaseTryAgain);
        }
        break;

      case "app_error":
        {
          _showMyDialog(AppLocalizations.of(context)!.applicationError,
              AppLocalizations.of(context)!.pleaseTryAgain);
        }
        break;

      default:
        {
          _showMyDialog(AppLocalizations.of(context)!.somethingWentWrong,
              AppLocalizations.of(context)!.pleaseTryAgain);
        }
        break;
    }
    Provider.of<LoginDataProvider>(context, listen: false).setIsLoading = false;
  }

  Future<void> _showMyDialog(title, text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: title, body: text, btnTxt: AppLocalizations.of(context)!.ok);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginDataProvider>(builder: (context, value, child) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: value.isLoading ? yPrimarytColorLoading : yPrimarytColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          value.isLoading ? null : onLoginPressed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: value.isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                      SizedBox(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        height: 19.0,
                        width: 19.0,
                      ),
                      SizedBox(width: 7),
                      Text('Loading',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'openSansB',
                            fontSize: 18.0,
                          ))
                    ])
              : Text(
                  AppLocalizations.of(context)!.login,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'openSansB',
                    fontSize: 18.0,
                  ),
                ),
        ),
      );
    });
  }
}
