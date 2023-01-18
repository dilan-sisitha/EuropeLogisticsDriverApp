import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_field_validator/form_field_validator.dart';

class UpdateTextFeildDefeult extends StatelessWidget {
  final String hText;
  final Icon icon;
  final String textFormData;
  final TextEditingController textController;

  const UpdateTextFeildDefeult(
      {Key? key,
      required this.hText,
      required this.icon,
      required this.textFormData,
      required this.textController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requiredValidator = RequiredValidator(
        errorText: AppLocalizations.of(context)!.thisFieldIsRequired);

    textController.text = textFormData;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: textController,
        validator: requiredValidator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(
          fontSize: 17.0,
        ),
        decoration: InputDecoration(
          hintText: hText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          prefixIcon: icon,
        ),
      ),
    );
  }
}

class UpdateEmailFeilds extends StatelessWidget {
  final String ehText;
  final Icon eicon;
  final String textFormData;

  const UpdateEmailFeilds(
      {Key? key,
      required this.ehText,
      required this.eicon,
      required this.textFormData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: textFormData,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(
          fontSize: 17.0,
        ),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: ehText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          prefixIcon: eicon,
        ),
      ),
    );
  }
}

class UpdateTelNumberFeilds extends StatelessWidget {
  final String hText;
  final Icon icon;
  final String textFormData;

  const UpdateTelNumberFeilds(
      {Key? key,
      required this.hText,
      required this.icon,
      required this.textFormData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: textFormData,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.phone,
      style: const TextStyle(
        fontSize: 17.0,
      ),
      decoration: InputDecoration(
        hintText: hText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        prefixIcon: icon,
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  final String phint;

  const ChangePassword({Key? key, required this.phint}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 18.0, left: 15.0, right: 15.0, bottom: 5),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: _isHidden,
        decoration: InputDecoration(
          hintText: widget.phint,
          prefixIcon: const Icon(Icons.lock),
          suffix: InkWell(
            onTap: _togglePasswordView,
            child: Icon(
              _isHidden ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}

class UpdateDropDown extends StatefulWidget {
  final String ehText;
  final Icon eicon;

  //final Function(String) getVanType;
  const UpdateDropDown(
      {required this.ehText,
      required this.eicon,
      //required this.getVanType,
      Key? key})
      : super(key: key);

  @override
  State<UpdateDropDown> createState() => _UpdateDropDownState();
}

class _UpdateDropDownState extends State<UpdateDropDown> {
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Large 3.5 tonne panel"), value: '1'),
      const DropdownMenuItem(
          child: Text("Large 3.5 tonne curtain sider"), value: '2'),
    ];
    return menuItems;
  }

  String? textVal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: widget.eicon,
        ),
        hint: Text(widget.ehText),
        items: dropdownItems,
        value: textVal,
        onChanged: (String? value) {
          // widget.getVanType(value!);
          setState(() {
            //Provider.of<SignUpDataProvider>(context, listen: false).isValid = true;
            textVal = value;
          });
        },
      ),
    );
  }
}
