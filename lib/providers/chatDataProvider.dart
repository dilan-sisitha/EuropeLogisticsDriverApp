import 'package:flutter/material.dart';

class ChatDataProvider with ChangeNotifier{
  int _oldMessageCount = 0;
  int _newMessageCount = 0;

  bool _userMessage = false;

  bool _showNotification = true;

  bool get showNotification => _showNotification;

  set showNotification(bool value) {
    _showNotification = value;
    notifyListeners();
  }

  int get oldMessageCount => _oldMessageCount;

  int get newMessageCount => _newMessageCount;

  void updateMessageCount(int count){
    _oldMessageCount = _newMessageCount;
    _newMessageCount+=count;
    notifyListeners();
  }
   void reset(){
     _oldMessageCount = _newMessageCount;
     notifyListeners();
   }

   bool get userMessage => _userMessage;

  set userMessage(bool value) {
    _userMessage = value;
    notifyListeners();
  }

  bool get notifyUser{
    return _newMessageCount>oldMessageCount;
  }
}