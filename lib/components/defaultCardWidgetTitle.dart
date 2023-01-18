import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class DefaultCardWidgetTitle extends StatelessWidget {
  final Function press;
  final String title;

  const DefaultCardWidgetTitle({
    Key? key,
    required this.press,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          press();
        },
        child: Container(
          margin: const EdgeInsets.only(top: 2),
          width: double.infinity,
          // height: 106,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: whiteColor,
            boxShadow: const [vDefaultShadow3],
          ),
          child: Container(
            margin:
                const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 10),
            width: 200,
            child: RichText(
              text: TextSpan(
                text: title,
                style: normalRedBoldText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
