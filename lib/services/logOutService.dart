import 'package:euex/helpers/firebaseAuthUser.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/chatService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class LogOutService {
  clearUserData() async {
    await _clearChatData();
    await SettingService().clearSharedPreferences();
    await Hive.box('driver_details').clear();
    try {
      await FirebaseAuthUser().signOut();
      await FirebaseMessaging.instance.deleteToken();
      await Workmanager().cancelAll();
    } catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
    }
  }

  _clearChatData()async{
    await Hive.box<ChatMessage>('messages').clear();
    await ChatService().deleteChatImages();
  }

}
