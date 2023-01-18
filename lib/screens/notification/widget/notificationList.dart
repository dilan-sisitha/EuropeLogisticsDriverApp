import 'package:euex/components/cons.dart';
import 'package:euex/lists/notification.dart';
import 'package:flutter/material.dart';

class NotificationList extends StatelessWidget {
  final int itemIndex;
  final Notificationdetails notificationdetails;

  const NotificationList({
    Key? key,
    required this.notificationdetails,
    required this.itemIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var date = notificationdetails.date;
    var time = notificationdetails.time;
    double halfWidth = MediaQuery.of(context).size.width * 0.9;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
          child: Container(
            width: double.infinity,
            decoration: notificationdetails.read == false
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xFF03befc).withOpacity(0.2))
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: lightGreyColor),
            //color: notificationdetails.read == true ? lightGreyColor : whiteColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 10.0, 20.0, 10.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(child: notificationdetails.icon),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: halfWidth - 50,
                        child: RichText(
                          // overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: notificationdetails.text,
                            style: normalBTxtDark,
                          ),
                        ),
                      ),
                      Text(
                        "$date at $time",
                        style: smallBTextgray,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 2.0, left: 10, right: 10, bottom: 2),
          child: SizedBox(
            width: double.infinity,
            height: 1,
            child: DecoratedBox(decoration: BoxDecoration(color: grayColor)),
          ),
        )
      ],
    );
  }
}
