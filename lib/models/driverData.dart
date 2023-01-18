import 'package:hive/hive.dart';

part 'driverData.g.dart';

@HiveType(typeId: 4)
class DriverData {
  @HiveField(0)
  int id;

  @HiveField(1)
  String driverName;

  @HiveField(2)
  String driverImage;

  @HiveField(3)
  String vanImage;

  @HiveField(4)
  String userName;

  @HiveField(5)
  String? driverEmail;

  @HiveField(6)
  String company;

  @HiveField(7)
  String companyAddress;

  @HiveField(8)
  String? contactNo;

  @HiveField(9)
  String vanMake;

  @HiveField(10)
  String vanType;

  @HiveField(11)
  String vanRegistration;

  @HiveField(12)
  String? vanColor;

  @HiveField(13)
  String? carrierName;

  @HiveField(14)
  String? carrierEmail;

  @HiveField(15)
  String? carrierPhone;

  @HiveField(16)
  String? bankAccount;

  @HiveField(17)
  String? swiftCode;

  DriverData(
      {required this.id,
      required this.driverName,
      required this.driverImage,
      required this.vanImage,
      required this.userName,
      this.driverEmail,
      required this.company,
      required this.companyAddress,
      this.contactNo,
      required this.vanMake,
      required this.vanType,
      required this.vanRegistration,
      this.vanColor,
      this.carrierName,
      this.carrierEmail,
      this.carrierPhone,
      this.bankAccount,
      this.swiftCode});

  Map<String,dynamic> toMap(){
   return {
      "id": id,
    "driverName": driverName,
    "driverImage": driverImage,
    "vanImage": vanImage,
    "userName":userName,
    "driverEmail": driverEmail,
    "company": company,
    "companyAddress": companyAddress,
    "contactNo": contactNo,
    "vanMake":vanMake,
    "vanType":vanType,
    "vanRegistration": vanRegistration,
    "vanColor": vanColor,
    "carrierName": carrierName,
    "carrierEmail":carrierEmail,
    "carrierPhone":carrierPhone,
    "bankAccount":bankAccount,
    "swiftCode": swiftCode,
    };
  }
}

