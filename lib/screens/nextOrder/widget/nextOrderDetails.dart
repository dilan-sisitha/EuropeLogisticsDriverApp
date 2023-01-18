import 'package:euex/components/button.dart';
import 'package:euex/components/lineSpacer.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/detailTabs.dart';
import 'package:euex/screens/orderHistory/widget/cooperateOrder.dart';
import 'package:euex/screens/orderHistory/widget/topPanel.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../chat/chatButton.dart';

class NextOrderDetails extends StatelessWidget {
  final Order order;

  const NextOrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ChatButton(),
      appBar: AppBar(
        backgroundColor: bPrimaryColor,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.orderDetails,
          style: const TextStyle(fontFamily: "openSansB"),
        ),
      ),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopPanel(order: order),
            //  CollectionTime(order: orders),
            DetailsTab(
                titleText: AppLocalizations.of(context)!.pickupLocation,
                subTitleText:
                    OrderService().getPostalCode(order.from, order.fromAddress),
                iconName: const Icon(
                  Icons.location_on,
                  color: iconcolors3,
                )),
            const Linehr(),
            DetailsTab(
                titleText: AppLocalizations.of(context)!.deliveryLocation,
                subTitleText:
                    OrderService().getPostalCode(order.to, order.toAddress),
                iconName: const Icon(
                  Icons.location_on,
                  color: iconcolors3,
                )),
            const Linehr(),
            DetailsTab(
                titleText: AppLocalizations.of(context)!.driverHelp,
                subTitleText: order.driverHelp
                    ? AppLocalizations.of(context)!.driverHelpIsRequested
                    : AppLocalizations.of(context)!.driverHelpIsNotRequested,
                iconName: const Icon(
                  Icons.account_circle,
                  color: iconcolors4,
                )),
            order.cooperateOrderId != null
                ? CooperateOrder(order: order)
                : Container(),
            heightSet,

            heightSet
          ],
        ),
      ),
    );
  }
}
