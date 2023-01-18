import 'package:euex/screens/chat/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../providers/authProvider.dart';
import '../providers/chatDataProvider.dart';

class NotificationService{



  void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void requestAndroidPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
  }

  InitializationSettings get initializationSettings{

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    return InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );
  }

  clearAllChatNotifications()async{
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  NotificationDetails get platformSpecifics{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'live_chat',
      'live chat notification',
      channelDescription: 'display incoming chat messages',
      importance: Importance.max,
      priority: Priority.high,

      // ticker: 'ticker'
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails(threadIdentifier: 'live_chat');
    return const NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  }
  showMessageNotification(data,context,GlobalKey<NavigatorState> key)async
  {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async{
          key.currentState!.pushReplacement(
              MaterialPageRoute(builder: (context) =>const ChatPage()));
        });
    NotificationDetails platformChannelSpecifics = platformSpecifics;
    await flutterLocalNotificationsPlugin.show(
        0,
        data['title'],
        data['body'],
        platformChannelSpecifics,
    );
  }

  getLaunchedNotification(context)
  {
    try{

    }catch(e){
      return true;
    }
  }

}