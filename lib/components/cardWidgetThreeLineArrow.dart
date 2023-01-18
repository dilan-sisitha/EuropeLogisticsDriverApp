import 'package:euex/components/button.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:euex/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardWidgetWithArrowThreeTitles extends StatelessWidget {
  final int itemIndex;
  final Order order;
  final Function press;

  const CardWidgetWithArrowThreeTitles({
    Key? key,
    required this.itemIndex,
    required this.order,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
      child: InkWell(
        onTap: () {
          press();
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: double.infinity,
              // height: 106,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: whiteColor,
                boxShadow: const [vDefaultShadow],
              ),
              child: Column(
                children: [
                  order.cooperateOrderId != null
                      ? Container(
                          child: SizedBox(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                children: const [
                                  corporateOrderbadge(btnTxt: "Corporate Order")
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 10, right: 10),
                            width: 200,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.content_paste,
                                        color: iconcolors1,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: order.orderId,
                                            style: normalBTxtDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: iconcolors2,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: (AppLocalizations.of(context)!
                                                .dateOfCollection),
                                            style: lgLTextDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: DateTimeFormatter()
                                            .getFormattedDate(
                                                order.logisticTime),
                                        style: normalBTxtDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.chevron_right),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
