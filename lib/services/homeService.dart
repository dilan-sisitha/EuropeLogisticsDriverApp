import 'package:euex/services/invoiceService.dart';

class HomeService {
  loadAppData() async {
    InvoiceService().getInvoiceData();
  }
}
