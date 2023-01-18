import 'dart:async';
import 'dart:io';

import 'package:app_install_date/app_install_date.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:euex/database/firebasertRtDb.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ApplicationDataService {
  late String appInstalledDate;
  late String appUpdatedDate;
  late String? deviceModel;
  late String? deviceBrand;
  late bool gpsIsEnabled;
  late bool internetIsEnabled;

  updateAppData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DateTime date = await AppInstallDate().installDate;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      deviceBrand = androidInfo.brand;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.utsname.machine;
      deviceBrand = 'Apple';
    }

    appInstalledDate = date.toString();
    String appVersion = packageInfo.version;
    internetIsEnabled = await getNetworkStatus();

    Location location = Location();
    gpsIsEnabled = await location.serviceEnabled();

    final appDataDBRef =  FirebaseRealtimeDataBase().ref('/app_data');
    await appDataDBRef.update({
      'installed_date': appInstalledDate,
      'version': appVersion,
      'device_model': deviceModel,
      'device_brand': deviceBrand,
      'internet_status': internetIsEnabled,
      "gps_status": gpsIsEnabled
    });
     periodicGpsUpdate();
  }

  getOsVersion()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    }else if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      return iosInfo.systemVersion;
    }
  }
  Future<bool> getNetworkStatus() async {
    late bool isOnline;
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else {
        isOnline = false;
      }
      return isOnline;
    } on SocketException catch (e) {
      isOnline = false;
      return isOnline;
    }
  }

  periodicGpsUpdate()async{
    StreamSubscription<ServiceStatus> serviceStatusStream = Geolocator.getServiceStatusStream().listen((ServiceStatus status){});
    serviceStatusStream.onData((data) async{
      final appDataDBRef =  FirebaseRealtimeDataBase().ref('/app_data');
      Location location = Location();
      bool gpsStatus = await location.serviceEnabled();
      await appDataDBRef.update({"gps_status": gpsStatus});
    });

  }
}
