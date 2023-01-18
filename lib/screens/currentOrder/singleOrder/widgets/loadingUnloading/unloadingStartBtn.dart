import 'dart:io';

import 'package:euex/helpers/photoPicker.dart';
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

class UnloadingStartButton extends StatelessWidget {
  const UnloadingStartButton({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ProcessOrderBtn(
      btnText: AppLocalizations.of(context)!.takeAPhotoToStartUnloading,
      icon: Icons.photo_camera,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext subContext) {
              return HelpDialog(
                title: AppLocalizations.of(context)!
                    .pleaseTakeAPhotoToStartUnloading,
                subTitle: AppLocalizations.of(context)!
                    .makeSurePhotoIllustratesLoading,
                image: 'asset/images/loaded-van-photo.jpg',
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
    File? unloadingStartImage = await PhotoPicker().cameraImage;
    timerService.reset();
    DateTime unloadingStartTime = DateTime.now();
    Provider.of<CurrentOrderDataProvider>(context, listen: false).currentOrder =
        order.id;
    if (unloadingStartImage != null) {
      ActiveOrderService().saveTime(order.id, unloadingStartImage,
          unloadingStartTime, ActiveOrderService.unloadingStart);
      await ActiveOrderService()
          .saveActiveOrderStatus(order.id, ActiveOrderService.unloadingStart);
      LocationService().updateOrderUnloadingGeoCodes(order.id, order.toAddress);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TimerPage(
              order: order,
            );
          },
        ),
      );
    }
  }
}
