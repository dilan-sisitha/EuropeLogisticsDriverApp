import 'package:euex/components/button.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:euex/screens/documentPage/viewDocuments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopPanel extends StatelessWidget {
  final Order order;
  bool showDocs;

  TopPanel({
    Key? key,
    required this.order,
    this.showDocs = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BorderRadius1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          order.cooperateOrderId != null
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
                        order.orderId,
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
                            width: width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: order.orderSizeId.toString() + 'm3',
                                    style: BnormalBTextwhite,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        '( up to ${order.mass.toString()}Kg )',
                                    style: BnormalBTextwhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    showDocs
                        ? Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: buttonYellow(
                                btnText:
                                    AppLocalizations.of(context)!.viewDocuments,
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ViewDocuments(order: order);
                                        // return DocumentList(orderId: order.id,);
                                      },
                                    ),
                                  );
                                }),
                          )
                        : const SizedBox()
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
