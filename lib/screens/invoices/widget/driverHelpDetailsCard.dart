import 'package:euex/components/button.dart';
import 'package:euex/components/grayCardWithoutIcon.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:euex/models/invoice.dart';
import 'package:euex/screens/invoices/widget/downloadIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DriverHelpDetailsCard extends StatelessWidget {
  final int itemIndex;
  final Invoice invoice;

  const DriverHelpDetailsCard({
    Key? key,
    required this.itemIndex,
    required this.invoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                invoice.isCooperate == true
                    ? SizedBox(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: const [
                              corporateOrderbadge(btnTxt: "Corporate Order")
                            ],
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
                                RichText(
                                  text: TextSpan(
                                    text: invoice.orderId,
                                    style: normalBlueBoldText,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .dateOfCollection,
                                  style: normalBTextgray,
                                ),
                                Text(
                                  DateTimeFormatter()
                                      .getFormattedDate(invoice.logisticDate),
                                  style: normalBlueBoldText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ViewPdf(invoice: invoice),
                    DownloadIcon(
                      invoice: invoice,
                      index: itemIndex,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Loading Time",
                            style: normalBTextgray,
                          ),
                          Text(
                            invoice.totalLoadingTime,
                            style: normalBlueBoldText,
                          ),
                          heightSet,
                          Text(
                            "Total Unloading Time",
                            style: normalBTextgray,
                          ),
                          Text(
                            invoice.totalUnloadingTime,
                            style: normalBlueBoldText,
                          ),
                          heightSet
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        GrayCard2(
                            title: "Amount for \nLoading",
                            subTitle: invoice.amountForLoading.toString()),
                        GrayCard2(
                            title: "Amount for \nUnloading",
                            subTitle: invoice.amountForUnloading.toString()),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
