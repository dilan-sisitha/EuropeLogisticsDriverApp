import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class DetailsTab extends StatelessWidget {
  final String titleText, subTitleText;
  Icon iconName;
  Widget? elevButton;

  DetailsTab(
      {Key? key,
      required this.titleText,
      required this.subTitleText,
      required this.iconName,
      this.elevButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: iconName,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: SizedBox(
                  width: size.width / 3 * 2,
                  child: RichText(
                    // overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: titleText,
                      style: normalLightText,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: size.width / 3 * 2,
                  child: RichText(
                    // overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: subTitleText,
                      style: normalBTxtDark,
                    ),
                  ),
                ),
              ),
              elevButton ?? Container()
            ],
          ),
        ],
      ),
    );
  }
}
