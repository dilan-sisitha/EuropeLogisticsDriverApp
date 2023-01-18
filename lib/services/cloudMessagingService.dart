import 'package:euex/database/firebasertRtDb.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../api/api.dart';
import '../providers/notification.dart';

class CloudMessaging {

  onTokenRefresh()async{
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) async{
      var data = {'fcm_token': fcmToken};
      await Api().saveFcmToken(data);

      FirebaseRealtimeDataBase().ref().update({
        'message_token':fcmToken
      });
    })
        .onError((err) {
    });

  }
  Future<String?> generateFcmToken() async {
    try {
      String? fcmToken;
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        fcmToken = await messaging.getToken();
        FirebaseRealtimeDataBase().ref().update({
          'message_token':fcmToken
        });
      }
      return fcmToken;
    } catch (e) {
      return null;
    }
  }

  void initMessaging() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await LocalNotification.showNotification(
            title: message.notification?.title.toString(),
            body: message.notification?.body.toString());
      }
    });
  }
}
