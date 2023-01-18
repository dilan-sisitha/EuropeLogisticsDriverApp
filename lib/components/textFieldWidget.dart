import 'package:euex/helpers/emailLengthValidator.dart';
import 'package:euex/helpers/localizationHelper.dart';
import 'package:euex/providers/signUpDataProvider.dart';
import 'package:euex/services/signUpService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget(
      {required this.hText,
      required this.icon,
      required this.controller,
      this.isRequired = true,
      this.errorText,
      this.onFocusChange,
      this.onValueChange,
      this.validateOnChange = false,
      this.textFormData,
      this.updateData = false,
      this.maxLength,
      Key? key})
      : super(key: key);

  final int? maxLength;
  final String? textFormData;
  final String hText;
  final TextEditingController controller;
  final Icon icon;
  bool isRequired;
  bool updateData;
  String? errorText;
  Function? onFocusChange;
  VoidCallback? onValueChange;
  bool validateOnChange;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.updateData && !SignUpService().isFormInvalid(context)) {
      widget.controller.text = widget.textFormData ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataValidator = MultiValidator([
      RequiredValidator(
          errorText: AppLocalizations.of(context)!.thisFieldIsRequired),
      MaxLengthValidator(widget.maxLength!,
          errorText: AppLocalizations.of(context)!.valueLongerThan +
              widget.maxLength.toString() +
              " " +
              AppLocalizations.of(context)!.characters)
    ]);
    final maxLengthValidator = MaxLengthValidator(widget.maxLength!,
        errorText: AppLocalizations.of(context)!.valueLongerThan +
            widget.maxLength.toString() +
            " " +
            AppLocalizations.of(context)!.characters);

    return Consumer<SignUpDataProvider>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: widget.isRequired
            ? Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus && widget.validateOnChange) {
                    if (widget.controller.text.isNotEmpty &&
                        !widget.updateData) {
                      widget.onFocusChange!();
                    }
                  }
                },
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(
                    fontSize: 17.0,
                  ),
                  decoration: InputDecoration(
                      labelText: widget.hText,
                      alignLabelWithHint: false,
                      //  hintText: widget.hText,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      prefixIcon: widget.icon,
                      errorText: widget.errorText),
                  // The validator receives the text that the user has entered.
                  validator: dataValidator,
                  controller: widget.controller,
                  onChanged: (text) {
                    if (!widget.updateData) {
                      value.isValid = true;
                      if (text.isNotEmpty) {
                        widget.onValueChange?.call();
                      }
                    }
                  },
                ),
              )
            : TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: maxLengthValidator,
                style: const TextStyle(
                  fontSize: 17.0,
                ),
                decoration: InputDecoration(
                    labelText: widget.hText,
                    alignLabelWithHint: false,
                    //hintText: widget.hText,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 15),
                    prefixIcon: widget.icon,
                    errorText: widget.errorText),
                // The validator receives the text that the user has entered.
                controller: widget.controller,
                onChanged: (text) {
                  if (!widget.updateData) {
                    value.isValid = true;
                    if (text.isNotEmpty) {
                      widget.onValueChange?.call();
                    }
                  }
                },
              ),
      );
    });
  }
}

class EmailTextWidget extends StatefulWidget {
  EmailTextWidget(
      {required this.ehText,
      required this.errorText,
      required this.eicon,
      required this.emailValidmsg,
      required this.controller,
      this.onFocusChange,
      this.onValueChange,
      this.textFormData,
      this.updateData = false,
      this.maxLength = 10,
      this.isRequired = true,
      Key? key})
      : super(key: key);

  final int maxLength;
  final String ehText, emailValidmsg;
  String? errorText;
  Icon eicon;
  Function? onFocusChange;
  VoidCallback? onValueChange;
  final TextEditingController controller;
  final String? textFormData;
  final bool updateData;
  final bool isRequired;

  @override
  State<EmailTextWidget> createState() => _EmailTextWidgetState();
}

class _EmailTextWidgetState extends State<EmailTextWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.updateData) {
      widget.controller.text = widget.textFormData ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<FieldValidator> validators =[
      EmailValidator(errorText: widget.emailValidmsg),
      MaxLengthValidator(widget.maxLength,
          errorText: AppLocalizations.of(context)!.valueLongerThan +
              widget.maxLength.toString() +
              " " +
              AppLocalizations.of(context)!.characters),
      EmailLocalPartLengthValidator(
          errorText: LocalizationHelper().localize(
              AppLocalizations.of(context)!.emailLengthValidateMsg,
              {'length': '64'})),
      EmailDomainPartLengthValidator(
          errorText: LocalizationHelper().localize(
              AppLocalizations.of(context)!.emailLengthValidateMsg,
              {'length': '255'}))
    ];
    if(widget.isRequired){
     final requiredValidator = RequiredValidator(
           errorText: AppLocalizations.of(context)!.thisFieldIsRequired);
     validators.add(requiredValidator);
    }
    final dataValidator = MultiValidator(validators);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            if (widget.controller.text.isNotEmpty && !widget.updateData) {
              widget.onFocusChange!();
            }
          }
        },
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(
            fontSize: 17.0,
          ),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: widget.ehText,
              alignLabelWithHint: false,
              // hintText: widget.ehText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              prefixIcon: widget.eicon,
              errorText: widget.errorText),
          validator: dataValidator,
          controller: widget.controller,
          onChanged: (value) {
            if (!widget.updateData) {
              widget.onValueChange?.call();
            }
          },
        ),
      ),
    );
  }
}

class passwordTextFeild extends StatefulWidget {
  passwordTextFeild({
    Key? key,
    required this.controller,
    this.errorText,
  }) : super(key: key);

  final TextEditingController controller;
  String? errorText;

  @override
  State<passwordTextFeild> createState() => _passwordTextFeildState();
}

class _passwordTextFeildState extends State<passwordTextFeild> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    final passwordValidator = MultiValidator([
      RequiredValidator(
          errorText: AppLocalizations.of(context)!.thisFieldIsRequired),
      MinLengthValidator(8,
          errorText: "password must be at least 8 digits long"),
      /*PatternValidator(r'(?=.*?[#?!@$%^&*-])',
          errorText: "passwords must have at least one special character")*/
    ]);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: _isHidden,
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.password,
            prefixIcon: const Icon(Icons.lock),
            suffix: InkWell(
              onTap: _togglePasswordView,
              child: Icon(
                _isHidden ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            errorText: widget.errorText),
        validator: passwordValidator,
        controller: widget.controller,
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}

class TelNoField extends StatefulWidget {
  final String hText, emptyMsg;
  final TextEditingController controller;
  final Icon icon;
  final String invalidTelMsg;
  final String? textFormData;
  final bool updateData;
  String? errorText;

  TelNoField({
    Key? key,
    required this.hText,
    required this.emptyMsg,
    required this.icon,
    required this.controller,
    this.errorText,
    this.textFormData,
    this.updateData = false,
    required this.invalidTelMsg,
  }) : super(key: key);

  @override
  State<TelNoField> createState() => _TelNoFieldState();
}

class _TelNoFieldState extends State<TelNoField> {
  @override
  void initState() {
    super.initState();
    if (widget.updateData) {
      widget.controller.text = widget.textFormData ?? '';
    }
  }

  String? _phoneNumberValidator(String value) {
    String pattern =
        r"^(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{2,4})$";
    RegExp regex = RegExp(pattern, caseSensitive: false);
    if (value == null || value.isEmpty) {
      return null;
    } else if (!regex.hasMatch(value)) {
      return widget.invalidTelMsg;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.updateData){
    //   widget.controller.text = widget.textFormData!;
    // }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(
          fontSize: 17.0,
        ),
        decoration: InputDecoration(
            labelText: widget.hText,
            alignLabelWithHint: false,
            //hintText: hText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            prefixIcon: widget.icon,
            errorText: widget.errorText),
        validator: (value) => _phoneNumberValidator(value!),
        onChanged: (text) {
          if (!widget.updateData) {
            Provider.of<SignUpDataProvider>(context, listen: false).isValid =
                true;
          }
        },
      ),
    );
  }
}
