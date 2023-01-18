import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:euex/api/api.dart';
import 'package:euex/api/responseFormatter.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/models/invoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InvoiceService {
  bool checkInvoiceNotExists(orderId) {
    var invoiceBox = Hive.box<Invoice>('invoices');
    List existingInvoices = invoiceBox.values.where((element) {
      if (element.orderId == orderId) {
        return true;
      }
      return false;
    }).toList();
    return existingInvoices.isEmpty;
  }

  getInvoiceData() async {
    var response = await Api().getInvoices();
    if (response is HttpResponse && response.statusCode == 200 && response.data is List) {
      var invoices = List.from(response.data);
      var invoiceBox = Hive.box<Invoice>('invoices');
      for (var element in invoices) {
        if (checkInvoiceNotExists(element['order_id'])) {
          Invoice invoice = Invoice(
            orderId: element['order_id'],
            logisticDate: element['collection_time'],
            totalLoadingTime: element['total_durations']['total_loading_time'],
            totalUnloadingTime: element['total_durations']
                ['total_unloading_time'],
            amountForLoading: element['costs']['loading'],
            amountForUnloading: element['costs']['unloading'],
            invoice: element['invoice'],
            invoiceDownloadPath: null,
            isCooperate: element['is_coop_order'],
          );
          invoiceBox.add(invoice);
        }
      }
    }
  }

  saveInvoicePdf(base64String, fileName) async {
    try {
      String? downloadPath = await FileHandler().downloadDir;
      if (downloadPath != null) {
        String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
        Uint8List bytes = base64.decode(base64String);
        String path = "$downloadPath/$fileName""_""$uniqueId.pdf";
        File file = File(path);
        await file.writeAsBytes(bytes);
        return file.path;
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
    }
  }

  updateInvoicePath(path, index) {
    var invoiceBox = Hive.box<Invoice>('invoices');
    Invoice? invoice = invoiceBox.getAt(index);
    invoice?.invoiceDownloadPath = path;
    invoice?.save();
  }
}
