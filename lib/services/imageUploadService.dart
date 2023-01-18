import 'dart:io';

import 'package:euex/api/api.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:euex/helpers/imageEncoder.dart';
import 'package:euex/models/order.dart';
import 'package:euex/services/driverService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ImageUploadService {
  Future<bool> uploadAttachments(File? image, orderId) async {
    Map<String, dynamic> data = {};
    String base64string = await ImageEncoder().base64Encode(image!);
    final int? driverId = DriverService().driverId;
    data['driver_id'] = driverId;
    data['image'] = base64string;
    if (orderId != null && orderId != "No Order Id") {
      data['order_id'] = orderIdsToUploadImages![orderId];
    }
    var response = await Api().uploadAttachments(data);
    if (response['status'] == 'success') {
      return true;
    }
    return false;
  }

  Map<String, int>? get orderIdsToUploadImages {
    Map<String, int>? orderIds = {};
    List filteredCurrentOrderList = [];
    List currentOrderList = Hive.box<Order>('current_orders').values.toList();
    List completedOrderList =
        Hive.box<Order>('completed_orders').values.toList();
    DateTime now =
        DateTimeFormatter().dateHourMinutes(DateTime.now().toString());
    filteredCurrentOrderList = currentOrderList.where((element) {
      if (element.logisticTime != null) {
        DateTime logisticDate =
            DateTimeFormatter().dateHourMinutes(element.logisticTime);
        if (logisticDate.compareTo(now) == 0 || logisticDate.isAfter(now)) {
          return true;
        }
      }
      return false;
    }).toList();
    List totalOrders = List.from(filteredCurrentOrderList)
      ..addAll(completedOrderList);
    for (Order element in totalOrders) {
      orderIds[element.orderId] = element.id;
    }
    return orderIds;
  }

}
