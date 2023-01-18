import 'dart:async';
import 'dart:io';

import 'package:euex/components/button.dart';
import 'package:euex/components/gpsStatus.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/helpers/photoPicker.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/TimerServiceProvider.dart';
import 'package:euex/providers/currentOrderDataProvider.dart';
import 'package:euex/screens/currentOrder/currentOrders.dart';
import 'package:euex/screens/currentOrder/singleOrder/orderDetails.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../chat/chatButton.dart';

class TimerService extends InheritedWidget {
  const TimerService({Key? key, required this.service, required Widget child})
      : super(key: key, child: child);

  final TimerDataProvider service;

  @override
  bool updateShouldNotify(TimerService old) => service != old.service;
}

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final ActiveOrderService currentOrderService = ActiveOrderService();

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    var timerService = Provider.of<TimerDataProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    String? orderStatus =
        ActiveOrderService().getActiveOrderStatus(widget.order.id);
    Future.delayed(Duration.zero, () {
      if (!timerService.isRunning) {
        timerService.start();
        _onTimerStart();
      }
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const CurrentOrders()),
            ModalRoute.withName('/'));
        return false;
      },
      child: Scaffold(
        floatingActionButton: const ChatButton(),
        backgroundColor: whiteColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const NetworkStatus(),
            ),
            const GpsStatus(),
            AppBar(
              automaticallyImplyLeading: false,
              leadingWidth: 8,
              centerTitle: true,
              title: Text(
                (orderStatus == ActiveOrderService.unloadingStart ||
                        orderStatus == ActiveOrderService.unloadingEnd)
                    ? AppLocalizations.of(context)!.unloadingTimer
                    : AppLocalizations.of(context)!.loadingTimer,
                style: const TextStyle(
                  fontFamily: "openSansB",
                  color: Colors.black,
                ),
              ),
              elevation: 0,
              titleSpacing: 0,
              backgroundColor: whiteColor,
            ),
            // TimeArea(timerDataProvider: timerService),
            Center(
              child: AnimatedBuilder(
                animation: timerService, // listen to ChangeNotifier
                builder: (context, child) {
                  // this part is rebuilt whenever notifyListeners() is called
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: lightGreyColor,
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.2)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(timerService.elapsedTime,
                              style: const TextStyle(
                                  fontSize: 45, fontFamily: 'openSansB')),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      timerService.isRunning
                          ? ElevatedButton(
                              onPressed: () => _onSubmit(timerService),
                              child: Text(
                                !timerService.isRunning
                                    ? AppLocalizations.of(context)!.start
                                    : AppLocalizations.of(context)!.stop,
                                style: lgBTextDark,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: yPrimarytColor,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset(
                        'asset/images/sand-clock.png',
                        color: Colors.white.withOpacity(0.2),
                        colorBlendMode: BlendMode.modulate,
                        width: height / 4,
                        height: height / 4,
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _titleText() {
    if (context.read<CurrentOrderDataProvider>().orderStatus == null) {
    } else {}
  }

  _onSubmit(timerService) {
    if (!timerService.isRunning) {
      timerService.start();
      // _onTimerStart();
    } else {
      timerService.stop();
      _onTimerStop(timerService);
    }
  }

  _onTimerStart() async {
    String? status = ActiveOrderService().getActiveOrderStatus(widget.order.id);
    String? newStatus;

    switch (status) {
      case null:
        {
          newStatus = ActiveOrderService.loadingStart;
        }
        break;

      case ActiveOrderService.loadingEnd:
        {
          newStatus = ActiveOrderService.unloadingStart;
        }
        break;
    }
    if (newStatus != null) {
      await currentOrderService.saveActiveOrderStatus(
          widget.order.id, newStatus);
    }
  }

  _onTimerStop(timerService) async {
    String? newStatus;

    String? status = ActiveOrderService().getActiveOrderStatus(widget.order.id);
    switch (status) {
      case ActiveOrderService.loadingStart:
        {
          File? loadingStopImage = await PhotoPicker().cameraImage;
          if (timerService.isRunning) {
            timerService.reset();
          }
          DateTime loadingStopTime = DateTime.now();
          var formattedTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(loadingStopTime);
          await ActiveOrderQuery()
              .updateValue(widget.order.id, 'loadingEndTime', formattedTime);
          if (loadingStopImage != null) {
            newStatus = ActiveOrderService.loadingEnd;
            ActiveOrderService().saveTime(widget.order.id, loadingStopImage,
                loadingStopTime, ActiveOrderService.loadingEnd);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => OrderDetails(
                          order: widget.order,
                        )));
          }
        }
        break;
      case ActiveOrderService.unloadingStart:
        {
          //stops unloading
          File? unloadingStopImage = await PhotoPicker().cameraImage;
          if (timerService.isRunning) {
            timerService.reset();
          }
          DateTime unloadingStopTime = DateTime.now();
          var formattedTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(unloadingStopTime);
          await ActiveOrderQuery()
              .updateValue(widget.order.id, 'unloadingEndTime', formattedTime);
          if (unloadingStopImage != null) {
            currentOrderService.saveTime(widget.order.id, unloadingStopImage,
                unloadingStopTime, ActiveOrderService.unloadingEnd);
            newStatus = ActiveOrderService.unloadingEnd;
            currentOrderService.onUnloadComplete(widget.order, context);
          }
        }
        break;
    }

    if (newStatus != null) {
      await currentOrderService.saveActiveOrderStatus(
          widget.order.id, newStatus);
    }
  }
}
