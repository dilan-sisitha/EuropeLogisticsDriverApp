import 'package:euex/api/api.dart';
import 'package:euex/api/responseFormatter.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:euex/helpers/regexSearch.dart';
import 'package:euex/helpers/stringFormatter.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/currentOrderDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class OrderService {
  getOrderData({String orderType = 'all'}) async {
    var response = await Api().getOrders();
    if (response is HttpResponse && response.statusCode == 200) {
      var orders = Map<String, dynamic>.from(response.data);
      switch (orderType) {
        case 'current':
          {
            var currentOrdersBox = Hive.box<Order>('current_orders');
            await saveOrder(currentOrdersBox, orders, 'current');
          }
          break;
        case 'next':
          {
            var nextOrdersBox = Hive.box<Order>('next_orders');
            await saveOrder(nextOrdersBox, orders, 'next');
          }
          break;
        case 'completed':
          {
            var completedOrdersBox = Hive.box<Order>('completed_orders');
            await saveOrder(completedOrdersBox, orders, 'completed');
          }
          break;
        default:
          {
            var completedOrdersBox = Hive.box<Order>('completed_orders');
            var currentOrdersBox = Hive.box<Order>('current_orders');
            var nextOrdersBox = Hive.box<Order>('next_orders');
            await saveOrder(completedOrdersBox, orders, 'completed');
            await saveOrder(currentOrdersBox, orders, 'current');
            await saveOrder(nextOrdersBox, orders, 'next');
          }
          break;
      }
    }
  }

  saveOrder(hiveBox, orders, key) async {
    if (orders.containsKey(key)) {
      await hiveBox.clear();
      var orderList = List.from(orders[key]);
      orderList
          .sort((a, b) => a['logistic_time'].compareTo(b['logistic_time']));
      for (var element in orderList) {
        var order = Map<String, dynamic>.from(element);
        Order newOrder = Order(
            id: order['id'],
            orderId: order['orderid'],
            from: order['from'],
            fromAddress: order['from_address'],
            to: order['to'],
            toAddress: order['to_address'],
            status: order['status_id'],
            collectionTime: order['collection_time'],
            collectedTime: order['collected_time'],
            deliveryTime: order['delivery_time'],
            deliveredTime: order['delivered_time'],
            logisticTime: order['logistic_time'],
            loadingStart: order['loading_start'],
            loadingEnd: order['loading_end'],
            unloadingStart: order['unloading_start'],
            unloadingEnd: order['unloading_end'],
            mass: order['mass'],
            orderSizeId: order['order_size_id'],
            phoneOnCollect: order['phone_on_collect'],
            phoneOnDrop: order['phone_on_drop'],
            floorOnCollect: order['floor_on_collect'],
            liftOnCollect: order['lift_on_collect'] == 0 ? false : true,
            floorOnDrop: order['floor_on_drop'],
            liftOnDrop: order['lift_on_drop'] == 0 ? false : true,
            driverHelp: order['driver_help'] == 0 ? false : true,
            hasCustomsClearance:
            order['hasCustomClearance'] == 0 ? false : true,
            cooperateOrderId: order['cooperate_order_id'],
            qrCode: order['company_data'][0]['qr_code_url'],
            documentPickupPoint: order['collection_doc_pickup'],
            documentReleasePoint: order['delivery_doc_pickup']);
        hiveBox.add(newOrder);
      }
    }
    // hiveBox.close();
  }

  loadCurrentOrders(BuildContext context) async {
    var response = await Api().getOrders();
    if (response is HttpResponse && response.statusCode == 200) {
      var orders = Map<String, dynamic>.from(response.data);
      var currentOrdersBox = Hive.box<Order>('current_orders');
      await saveOrder(currentOrdersBox, orders, 'current');
      Provider.of<CurrentOrderDataProvider>(context, listen: false)
          .currentOrdersLastUpdatedAt = DateTime.now().millisecondsSinceEpoch;
    }
    return true;
  }
  loadCompletedOrders() async {
    var response = await Api().getOrders();
    if (response is HttpResponse && response.statusCode == 200) {
      var orders = Map<String, dynamic>.from(response.data);
      var completedOrdersBox = Hive.box<Order>('completed_orders');
      await saveOrder(completedOrdersBox, orders, 'completed');
    }
    return true;
  }

  searchOrder(orderType, searchText) {
    List<Order?> orderList = Hive.box<Order>(orderType).values.toList();
    searchText = searchText.trim();
    return orderList.where((element) {
      if (element!.orderId.contains(searchText) ||
          StringFormatter()
              .formatAddressForSearch(element.fromAddress)
              .contains(searchText.toLowerCase()) ||
          StringFormatter()
              .formatAddressForSearch(element.toAddress)
              .contains(searchText.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();
  }

  List<String>? get orderIdsToUploadImages {
    List<String>? orderIds = [];
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
    orderIds.add('No Order ID');
    for (Order element in totalOrders) {
      orderIds.add(element.orderId);
    }
    return orderIds;
  }

  bool checkInvoiceExists(orderId, type) {
    var orderBox = Hive.box<Order>(type);
    List existingOrders = orderBox.values.where((element) {
      if (element.orderId == orderId) {
        return true;
      }
      return false;
    }).toList();
    return existingOrders.isEmpty;
  }

  deleteCurrentOrder(id) async {
    var box = Hive.box<Order>('current_orders');
    final Map<dynamic, Order> currentOrdersMap = box.toMap();
    dynamic desiredKey;
    currentOrdersMap.forEach((key, value) {
      if (value.id == id) {
        desiredKey = key;
      }
    });
    if (desiredKey != null) {
      await box.deleteAt(desiredKey);
    }
  }

  int? getOrderIndex(id, type) {
    var box = Hive.box<Order>(type);
    final Map<dynamic, Order> ordersMap = box.toMap();
    dynamic desiredKey;
    ordersMap.forEach((key, value) {
      if (value.id == id) {
        desiredKey = key;
      }
    });
    return desiredKey;
  }

  _getCountryFromAddress(String address) {
    final startIndex = address.lastIndexOf(',');
    return address.substring(startIndex + 1).trim().toUpperCase();
  }

  getPostalCode(String address, String fullAddress) {
    String country = _getCountryFromAddress(address);
    return RegexSearch().getPostCode(fullAddress, country);
  }

  Order? findOrderById(int id, type) {
    Order? order;
    var orderBox = Hive.box<Order>(type);
    Iterable<Order>? orders = orderBox.values.where((item) => item.id == id);
    if (orders.isNotEmpty) {
      order = orders.first;
    }
    return order;
  }

  markDriversHelpNotEligible(orderId) async {
    var data = {
      'order_id': orderId,
    };
    await Api().markDriversHelpEligibility(data);
  }

  bool checkCurrentOrderUpdateTime(context) {
    bool canUpdate = false;
    int? lastUpdatedTimeStamp =
        Provider.of<CurrentOrderDataProvider>(context, listen: false)
            .currentOrdersLastUpdatedAt;

    if (lastUpdatedTimeStamp != null) {
      int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
      int diff = currentTimeStamp - lastUpdatedTimeStamp;
      if (diff > 15000) {
        canUpdate = true;
      }
    }
    return canUpdate;
  }
}
