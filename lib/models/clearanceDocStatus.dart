import 'package:hive/hive.dart';

part 'clearanceDocStatus.g.dart';

@HiveType(typeId: 6)
class ClearanceDocStatus {
  @HiveField(0)
  int id;

  @HiveField(1)
  String orderId;

  @HiveField(2)
  String type;

  ClearanceDocStatus(
      {required this.id, required this.orderId, required this.type});
}
