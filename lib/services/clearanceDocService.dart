import 'package:euex/models/clearanceDocStatus.dart';
import 'package:euex/models/order.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClearanceDocService {
  static String pickup = 'pickedUp';
  static String release = 'released';

  saveClearanceDocStatus(Order order, String type) async {
    var clearanceDocHiveBox = Hive.box<ClearanceDocStatus>('docs_collection');
    ClearanceDocStatus newDocsCollection =
        ClearanceDocStatus(id: order.id, orderId: order.orderId, type: type);
    clearanceDocHiveBox.add(newDocsCollection);
  }

  checkClearanceDocStatus(int orderId, String type) {
    var clearanceDocHiveBox =
        Hive.box<ClearanceDocStatus>('docs_collection').values;
    List pickupStatus = clearanceDocHiveBox.where((element) {
      if (element.id == orderId && element.type == type) {
        return true;
      }
      return false;
    }).toList();
    return pickupStatus.isNotEmpty;
  }
}
