// call driver button
import 'package:euex/components/cons.dart';
import 'package:euex/lists/orderList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallDriverBtn extends StatefulWidget {
  final Orders order;

  const CallDriverBtn({Key? key, required this.order}) : super(key: key);

  @override
  State<CallDriverBtn> createState() => _CallDriverBtnState();
}

class _CallDriverBtnState extends State<CallDriverBtn> {
  final TextEditingController _numberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _numberCtrl.text = widget.order.driverContact;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.call,
        color: Colors.black,
      ),
      onPressed: () async {
        await FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
      },
      label: Text(
        "Call Driver",
        style: normalBoldText,
      ),
      style: ElevatedButton.styleFrom(
        primary: btPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
