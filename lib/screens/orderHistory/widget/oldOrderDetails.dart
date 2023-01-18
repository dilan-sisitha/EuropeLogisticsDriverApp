import 'package:euex/components/button.dart';
import 'package:euex/components/lineSpacer.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/detailTabs.dart';
import 'package:euex/screens/orderHistory/widget/cooperateOrder.dart';
import 'package:euex/screens/orderHistory/widget/topPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../chat/chatButton.dart';

class OldOrderDetails extends StatelessWidget {
  final Order order;

  const OldOrderDetails({Key? key, required this.order}) : super(key: key);

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
                subTitleText: order.fromAddress,
                iconName: const Icon(
                  Icons.location_on,
                  color: iconcolors3,
                )),
            const Linehr(),
            DetailsTab(
                titleText: AppLocalizations.of(context)!.deliveryLocation,
                subTitleText: order.toAddress,
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
            order.qrCode != null
                ? QrImage(
                    data: order.qrCode.toString(),
                    version: QrVersions.auto,
                    size: 200.0,
                  )
                : Container(),
            heightSet
          ],
        ),
      ),
    );
  }
}
