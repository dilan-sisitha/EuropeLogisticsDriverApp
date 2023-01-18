import 'package:euex/providers/signUpDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CustomDropDownButton extends StatefulWidget {
  CustomDropDownButton(
      {required this.ehText,
      required this.eicon,
      required this.getVanType,
      this.typeId,
      this.errorText,
      this.updateData = false,
      Key? key})
      : super(key: key);
  final String ehText;
  final Icon eicon;
  final bool updateData;
  final Function(String) getVanType;
  String? errorText;
  final int? typeId;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
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
    if (widget.updateData) {
      textVal = widget.typeId.toString();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(fontSize: 17.0, color: Colors.black),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              prefixIcon: widget.eicon,
              errorText: widget.errorText),
          hint: Text(widget.ehText),
          items: dropdownItems,
          value: textVal,
          onChanged: (String? value) {
            if (!widget.updateData) {
              widget.getVanType(value!);
              setState(() {
                Provider.of<SignUpDataProvider>(context, listen: false)
                    .isValid = true;
                textVal = value;
              });
            }
          },
          onSaved: (value) => widget.getVanType(value!),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.thisFieldIsRequired;
            }
            return null;
          }),
    );
  }
}
