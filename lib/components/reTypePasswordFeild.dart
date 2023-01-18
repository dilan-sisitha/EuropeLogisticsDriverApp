//reset password
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RetypePasswordTextField extends StatefulWidget {
  final String hintTextRetype;

  RetypePasswordTextField(
      {Key? key,
      required this.controller,
      required this.hintTextRetype,
      this.onTap,
      this.errorText})
      : super(key: key);

  final TextEditingController controller;
  final String? errorText;
  VoidCallback? onTap;

  @override
  State<RetypePasswordTextField> createState() =>
      _RetypePasswordTextFieldState();
}

class _RetypePasswordTextFieldState extends State<RetypePasswordTextField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    final passwordValidator = MultiValidator([
      RequiredValidator(errorText: "This field is required"),
      MinLengthValidator(8,
          errorText: "password must be at least 8 digits long"),
    ]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: _isHidden,
        decoration: InputDecoration(
          hintText: (widget.hintTextRetype),
          prefixIcon: const Icon(Icons.lock),
          errorText: widget.errorText,
          suffix: InkWell(
            onTap: _togglePasswordView,
            child: Icon(
              !_isHidden ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
        validator: passwordValidator,
        controller: widget.controller,
        onTap: widget.onTap,
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
