import 'dart:ui';
import 'package:euex/api/api.dart';
import 'package:euex/api/responseFormatter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingService {

  static const orderEnableDuration = "upcoming_orders_lead_time";
  static const gpsReminderInterval = "gps_internet_reminder_interval";
  static const loadingTimerStopRadius = "loading_timer_stop_radius";
  static const unloadingTimerStopRadius = "unloading_timer_stop_radius";
  static const settingRefreshPeriod = "settings_refresh_period";

  saveAdminSettings() async {
    var response = await Api().getAdminSettings();
    if (response is HttpResponse && response.statusCode == 200 && response.data is Map) {
      var data = Map.from(response.data);
      var settingsBox = Hive.box('settings');
      data.forEach((key, value) {
        if(_settingsArr.keys.contains(key) && value!=null){
          settingsBox.put(key, value);
        }
      });
    }
  }

  /// app settings with default values
  Map get _settingsArr{
    return {
      orderEnableDuration:180,
      gpsReminderInterval:60,
      loadingTimerStopRadius:1000,
      unloadingTimerStopRadius:1000,
      settingRefreshPeriod:1
    };
  }

  getSetting(String key){
    var settingsBox = Hive.box('settings');
    if(settingsBox.containsKey(key)&& settingsBox.get(key)!=null){
      return settingsBox.get(key);
    }else{
      return _settingsArr[key];
    }
  }

  String get currentLanguage{
    Locale deviceLocale = window.locale;// or html.window.locale
    return deviceLocale.languageCode;
  }

  clearSharedPreferences()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
