import 'package:euex/api/api.dart';
import 'package:euex/database/firebasertRtDb.dart';
import 'package:euex/helpers/firebaseAuthUser.dart';
import 'package:euex/helpers/permissionHandler.dart';
import 'package:euex/screens/home/home.dart';
import 'package:euex/services/cloudMessagingService.dart';
import 'package:euex/services/driverService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/authProvider.dart';
import 'applicationDataService.dart';
import 'chatService.dart';

class LoginService {

    processLogin(context, data,credentials,key) async
    {
    await saveAuthToken(data,credentials);
    sendFcmToken();
    initDriverStatus();
    await DriverService().saveDriverData();
    await PermissionHandler().requestPermission();
    DriverService().saveDriverData();
    ApplicationDataService().updateAppData();
    await AuthProvider().automaticLogOut(context);
    ChatService().onReceiveNewMessage(context,key);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()), (route) => false);
  }

  saveAuthToken(data,credentials) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', data['token']);
    prefs.setInt('driver_id', data['driver_id']);
    await DriverService().addDriverData("driver_id",  data['driver_id']);
    await DriverService().addDriverData("auth_token",  data['token']);
    await DriverService().addDriverData("user_name",  credentials['email']);
    await FirebaseAuthUser().signInWithCredentials();
  }

  sendFcmToken() async {
    final fcmToken = await CloudMessaging().generateFcmToken();
    if (fcmToken != null) {
      var data = {'fcm_token': fcmToken};
      await Api().saveFcmToken(data);
    }
  }

  void initDriverStatus()  {
    final databaseRef =  FirebaseRealtimeDataBase().ref('/disabled');
    databaseRef.get().then((snapshot) {
      if (!snapshot.exists) {
        databaseRef.set(false);
      }
    });
  }
}
