import 'dart:async';

import 'package:euex/components/button.dart';
import 'package:euex/components/gpsStatus.dart';
import 'package:euex/components/lineSpacer.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/database/firebasertRtDb.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/order.dart';
import 'package:euex/screens/chat/chatButton.dart';
import 'package:euex/screens/currentOrder/currentOrders.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/collectionTime.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/cooperateOrder.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/deliveryLocationDetails.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/detailTabs.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/loadingUnloading/loadingEndBtn.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/loadingUnloading/loadingStartBtn.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/loadingUnloading/unloadingEndBtn.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/loadingUnloading/unloadingStartBtn.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/topPanel.dart';
import 'package:euex/screens/home/home.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:euex/services/clearanceDocService.dart';
import 'package:euex/services/orderService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  final bool loadingUnlocked;

  const OrderDetails(
      {required this.order, Key? key, this.loadingUnlocked = false})
      : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool _showLoadingAddressOnTime = false;
  bool _adminEnableAddress = false;
  dynamic databaseEvent;
  Timer? timer;
  @override
  void initState() {
    _showLoadingAddressOnTime =
        ActiveOrderService().checkLogisticTime(widget.order.logisticTime!);
    showUnloadingAddress();
    _showAddressByAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double appBarHeight = AppBar().preferredSize.height;
    double height = MediaQuery.of(context).size.height -
        appBarHeight -
        statusBarHeight;
    double deviceHeight = MediaQuery.of(context).size.height;
    double checkHeight = 670.0;
    return WillPopScope(
      onWillPop: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>const CurrentOrders()));
        return Future(() => false);
      },
      child: Scaffold(
        floatingActionButton: const ChatButton(),
        bottomNavigationBar: _bottomNavBar(),
        backgroundColor: whiteColor,
        body: Container(
          color: bPrimaryColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: const NetworkStatus(),
              ),
              const GpsStatus(),
              AppBar(
                title: Text(
                  AppLocalizations.of(context)!.orderDetails,
                  style:
                      const TextStyle(fontFamily: "openSansB", color: whiteColor),
                ),
                elevation: 0,
                backgroundColor: bPrimaryColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints:checkHeight > deviceHeight ? 
                    const BoxConstraints()
                   : BoxConstraints(
                     maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width,
                   ),
                    color: whiteColor,
                    child: Column(
                      children: [
                        TopPanel(
                          order: widget.order,
                          showDocs: _showPickUpLocation(),
                        ),
                        widget.order.status == 4 ? const Greenbadge() : Container(),
                        CollectionTime(logisticDate: widget.order.logisticTime),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Home(
                                      fromAddress: widget.order.fromAddress,
                                      toAddress: widget.order.toAddress,
                                      order: widget.order,
                                    );
                                  },
                                ),
                              );
                            },
                            child: DetailsTab(
                                titleText:
                                    AppLocalizations.of(context)!.pickupLocation,
                                subTitleText: (_showPickUpLocation())
                                    ? widget.order.fromAddress
                                    : OrderService().getPostalCode(
                                        widget.order.from,
                                        widget.order.fromAddress),
                                iconName: const Icon(
                                  Icons.location_on,
                                  color: iconcolors3,
                                ))),
                        const Linehr(),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Home(
                                      fromAddress: widget.order.fromAddress,
                                      toAddress: widget.order.toAddress,
                                      order: widget.order,
                                    );
                                  },
                                ),
                              );
                            },
                            child:DeliveryLocationDetails(
                                order: widget.order,
                                showLocation: _showPickUpLocation(),
                            )
                        ),
                        const Linehr(),
                        DetailsTab(
                            titleText: AppLocalizations.of(context)!.driverHelp,
                            subTitleText: widget.order.driverHelp
                                ? AppLocalizations.of(context)!
                                    .driverHelpIsRequested
                                : AppLocalizations.of(context)!
                                    .driverHelpIsNotRequested,
                            iconName: const Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                            )),
                        widget.order.cooperateOrderId != null
                            ? CooperateOrder(order: widget.order)
                            : Container(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  _bottomNavBar() {
    Order order = widget.order;
    String? orderStatus;
    return ValueListenableBuilder(
        valueListenable: Hive.box<ActiveOrder>('active_orders')
            .listenable(keys: ['currentStatus']),
        builder: (context, Box<ActiveOrder> box, widget) {
          if (box.containsKey(order.id.toString())) {
            orderStatus = box.get(order.id.toString())!.currentStatus;
          }
          List activeOrderIds = ActiveOrderService().currentlyActiveOrders(box);
          if (activeOrderIds.isNotEmpty && !activeOrderIds.contains(order.id)) {
            return const SizedBox();
          } else if (orderStatus == null) {
            return LoadingStartButton(order: order);
          } else if (orderStatus == ActiveOrderService.loadingStart) {
            return LoadingEndBtn(order: order);
          } else if (orderStatus == ActiveOrderService.loadingEnd) {
            return UnloadingStartButton(order: order);
          } else if (orderStatus == ActiveOrderService.unloadingStart) {
            return UnloadingEndBtn(order: order);
          }
          return const SizedBox();
        });
  }

  @override
  void dispose() {
    if (databaseEvent != null) {
      databaseEvent.cancel();
    }
    if (timer is Timer) {
      timer?.cancel();
    }
    super.dispose();
  }

  void showUnloadingAddress() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _showLoadingAddressOnTime = ActiveOrderService()
              .checkLogisticTime(widget.order.logisticTime!);
        });
      }
      if (_showLoadingAddressOnTime) {
        timer.cancel();
      }
    });
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

  bool _showPickUpLocation() {
    return _showLoadingAddressOnTime || widget.loadingUnlocked || _adminEnableAddress;
  }
}
