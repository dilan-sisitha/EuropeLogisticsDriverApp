import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class ProcessOrderBtn extends StatefulWidget {
  const ProcessOrderBtn(
      {Key? key,
      required this.btnText,
      required this.onPressed,
      required this.icon})
      : super(key: key);
  final String btnText;
  final Function onPressed;
  final IconData icon;

  @override
  State<ProcessOrderBtn> createState() => _ProcessOrderBtnState();
}

class _ProcessOrderBtnState extends State<ProcessOrderBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: (MediaQuery.of(context).viewPadding.bottom > 0) ? const EdgeInsets.only(bottom: 20.0) : const EdgeInsets.only(bottom: 0.0),
      color: yPrimarytColor,
      child: ElevatedButton.icon(
        icon: Icon(
          widget.icon,
          color: Colors.black,
        ),
        label: Text(
          widget.btnText,
          style: normalBTxtDark,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          shadowColor: Colors.transparent,
          primary: yPrimarytColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          widget.onPressed();
        },
      ),
    );
  }
}
