import 'package:euex/helpers/imageEncoder.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:workmanager/workmanager.dart';

class SchedulerService {
  ActiveOrderService activeOrderService = ActiveOrderService();

  updateFailedOrdersTime() async {
    List<ActiveOrder> activeOrders = await ActiveOrderQuery().getAll();
    for (ActiveOrder order in activeOrders) {
      if (order.loadingStartStatus == false &&
          order.loadingStartTime != null &&
          order.loadingStartImage != null) {
        String? base64string =
            await ImageEncoder().base64FromImagePath(order.loadingStartImage!);
        if (base64string != null) {
          await activeOrderService.saveLoadingStartTime(
              order.id, base64string, order.loadingStartTime!);
        }
      }
      if (order.loadingEndStatus == false &&
          order.loadingEndTime != null &&
          order.loadingEndImage != null) {
        String? base64string =
            await ImageEncoder().base64FromImagePath(order.loadingEndImage!);
        if (base64string != null) {
          await activeOrderService.saveLoadingEndTime(
              order.id, base64string, order.loadingEndTime!);
        }
      }
      if (order.unloadingStartStatus == false &&
          order.unloadingStartTime != null &&
          order.unloadingStartImage != null) {
        String? base64string = await ImageEncoder()
            .base64FromImagePath(order.unloadingStartImage!);
        if (base64string != null) {
          await activeOrderService.saveUnloadingStartTime(
              order.id, base64string, order.unloadingStartTime!);
        }
      }
      if (order.unloadingEndStatus == false &&
          order.unloadingEndTime != null &&
          order.unloadingEndImage != null) {
        String? base64string =
            await ImageEncoder().base64FromImagePath(order.unloadingEndImage!);
        if (base64string != null) {
          await activeOrderService.saveUnloadingEndTime(
              order.id, base64string, order.unloadingEndTime!);
        }
      }
    }
  }

  registerFailedOrderUpdateCron() async {

    Workmanager().registerPeriodicTask(
      'order.status',
      'update_time',
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}
