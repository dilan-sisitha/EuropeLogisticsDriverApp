import 'dart:io';

import 'package:euex/api/api.dart';
import 'package:euex/api/responseFormatter.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/helpers/httpClient.dart';
import 'package:euex/models/driverData.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverService {
  Future<void> saveDriverData() async {
    var response = await Api().getDriverDetails();
    if (response is HttpResponse && response.statusCode == 200) {
      var driver = Map<String, dynamic>.from(response.data);
      await saveDriver(driver);
    }
  }

  saveDriver( driver) async {
    Box driverDetailsBox = Hive.box('driver_details');
      var driverImagePath =
        await saveDriverImages(driver['driver']['photo'], 'driver');
    var vanImagePath =
        await saveDriverImages(driver['driver']['van_photo'], 'van');
    DriverData driverData = DriverData(
      id: driver['driver']['id'],
      driverName: driver['driver']['driver_name'],
      driverImage: driverImagePath,
      vanImage: vanImagePath,
      userName: driver['user_name'],
      driverEmail: driver['email'],
      company: driver['driver']['driver_company'],
      companyAddress: driver['driver']['address'],
      contactNo: driver['driver']['phone'],
      vanMake: driver['driver']['van_make'],
      vanType: driver['driver']['van_type_id'].toString(),
      vanRegistration: driver['driver']['reg_no'],
      vanColor: driver['driver']['van_color'],
      carrierName: driver['driver']['carrier_name'],
      carrierEmail: driver['driver']['carrier_email'],
      carrierPhone: driver['driver']['carrier_phone'],
      bankAccount: driver['driver']['bank_account'],
      swiftCode: driver['driver']['swift_code'],
    );
    await driverDetailsBox.putAll(driverData.toMap());

  }

  saveDriverImages(driverData, fileName) async {
    try {
      var fileTimeStamp = driverData.substring(driverData.lastIndexOf("/") + 1);
      HttpClient httpClient = HttpClient();
      var path = await FileHandler()
          .savePath('driver', fileName + ' - ' + fileTimeStamp);
      bool fileAvailable = await FileHandler().checkFileExists(path);
      if (!fileAvailable) {
        await httpClient.download(driverData, path, authenticated: true);
      }
      return path;
    } catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
    }
  }
  getDriverImage(){
    var driverImage = getDriverDetails("driverImage");
   return driverImage!=null ?
   FileImage(
     File(driverImage),
   )
    : const AssetImage(
    'asset/images/profile-user.png',
    );
  }

  int? get driverId {
    final int? driverId = DriverService().getDriverDetails("driver_id");
    return driverId;
  }

  getDriverDetails(String key){
    var driverDetails = Hive.box('driver_details');
    if(driverDetails.containsKey(key)){
      return driverDetails.get(key);
    }
    return null;
  }
  addDriverData(key,value)async{
    var driverDetails = Hive.box('driver_details');
    await driverDetails.put(key,value);
  }
}
