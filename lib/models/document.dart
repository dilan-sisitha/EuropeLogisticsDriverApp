import 'package:hive/hive.dart';

part 'document.g.dart';

@HiveType(typeId: 1)
class Document {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String path;

  @HiveField(3)
  int orderId;

  @HiveField(4)
  String updatedAt;

  Document(
      {required this.id,
      required this.name,
      required this.path,
      required this.orderId,
      required this.updatedAt});
}
