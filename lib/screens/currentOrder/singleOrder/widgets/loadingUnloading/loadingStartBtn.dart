import 'dart:io';

import 'package:euex/helpers/photoPicker.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/TimerServiceProvider.dart';
import 'package:euex/providers/currentOrderDataProvider.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/helpDialog.dart';
import 'package:euex/screens/currentOrder/singleOrder/widgets/proccessOrderBtn.dart';
import 'package:euex/screens/timerPage/timerPage.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:euex/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LoadingStartButton extends StatelessWidget {
  const LoadingStartButton({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ProcessOrderBtn(
      btnText: AppLocalizations.of(context)!.takeAPhotoToStart,
      icon: Icons.photo_camera,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext subContext) {
              return HelpDialog(
                title: AppLocalizations.of(context)!
                    .pleaseTakeAPhotoBeforeLoadingStart,
                subTitle: AppLocalizations.of(context)!
                    .makeSurePhotoIllustratesLoading,
                image: 'asset/images/empty-van-photo.jpg',
                onClose: () async {
                  await _onSubmit(context);
                },
              );
            });
      },
    );
  }

  _onSubmit(BuildContext context) async {
    var timerService = Provider.of<TimerDataProvider>(context, listen: false);
    File? loadingStartImage = await PhotoPicker().cameraImage;
    timerService.reset();
    if (loadingStartImage != null) {
      DateTime loadingStartTime = DateTime.now();
      Provider.of<CurrentOrderDataProvider>(context, listen: false)
          .currentOrder = order.id;
      await ActiveOrderQuery().create(ActiveOrder(id: order.id));
      LocationService().updateOrderLoadingGeoCodes(order.id, order.fromAddress);
      ActiveOrderService().saveTime(order.id, loadingStartImage,
          loadingStartTime, ActiveOrderService.loadingStart);
      await ActiveOrderService()
          .saveActiveOrderStatus(order.id, ActiveOrderService.loadingStart);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (subContext) {
            return TimerPage(
              order: order,
            );
          },
        ),
      );
    }
  }
}
