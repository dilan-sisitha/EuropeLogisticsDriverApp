// ignore: file_names
import 'package:euex/components/enlargeImage.dart';
import 'package:euex/components/imageShape.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:flutter/material.dart';

class CooperateOrder extends StatelessWidget {
  final Order order;

  const CooperateOrder({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: const [vDefaultShadow3],
          color: lightGreyColor,
          borderRadius: BorderRadius.circular(30.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: imageShape(
                    imgURL: order.orderId, widthSize: 90, heightSize: 90),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      order.orderId,
                      style: BnormalBTextDark,
                    ),
                  ),
                  //  CallDriverBtn(order: order)
                ],
              ),
            ],
          ),
          EnlargeFullWidthImge(imgURL: order.orderId),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20.0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderId,
                  style: lgLText,
                ),
                Text(order.orderId),
                Text(
                  order.orderId,
                  style: lgBTextDark,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
