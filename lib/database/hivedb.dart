import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:euex/models/clearanceDocStatus.dart';
import 'package:euex/models/document.dart';
import 'package:euex/models/driverData.dart';
import 'package:euex/models/geoData.dart';
import 'package:euex/models/invoice.dart';
import 'package:euex/models/order.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  initDataTables() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(OrderAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DocumentAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(InvoiceAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ActiveOrderAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(DriverDataAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(GeoDataAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(ClearanceDocStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }
    await Hive.openBox<Order>('completed_orders');
    await Hive.openBox<Order>('current_orders');
    await Hive.openBox<Order>('next_orders');
    await Hive.openBox<ActiveOrder>('active_orders');
    await Hive.openBox('order_documents');
    await Hive.openBox<Invoice>('invoices');
    await Hive.openBox('driver_details');
    await Hive.openBox<ClearanceDocStatus>('docs_collection');
    await Hive.openBox<ChatMessage>('messages');
    await Hive.openBox('settings');

  }
}
