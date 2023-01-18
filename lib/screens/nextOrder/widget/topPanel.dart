import 'package:euex/components/button.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/lists/orderList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopPanel extends StatelessWidget {
  final Orders order;

  const TopPanel({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BorderRadius1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          order.corporateOrder == true
              ? const Align(
                  alignment: Alignment.topRight,
                  child: corporateOrderbadge(btnTxt: "Corporate Order"),
                )
              : Container(),
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 5, 18, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.orderId,
                        style: normalWLText,
                      ),
                      Text(
                        order.orderID,
                        style: BnormalBTextwhite,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.size,
                            style: normalWLText,
                          ),
                          SizedBox(
                            width: 150,
                            child: RichText(
                              text: TextSpan(
                                text: order.size,
                                style: BnormalBTextwhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
