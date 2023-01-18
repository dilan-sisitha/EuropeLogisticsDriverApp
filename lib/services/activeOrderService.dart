import 'dart:async';
import 'dart:io';
import 'package:euex/api/api.dart';
import 'package:euex/api/responseFormatter.dart';
import 'package:euex/database/firebasertRtDb.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/helpers/imageEncoder.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/TimerServiceProvider.dart';
import 'package:euex/providers/authProvider.dart';
import 'package:euex/providers/currentOrderDataProvider.dart';
import 'package:euex/screens/currentOrder/currentOrders.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/locationService.dart';
import 'package:euex/services/orderService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActiveOrderService {
  static const loadingStart = 'LOADING_START';
  static const loadingEnd = 'LOADING_END';
  static const unloadingStart = 'UNLOADING_START';
  static const unloadingEnd = 'UNLOADING_END';
  static StreamSubscription? _checkAdminAddress;

  Future saveTime(int id, File image, DateTime time, String type) async {
    String imageBase64string = await ImageEncoder().base64Encode(image);
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
    String filename = FileHandler().fileNameFromPath(image.path);
    var imagePath = await FileHandler().savePath('loading_photos', filename);
    await image.copy(imagePath);
    switch (type) {
      case loadingStart:
        {
          await ActiveOrderQuery().update(ActiveOrder(
              id: id,
              loadingStartTime: formattedTime,
              loadingStartImage: imagePath));
          saveLoadingStartTime(id, imageBase64string, formattedTime);
        }
        break;
      case loadingEnd:
        {
          await ActiveOrderQuery().update(ActiveOrder(
              id: id,
              loadingEndTime: formattedTime,
              loadingEndImage: imagePath));
          saveLoadingEndTime(id, imageBase64string, formattedTime);
          int? index = OrderService().getOrderIndex(id, 'current_orders');
          if (index != null) {
            Order? order = Hive.box<Order>('current_orders').getAt(index);
            order?.status = 4;
            order?.save();
          }
        }
        break;
      case unloadingStart:
        {
          await ActiveOrderQuery().update(ActiveOrder(
              id: id,
              unloadingStartTime: formattedTime,
              unloadingStartImage: imagePath));
          saveUnloadingStartTime(id, imageBase64string, formattedTime);
        }
        break;
      case unloadingEnd:
        {
          await ActiveOrderQuery().update(ActiveOrder(
              id: id,
              unloadingEndTime: formattedTime,
              unloadingEndImage: imagePath));
          saveUnloadingEndTime(id, imageBase64string, formattedTime);
        }
        break;
    }
  }

  Future saveLoadingStartTime(int id, String image, String time) async {
    var data = {
      'order_id': id,
      'loading_start': time,
      'loading_start_image': image
    };
    bool response = await updateTime(data);
    int status = response ? 1 : 0;
    await ActiveOrderQuery().updateValue(id, 'loadingStartStatus', status);
  }

  Future saveLoadingEndTime(int id, String image, String time) async {
    var data = {
      'order_id': id,
      'loading_end': time,
      'loading_end_image': image
    };

    bool response = await updateTime(data);
    int status = response ? 1 : 0;
    await ActiveOrderQuery().updateValue(id, 'loadingEndStatus', status);
  }

  Future saveUnloadingStartTime(int id, String image, String time) async {
    var data = {
      'order_id': id,
      'unloading_start': time,
      'unloading_start_image': image
    };

    bool response = await updateTime(data);
    int status = response ? 1 : 0;
    await ActiveOrderQuery().updateValue(id, 'unloadingStartStatus', status);
  }

  Future saveUnloadingEndTime(int id, String image, String time) async {
    var data = {
      'order_id': id,
      'unloading_end': time,
      'unloading_end_image': image
    };
    bool response = await updateTime(data);
    int status = response ? 1 : 0;
    await ActiveOrderQuery().updateValue(id, 'unloadingEndStatus', status);
  }

  onUnloadComplete(Order order, BuildContext context) async {
    Provider.of<CurrentOrderDataProvider>(context, listen: false).reset();
    await clearActiveOrderDetails(order.id);
    await OrderService().deleteCurrentOrder(order.id);
    Hive.box<Order>('completed_orders').add(order);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const CurrentOrders()),
        ModalRoute.withName('/'));
  }

  Future<bool> updateTime(data) async {
    var response = await Api().updateTime(data);
    if (response is HttpResponse && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  loadCurrentOrderData(BuildContext context, orderId) async {
    try {
      var timerDataProvider =
          Provider.of<TimerDataProvider>(context, listen: false);
      if (orderId != null && await ActiveOrderQuery().exits(orderId)) {
        ActiveOrder? activeOrder = await ActiveOrderQuery().find(orderId);
        resumeTimer(activeOrder!, timerDataProvider);
      }
    } catch (e, stacktrace) {
    }
  }

  resumeTimer(ActiveOrder activeOrder, TimerDataProvider timerDataProvider) {
    DateTime? lastActiveTime;
    String? status = ActiveOrderService().getActiveOrderStatus(activeOrder.id);
    if (status == ActiveOrderService.unloadingStart &&
        activeOrder.unloadingStartTime != null &&
        activeOrder.unloadingEndTime == null) {
      lastActiveTime = DateTime.parse(activeOrder.unloadingStartTime!);
    } else if (status == ActiveOrderService.loadingStart &&
        activeOrder.loadingStartTime != null &&
        activeOrder.loadingEndTime == null) {
      lastActiveTime = DateTime.parse(activeOrder.loadingStartTime!);
    }
    if (lastActiveTime != null) {
      Duration diff = DateTime.now().difference(lastActiveTime);
      if (timerDataProvider.isRunning) {
        timerDataProvider.reset();
      }
      timerDataProvider.initialOffset = diff;
      timerDataProvider.start();
    }
  }

  clearActiveOrderDetails(id) async {
    var activeOrderBox = Hive.box<ActiveOrder>('active_orders');
    if (activeOrderBox.containsKey(id.toString())) {
      return activeOrderBox.delete(id.toString());
    }
  }

  saveActiveOrderStatus(int id, String status) async {
    var activeOrderBox = Hive.box<ActiveOrder>('active_orders');
    activeOrderBox.put(
        id.toString(), ActiveOrder(id: id, currentStatus: status));
  }

  String? getActiveOrderStatus(int id) {
    var activeOrderBox = Hive.box<ActiveOrder>('active_orders');
    if (activeOrderBox.containsKey(id.toString())) {
      return activeOrderBox.get(id.toString())!.currentStatus;
    }
    return null;
  }

  List currentlyActiveOrders(Box<ActiveOrder> activeOrderBox) {
    List<int> activeOrderIds = [];
    for (var activeOrder in activeOrderBox.values) {
      if (activeOrder.currentStatus == ActiveOrderService.unloadingStart ||
          activeOrder.currentStatus == ActiveOrderService.loadingStart) {
        activeOrderIds.add(activeOrder.id);
      }
    }
    return activeOrderIds;
  }

  bool checkLogisticTime(String time) {
    var enablingDuration = SettingService().getSetting(SettingService.orderEnableDuration);
    if(enablingDuration is String){
        enablingDuration = int.parse(enablingDuration);
    }
    DateTime logisticTime = DateTimeFormatter().convertDateToLocalTime(time);
    DateTime showtime =
        logisticTime.subtract(Duration(minutes: enablingDuration));
    var nowTime = DateTime.now();
    return nowTime.isAfter(showtime);
  }

  checkCurrentOrderRadius(BuildContext context) async {
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      try {
        var activeOrderBox = Hive.box<ActiveOrder>('active_orders');
        List activeOrderIds = currentlyActiveOrders(activeOrderBox);
        int? orderId = activeOrderIds.isNotEmpty ? activeOrderIds.first : null;
        if (orderId != null) {
          bool isValidLoadingRadius = true;
          bool isValidUnloadingRadius = true;
          String? status = ActiveOrderService().getActiveOrderStatus(orderId);
          if (status == ActiveOrderService.loadingStart) {
            isValidLoadingRadius = await LocationService()
                .checkValidLoadingRadius(orderId, context);
          } else if (status == ActiveOrderService.unloadingStart) {
            isValidUnloadingRadius = await LocationService()
                .checkValidUnloadingRadius(orderId, context);
          }
          if (!isValidLoadingRadius) {
            var navKey = context.read<AuthProvider>().navigationKey;
            context.read<TimerDataProvider>().reset();
            saveActiveOrderStatus(orderId, loadingEnd);
            await OrderService().markDriversHelpNotEligible(orderId);
            navKey.currentState!.pushReplacement(
                MaterialPageRoute(builder: (context) => const CurrentOrders()));
          }
          if (!isValidUnloadingRadius) {
            var navKey = context.read<AuthProvider>().navigationKey;
            context.read<TimerDataProvider>().reset();
            saveActiveOrderStatus(orderId, unloadingEnd);
            await clearActiveOrderDetails(orderId);
            Order? order =
                OrderService().findOrderById(orderId, 'current_orders');
            await OrderService().deleteCurrentOrder(orderId);
            await OrderService().markDriversHelpNotEligible(orderId);
            if (order != null) {
              Hive.box<Order>('completed_orders').add(order);
            }
            navKey.currentState!.pushReplacement(
                MaterialPageRoute(builder: (context) => const CurrentOrders()));
          }
        }
      } catch (e, stack) {
        debugPrint(stack.toString());
      }
    });
  }

  bool isTimerActive(orderId) {
    String? status = getActiveOrderStatus(orderId);
    if (status == ActiveOrderService.unloadingStart ||
        status == ActiveOrderService.loadingStart) {
      return true;
    }
    return false;
  }

  showAddressByAdmin(orderId, StreamController<bool> controller)  {
    DatabaseReference databaseRef =
         FirebaseRealtimeDataBase().ref('orders/$orderId/full_address');
    _checkAdminAddress = databaseRef.onValue.listen((DatabaseEvent event) {
      bool isEnabled = false;
      if (event.snapshot.exists && event.snapshot.value == true) {
        isEnabled = true;
      }
      if (!controller.isClosed) {
        controller.add(isEnabled);
      }
    });
  }

  stopCheckAddressListener() {
    if (_checkAdminAddress != null) {
      _checkAdminAddress?.cancel();
    }
  }
}
