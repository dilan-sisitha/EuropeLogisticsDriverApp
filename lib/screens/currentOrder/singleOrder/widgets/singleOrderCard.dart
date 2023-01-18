import 'dart:async';

import 'package:euex/components/button.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/database/firebasertRtDb.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/TimerServiceProvider.dart';
import 'package:euex/screens/currentOrder/singleOrder/orderDetails.dart';
import 'package:euex/screens/home/home.dart';
import 'package:euex/screens/timerPage/timerPage.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:euex/services/orderService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SingleOrderCard extends StatefulWidget {
  const SingleOrderCard({
    Key? key,
    required this.itemIndex,
    required this.order,
  }) : super(key: key);
  final int itemIndex;
  final Order order;

  @override
  State<SingleOrderCard> createState() => _SingleOrderCardState();
}

class _SingleOrderCardState extends State<SingleOrderCard> {
  bool _showLoadingAddress = false;
  bool _adminEnableAddress = false;
  dynamic databaseEvent;
  Timer? timer;

  @override
  void initState() {
    _showLoadingAddress =
        ActiveOrderService().checkLogisticTime(widget.order.logisticTime!);
    _showAddressOnTime();
    _showAddressByAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Home()),
            ModalRoute.withName('/'));
        return Future(() => false);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: vDefaultPadding,
          vertical: vDefaultPadding / 2,
        ),
        height: 320,
        child: InkWell(
          onTap: () async {
            await ActiveOrderService()
                .loadCurrentOrderData(context, widget.order.id);
            if (context.read<TimerDataProvider>().isRunning &&
                ActiveOrderService().isTimerActive(widget.order.id)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimerPage(
                          order: widget.order,
                        )),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetails(
                          order: widget.order,
                          loadingUnlocked: _showLoadingAddress,
                        )),
              );
            }
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: whiteColor,
                  boxShadow: const [vDefaultShadow],
                ),
              ),
              widget.order.cooperateOrderId != null
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        child: Column(
                          children: const [
                            corporateOrderbadge(btnTxt: "Corporate Order")
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Positioned(
                  top: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: vPadding,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.assignment,
                              color: iconcolors1,
                              size: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                widget.order.orderId,
                                style: normalBTxtDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: vPadding,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.alarm,
                              color: btPrimaryColor,
                              size: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.collectAt +
                                    " ${DateTimeFormatter().getFormattedTime(widget.order.logisticTime)}",
                                style: normalLightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: vPadding,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: iconcolors2,
                              size: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                DateTimeFormatter()
                                    .getFormattedDate(widget.order.logisticTime),
                                style: normalBTxtDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: vPadding,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.place,
                              color: iconcolors3,
                              size: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                AppLocalizations.of(context)!.pickupLocation,
                                style: lgLTextDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48, 0, 0, 8),
                        child: SizedBox(
                          // height: size.height,

                          width: size.width / 3 * 2,
                          child: Text(
                            (_showLoadingAddress || _adminEnableAddress)
                                ? widget.order.fromAddress
                                : OrderService().getPostalCode(
                                    widget.order.from, widget.order.fromAddress),
                            style: normalBTxtDark,
                          ),
                        ),
                      ),
                      Padding(
                        padding: vPadding,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.move_to_inbox,
                              color: iconcolors4,
                              size: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                widget.order.mass.toString() +
                                    'Kg ' +
                                    widget.order.orderSizeId.toString() +
                                    'm3',
                                style: normalBTxtDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              widget.order.status == 4
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                        child: Column(
                          children: const [Greenbadge()],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressOnTime() {
    if (mounted) {
      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (mounted) {
          setState(() {
            _showLoadingAddress = ActiveOrderService()
                .checkLogisticTime(widget.order.logisticTime!);
          });
        }
        if (_showLoadingAddress) {
          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() async {
    if (databaseEvent != null) {
      databaseEvent.cancel();
    }
    if (timer is Timer) {
      timer?.cancel();
    }
    super.dispose();
  }

  void _showAddressByAdmin()  {
    String orderId = widget.order.orderId;
    DatabaseReference databaseRef =
         FirebaseRealtimeDataBase().ref('orders/$orderId/full_address');
    databaseEvent = databaseRef.onValue.listen((DatabaseEvent event) {
      bool isEnabled = false;
      if (event.snapshot.exists && event.snapshot.value == true) {
        isEnabled = true;
      }
      if (mounted) {
        setState(() {
          _adminEnableAddress = isEnabled;
        });
      }
    });
  }
}
