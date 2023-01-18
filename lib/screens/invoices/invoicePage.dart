import 'package:euex/components/button.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/listViewMessage.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/invoice.dart';
import 'package:euex/screens/chat/chatButton.dart';
import 'package:euex/screens/invoices/widget/driverHelpDetailsCard.dart';
import 'package:euex/services/invoiceService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({Key? key}) : super(key: key);

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  bool _isLoading = false;

  @override
  void initState() {
    _reloadInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: const ChatButton(),
      backgroundColor: bPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: const NetworkStatus(),
          ),
          AppBar(
            backgroundColor: bPrimaryColor,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context)!.driverHelp,
              style: const TextStyle(fontFamily: "openSansB"),
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Container(
                  height: height,
                  margin: const EdgeInsets.only(top: 0),
                  decoration: const BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                ),
              ),
              ValueListenableBuilder<Box>(
                  valueListenable: Hive.box<Invoice>('invoices').listenable(),
                  builder: (context, invoiceBox, widget) {
                    return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: _isLoading?
                      const ListViewMessage(message: 'Loading invoices..'):
                      invoiceBox.length == 0
                          ? const ListViewMessage(message: 'No driver help invoices')
                          : ListView.builder(
                              itemCount: invoiceBox.length,
                              itemBuilder: (context, index) =>
                                  DriverHelpDetailsCard(
                                itemIndex: index,
                                invoice: invoiceBox.getAt(index),
                              ),
                            ),
                    );
                  })
            ],
          ))
        ],
      ),
    );
  }

  Future<void> _pullRefresh() async {
    await _reloadInvoices();

  }
  _reloadInvoices()async{
    setState(() {
      _isLoading = true;
    });
    await InvoiceService().getInvoiceData();
    setState(() {
      _isLoading = false;
    });
  }
}
