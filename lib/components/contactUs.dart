import 'package:euex/components/cons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

ContactUs(text, [size = 17.0]) {
  return TextSpan(
    text: text,
    style: TextStyle(
      color: bPrimaryLightColor,
      fontSize: size,
      decoration: TextDecoration.underline,
    ),
    recognizer: TapGestureRecognizer()
      ..onTap = () async {
        final url =
            Uri(scheme: 'https', host: 'europe.express', path: 'contact');
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw 'Could not launch $url';
        }
      },
  );
}
