import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class DefaultCardWidgetArrow extends StatelessWidget {
  final String title, subtitle;
  final Function press;

  const DefaultCardWidgetArrow({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                          top: 30, bottom: 30, left: 20, right: 10),
                      width: width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: title,
                              style: normalBlueBoldText,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: RichText(
                              text: TextSpan(
                                text: subtitle,
                                style: normalLText,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.chevron_right),
              )
            ],
          ),
        ),
      ),
    );
  }
}
