import 'package:flutter/material.dart';

class CurrentOrderDataProvider extends ChangeNotifier {
  int? _currentOrder;
  String? _orderStatus;
  int? _currentOrdersLastUpdatedAt;

  int? get currentOrdersLastUpdatedAt => _currentOrdersLastUpdatedAt;

  set currentOrdersLastUpdatedAt(int? value) {
    _currentOrdersLastUpdatedAt = value;
    notifyListeners();
  }

  int? get currentOrder => _currentOrder;

  set currentOrder(int? value) {
    _currentOrder = value;
    notifyListeners();
  }

  String? get orderStatus => _orderStatus;

  set orderStatus(String? value) {
    _orderStatus = value;
    notifyListeners();
  }

  void reset() {
    _currentOrder = null;
    _orderStatus = null;
    notifyListeners();
  }
}
