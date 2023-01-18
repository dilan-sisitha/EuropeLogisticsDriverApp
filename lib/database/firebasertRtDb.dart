import 'package:euex/helpers/firebaseAuthUser.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/driverService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/environment.dart';

class FirebaseRealtimeDataBase {

  static final String firebaseDbUrl = Environment.config.realTimeDbUrl;

  FirebaseDatabase getDataBase() {

    FirebaseApp firebaseApp = Firebase.app();
    return FirebaseDatabase.instanceFor(
        app: firebaseApp, databaseURL: firebaseDbUrl);
  }

  DatabaseReference ref([ref = ''])  {
    final int? driverId = DriverService().driverId;
    return getDataBase().ref('drivers/${driverId.toString()}/$ref');
  }
}

