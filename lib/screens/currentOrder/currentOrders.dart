import 'dart:async';
import 'package:euex/components/gpsStatus.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/listViewMessage.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/screens/chat/chatButton.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/singleOrderCard.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../home/home.dart';

class CurrentOrders extends StatefulWidget {
  const CurrentOrders({Key? key, this.refreshOrders = false}) : super(key: key);
  final bool refreshOrders;

  @override
  State<CurrentOrders> createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  bool _isLoading = false;
  Timer? timer;

  @override
  void initState() {
    if (OrderService().checkCurrentOrderUpdateTime(context)) {
      _refreshOrders();
    }else{
      _updateOrderData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>const Home()));
        return false;
      },
      child: Scaffold(
        floatingActionButton: const ChatButton(),
        backgroundColor: bPrimaryColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const NetworkStatus(),
            ),
            const GpsStatus(),
            AppBar(
              backgroundColor: bPrimaryColor,
              elevation: 0,
              title: Text(
                AppLocalizations.of(context)!.currentOrders,
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
                    valueListenable:
                        Hive.box<Order>('current_orders').listenable(),
                    builder: (context, orderBox, widget) {
                      return RefreshIndicator(
                        onRefresh: _refreshOrders,
                        child: _isLoading
                            ? ListViewMessage(
                                message:
                                    AppLocalizations.of(context)!.loadingOrders,
                              )
                            : orderBox.length == 0
                                ? ListViewMessage(
                                    message: AppLocalizations.of(context)!
                                        .noOngoingOrders,
                                  )
                                : ListView.builder(
                                    itemCount: orderBox.length,
                                    itemBuilder: (context, index) =>
                                        SingleOrderCard(
                                      itemIndex: index,
                                      order: orderBox.getAt(index),
                                    ),
                                  ),
                      );
                    })
              ],
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _refreshOrders() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    await OrderService().loadCurrentOrders(context);

      setState(() {
        _isLoading = false;
      });
    }
  }

  _updateOrderData() {
    Future.delayed(const Duration(seconds: 10), () {
      timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
        if (mounted && context.read<NetworkConnectivityProvider>().isOnline) {
          await OrderService().loadCurrentOrders(context);
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
