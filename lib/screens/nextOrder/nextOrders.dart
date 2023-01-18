import 'dart:async';

import 'package:euex/components/button.dart';
import 'package:euex/components/cardWidgetThreeLineArrow.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/screens/nextOrder/widget/nextOrderDetails.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../chat/chatButton.dart';

class NextOrders extends StatefulWidget {
  const NextOrders({Key? key}) : super(key: key);

  @override
  State<NextOrders> createState() => _NextOrdersState();
}

class _NextOrdersState extends State<NextOrders> {
  Timer? timer;
  bool _loading = false;

  @override
  void initState() {
    _updateOrderData();
    _refreshOrders();
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
              AppLocalizations.of(context)!.nextOrders,
              style: const TextStyle(fontFamily: "openSansB"),
            ),
          ),
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
                  valueListenable: Hive.box<Order>('next_orders').listenable(),
                  builder: (context, orderBox, widget) {
                    return RefreshIndicator(
                      onRefresh: _refreshOrders,
                      child: orderBox.length == 0
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.noNextOrders,
                                  style: lgLTextDark,
                                )),
                              ),
                            )
                          : ListView.builder(
                              itemCount: orderBox.length,
                              itemBuilder: (context, index) =>
                                  CardWidgetWithArrowThreeTitles(
                                itemIndex: index,
                                order: orderBox.get(index),
                                press: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NextOrderDetails(
                                          order: orderBox.get(index),
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

  Future<void> _refreshOrders() async {
    await OrderService().getOrderData(orderType: 'next');
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
  }

  _updateOrderData() {
    Future.delayed(const Duration(seconds: 10), () {
      timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (mounted && context.read<NetworkConnectivityProvider>().isOnline) {
          await OrderService().getOrderData(orderType: 'next');
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
