import 'package:flutter/material.dart';

import '../../../components/cons.dart';

class MessageStatusDot extends StatelessWidget {
  final String? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dotColor(String? status) {
      switch (status) {
        case 'notSent':
          return redColor;
        case 'notViewed':
          return grayColor2;
        case 'viewed':
          return bPrimaryLightColor;
        default:
          return Colors.green;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 20 / 2),
      height: 14,
      width: 14,
      decoration: const BoxDecoration(
        color: grayColor3,
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == 'not_sent' ? Icons.close : Icons.done,
        size: 10,
        color: dotColor(status),
      ),
    );
  }
}