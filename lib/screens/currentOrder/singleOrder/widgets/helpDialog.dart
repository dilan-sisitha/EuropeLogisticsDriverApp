import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';

class HelpDialog extends StatefulWidget {
  const HelpDialog(
      {Key? key,
      required this.onClose,
      required this.title,
      required this.subTitle,
      required this.image})
      : super(key: key);
  final Function onClose;
  final String title;
  final String subTitle;
  final String image;

  @override
  State<HelpDialog> createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
            child: Text(
              widget.subTitle,
              textAlign: TextAlign.center,
              style: normalBoldText,
            ),
          ),
          Image.asset(
            widget.image,
            height: 150,
            fit: BoxFit.cover,
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: yPrimarytColor,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                widget.onClose();
                //  getImage();
              },
              child: Text(
                "OK",
                style: normalBTextgray,
              )),
        )
      ],
    );
  }
}
