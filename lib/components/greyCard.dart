import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class GreyCard extends StatelessWidget {
  final String textTop, subText;
  Icon icon;

  GreyCard({
    Key? key,
    required this.textTop,
    required this.subText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: lightGreyColor,
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  textTop,
                  style: normalLText,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: icon,
                ),
                Text(subText, style: lgBTextDark),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
