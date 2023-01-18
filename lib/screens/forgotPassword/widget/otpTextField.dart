import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPText extends StatefulWidget {
  OTPText(
      {required this.controller,
      this.hasError = false,
      this.onTap,
      this.isLast = false,
      Key? key})
      : super(key: key);
  final TextEditingController controller;
  bool hasError;
  VoidCallback? onTap;
  bool isLast;

  @override
  State<OTPText> createState() => _OTPTextState();
}

class _OTPTextState extends State<OTPText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 35,
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            widget.onTap!();
            if (!widget.isLast) {
              FocusScope.of(context).nextFocus();
            }
          }
        },
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.hasError ? Colors.red : Colors.black54),
          ),
        ),
        onTap: () {
          widget.onTap!();
        },
        controller: widget.controller,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
