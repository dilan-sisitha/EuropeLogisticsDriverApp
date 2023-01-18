import 'package:euex/screens/login/login.dart';
import 'package:flutter/material.dart';

class RedirectLogin extends StatelessWidget {
  const RedirectLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: LoginScreen(), onWillPop: () async => false);
  }
}
