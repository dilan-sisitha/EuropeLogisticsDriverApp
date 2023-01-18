import 'package:hive/hive.dart';

part 'invoice.g.dart';

@HiveType(typeId: 2)
class Invoice extends HiveObject {
  @HiveField(0)
  String orderId;

  @HiveField(1)
  String logisticDate;

  @HiveField(2)
  String totalLoadingTime;

  @HiveField(3)
  String totalUnloadingTime;

  @HiveField(4)
  String amountForLoading;

  @HiveField(5)
  String amountForUnloading;

  @HiveField(6)
  String invoice;

  @HiveField(7)
  String? invoiceDownloadPath;

  @HiveField(8)
  bool isCooperate;

  Invoice(
      {required this.orderId,
      required this.logisticDate,
      required this.totalLoadingTime,
      required this.totalUnloadingTime,
      required this.amountForLoading,
      required this.amountForUnloading,
      required this.invoiceDownloadPath,
      required this.invoice,
      required this.isCooperate});
}
