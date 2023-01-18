import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class CardWidgetWithArrow extends StatelessWidget {
  final String documtName;
  final Function press;

  const CardWidgetWithArrow({
    Key? key,
    required this.documtName,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          boxShadow: const [vDefaultShadow],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Icon(
                        Icons.content_paste,
                        color: yPrimarytColor,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 30, bottom: 30, left: 10, right: 10),
                      width: 200,
                      child: RichText(
                        text: TextSpan(
                          text: documtName,
                          style: normalBTxtDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
    );
  }
}
