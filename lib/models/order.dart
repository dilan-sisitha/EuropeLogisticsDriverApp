import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 0)
class Order extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String orderId;

  @HiveField(2)
  String from;

  @HiveField(3)
  String fromAddress;

  @HiveField(4)
  String to;

  @HiveField(5)
  String toAddress;

  @HiveField(6)
  int status;

  @HiveField(7)
  String? collectionTime;

  @HiveField(8)
  String? collectedTime;

  @HiveField(9)
  String? deliveryTime;

  @HiveField(10)
  String? deliveredTime;

  @HiveField(11)
  String? logisticTime;

  @HiveField(12)
  String? loadingStart;

  @HiveField(13)
  String? loadingEnd;

  @HiveField(14)
  String? unloadingStart;

  @HiveField(15)
  String? unloadingEnd;

  @HiveField(16)
  int mass;

  @HiveField(17)
  int orderSizeId;

  @HiveField(18)
  String? phoneOnCollect;

  @HiveField(19)
  String? phoneOnDrop;

  @HiveField(20)
  int? floorOnCollect;

  @HiveField(21)
  bool? liftOnCollect;

  @HiveField(22)
  int? floorOnDrop;

  @HiveField(23)
  bool? liftOnDrop;

  @HiveField(24)
  bool driverHelp;

  @HiveField(25)
  bool hasCustomsClearance;

  @HiveField(26)
  int? cooperateOrderId;

  @HiveField(27)
  String? qrCode;

  @HiveField(28)
  String? documentPickupPoint;

  @HiveField(29)
  String? documentReleasePoint;

  Order(
      {required this.id,
      required this.orderId,
      required this.from,
      required this.fromAddress,
      required this.to,
      required this.toAddress,
      required this.status,
      required this.collectionTime,
      required this.collectedTime,
      required this.deliveryTime,
      required this.deliveredTime,
      required this.logisticTime,
      required this.loadingStart,
      required this.loadingEnd,
      required this.unloadingStart,
      required this.unloadingEnd,
      required this.mass,
      required this.orderSizeId,
      required this.phoneOnCollect,
      required this.phoneOnDrop,
      required this.floorOnCollect,
      required this.liftOnCollect,
      required this.floorOnDrop,
      required this.liftOnDrop,
      required this.driverHelp,
      required this.hasCustomsClearance,
      required this.cooperateOrderId,
      required this.qrCode,
      required this.documentPickupPoint,
      required this.documentReleasePoint
      });
}
