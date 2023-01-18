import 'package:euex/database/firebasertRtDb.dart';
import 'package:euex/screens/login/login.dart';
import 'package:euex/services/logOutService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  bool _sessionExpired = false;

  bool get sessionExpired => _sessionExpired;
  dynamic _navigationKey = null;

  dynamic get navigationKey => _navigationKey;

  set navigationKey(dynamic value) {
    _navigationKey = value;
    notifyListeners();
  }

  automaticLogOut(BuildContext context) {
    try {
      GlobalKey<NavigatorState> key = Provider.of<AuthProvider>(context, listen: false).navigationKey;
      final databaseRef = FirebaseRealtimeDataBase().ref('/disabled');
      databaseRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          if (event.snapshot.value == true) {
            Future.delayed(Duration.zero, () {
              LogOutService().clearUserData();
              key.currentState!.pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            });
          }
        }
      });
    } catch (e, stackTrace) {
    }
  }
}
