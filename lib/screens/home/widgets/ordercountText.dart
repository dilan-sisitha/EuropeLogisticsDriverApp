import 'package:euex/components/cons.dart';
import 'package:euex/helpers/localizationHelper.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/currentOrderDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class OrderCountText extends StatelessWidget {
  const OrderCountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Order>>(
        valueListenable: Hive.box<Order>('current_orders').listenable(),
        builder: (context, Box<Order> orderBox, widget) {
          return Text(
            context
                        .watch<CurrentOrderDataProvider>()
                        .currentOrdersLastUpdatedAt !=
                    null
                ? _getAvailabilityText(context, orderBox.length)
                : AppLocalizations.of(context)!.checkingForNewOrders,
            style: normalLightText,
          );
        });
  }

  String _getAvailabilityText(context, currentOrdersLength) {
    String availabilityText =
        AppLocalizations.of(context)!.youHaveNoOrdersAvailableToday;
    if (currentOrdersLength > 0) {
      availabilityText = LocalizationHelper().localize(
          AppLocalizations.of(context)!.youHaveOrdersAvailableToday,
          {'count': currentOrdersLength.toString()});
    }
    return availabilityText;
  }
}
