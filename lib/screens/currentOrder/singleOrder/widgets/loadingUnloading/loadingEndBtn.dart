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

class LoadingEndBtn extends StatelessWidget {
  const LoadingEndBtn({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ProcessOrderBtn(
      btnText: AppLocalizations.of(context)!.takeAPhotoToStopLoading,
      icon: Icons.photo_camera,
      onPressed: () async {
        await _onSubmit(context);
      },
    );
  }

  _onSubmit(BuildContext context) async {
    var timerService = Provider.of<TimerDataProvider>(context, listen: false);
    File? unloadingStartImage = await PhotoPicker().cameraImage;
    timerService.reset();
    DateTime? loadingEndTime;
    ActiveOrder? activeOrder = await ActiveOrderQuery().find(order.id);
    if (activeOrder!.loadingEndTime != null) {
      loadingEndTime = DateTime.parse(activeOrder.loadingEndTime!);
    } else {
      loadingEndTime = DateTime.now();
    }
    Provider.of<CurrentOrderDataProvider>(context, listen: false).currentOrder =
        order.id;
    if (unloadingStartImage != null) {
      ActiveOrderService().saveTime(order.id, unloadingStartImage,
          loadingEndTime, ActiveOrderService.loadingEnd);
      Provider.of<CurrentOrderDataProvider>(context, listen: false)
          .orderStatus = ActiveOrderService.loadingEnd;
      await ActiveOrderService()
          .saveActiveOrderStatus(order.id, ActiveOrderService.loadingEnd);
    }
  }
}
