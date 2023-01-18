import 'dart:async';

import 'package:euex/components/cons.dart';
import 'package:euex/providers/passwordResetProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class OTPTimer extends StatefulWidget {
  const OTPTimer({required this.onResend, Key? key}) : super(key: key);
  final Function onResend;

  @override
  State<OTPTimer> createState() => _OTPTimerState();
}

class _OTPTimerState extends State<OTPTimer> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => startTimer());
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    if (mounted) {
      setState(() => countdownTimer!.cancel());
    }
  }

  void resetTimer() {
    stopTimer();
    if (mounted) {
      setState(() => myDuration = const Duration(minutes: 2));
    }
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    if (mounted) {
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Consumer<PasswordResetProvider>(builder: (context, value, child) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  String result = await widget.onResend();
                  if (result == "success") {
                    resetTimer();
                    startTimer();
                  }
                },
                child: Container(
                  child: value.isLoadingResendCode
                      ? Row(
                          children: [
                            const SizedBox(
                              child: CircularProgressIndicator(
                                color: bPrimaryLightColor,
                              ),
                              height: 16.0,
                              width: 16.0,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              AppLocalizations.of(context)!.sending,
                              style: linkText2,
                            ),
                          ],
                        )
                      : Text(
                          AppLocalizations.of(context)!.resendCode,
                          style: linkText2,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: value.isLoadingResendCode
                    ? Container()
                    : myDuration == Duration.zero
                        ? Text(
                            AppLocalizations.of(context)!.expired,
                            style: DarkWieghtFont,
                          )
                        : Text('$minutes:$seconds', style: DarkWieghtFont),
              ),
            ],
          ),
        ],
      );
    });
  }
}
