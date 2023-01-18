import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class GrayCard2 extends StatelessWidget {
  const GrayCard2({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: lightGreyColor,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: title,
              style: normalBTextgray,
            ),
          ),
          RichText(
            text: TextSpan(
              text: "£$subTitle",
              style: normalBlueBoldText,
            ),
          ),
        ],
      ),
    );
  }
}
