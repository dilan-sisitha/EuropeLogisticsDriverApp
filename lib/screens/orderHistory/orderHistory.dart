import 'dart:async';

import 'package:euex/components/button.dart';
import 'package:euex/components/cardWidgetThreeLineArrow.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/screens/orderHistory/widget/oldOrderDetails.dart';
import 'package:euex/screens/orderHistory/widget/searchTextFeild.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../chat/chatButton.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Order> orderList = [];
  late int orderLength;
  Timer? timer;

  @override
  void initState() {
    OrderService().loadCompletedOrders();
    _updateOrderData();
    loadOrderList();
    orderLength = orderList.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: const ChatButton(),
      backgroundColor: bPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: const NetworkStatus(),
          ),
          AppBar(
            backgroundColor: bPrimaryColor,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context)!.orderHistory,
              style: const TextStyle(fontFamily: "openSansB"),
            ),
          ),
          SearchBox(
            filteredList: (value) => displaySearchResults(value),
          ),
          heightSet,
          Expanded(
              child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Container(
                  height: height,
                  margin: const EdgeInsets.only(top: 0),
                  decoration: const BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                ),
              ),
              ValueListenableBuilder<Box>(
                  valueListenable:
                      Hive.box<Order>('completed_orders').listenable(),
                  builder: (context, orderBox, widget) {
                    return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: orderLength == 0
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!
                                      .noCompletedOrders,
                                  style: lgLTextDark,
                                )),
                              ),
                            )
                          : ListView.builder(
                              itemCount: orderList.length,
                              itemBuilder: (context, index) =>
                                  CardWidgetWithArrowThreeTitles(
                                itemIndex: index,
                                order: orderList[index],
                                press: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OldOrderDetails(
                                          order: orderList[index],
                                        ),
                                      ));
                                },
                              ),
                            ),
                    );
                  })
            ],
          ))
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    await OrderService().getOrderData(orderType: 'completed');
    if (mounted) {
      setState(() {
        loadOrderList();
      });
    }
  }

  loadOrderList() {
    orderList = Hive.box<Order>('completed_orders').values.toList();
    orderList.sort((a, b) {
      var val = b.logisticTime!.compareTo(a.logisticTime!);
      return val;
    });
  }

  displaySearchResults(value) {
    if (value != null) {
      setState(() {
        orderList.clear();
        orderList = value;
      });
    } else {
      setState(() {
        loadOrderList();
      });
    }
  }

  _updateOrderData() {
    Future.delayed(const Duration(seconds: 10), () {
      timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (mounted && context.read<NetworkConnectivityProvider>().isOnline) {
          await OrderService().loadCompletedOrders();
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer is Timer) {
      timer?.cancel();
    }
    super.dispose();
  }
}
