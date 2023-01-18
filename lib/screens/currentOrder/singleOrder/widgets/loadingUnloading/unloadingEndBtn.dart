import 'dart:io';

import 'package:euex/helpers/photoPicker.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/TimerServiceProvider.dart';
import 'package:euex/providers/currentOrderDataProvider.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/proccessOrderBtn.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UnloadingEndBtn extends StatelessWidget {
  const UnloadingEndBtn({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ProcessOrderBtn(
      btnText: AppLocalizations.of(context)!.takeAPhotoToStopUnloading,
      icon: Icons.photo_camera,
      onPressed: () async {
        await _onSubmit(context);
      },
    );
  }

  _onSubmit(BuildContext context) async {
    var timerService = Provider.of<TimerDataProvider>(context, listen: false);
    File? unloadingEndImage = await PhotoPicker().cameraImage;
    if (timerService.isRunning) {
      timerService.reset();
    }
    timerService.reset();
    DateTime? unloadingEndTime;
    ActiveOrder? activeOrder = await ActiveOrderQuery().find(order.id);
    if (activeOrder != null && activeOrder.unloadingEndTime != null) {
      unloadingEndTime = DateTime.parse(activeOrder.unloadingEndTime!);
    } else {
      unloadingEndTime = DateTime.now();
    }
    Provider.of<CurrentOrderDataProvider>(context, listen: false).currentOrder =
        order.id;
    if (unloadingEndImage != null) {
      ActiveOrderService().saveTime(order.id, unloadingEndImage,
          unloadingEndTime, ActiveOrderService.unloadingEnd);
      Provider.of<CurrentOrderDataProvider>(context, listen: false)
          .orderStatus = ActiveOrderService.unloadingEnd;
      ActiveOrderService()
          .saveActiveOrderStatus(order.id, ActiveOrderService.unloadingEnd);
      ActiveOrderService().onUnloadComplete(order, context);
    }
  }
}
