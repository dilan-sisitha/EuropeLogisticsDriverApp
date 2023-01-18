import 'package:euex/components/button.dart';
import 'package:euex/components/cardWithArrow.dart';
import 'package:euex/components/gpsStatus.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/document.dart';
import 'package:euex/models/order.dart';
import 'package:euex/screens/chat/chatButton.dart';
import 'package:euex/services/orderDocumentService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';

class ViewDocuments extends StatefulWidget {
  const ViewDocuments({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  State<ViewDocuments> createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments> {
  var documentBox = Hive.box('order_documents');
  bool loading = false;

  @override
  void initState() {
    _refreshDocuments();
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
          const GpsStatus(),
          AppBar(
            title: Text(
              AppLocalizations.of(context)!.documentsList,
              style:
                  const TextStyle(fontFamily: "openSansB", color: whiteColor),
            ),
            elevation: 0,
            backgroundColor: bPrimaryColor,
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
                  valueListenable: Hive.box('order_documents')
                      .listenable(keys: [widget.order.id.toString()]),
                  builder: (context, docBox, widget) {
                    return RefreshIndicator(
                      onRefresh: _refreshDocuments,
                      child: _orderDocCount(docBox) == 0
                          ? SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                    child: loading
                                        ? Text(
                                      AppLocalizations.of(context)!
                                          .loadingDocuments,
                                            style: lgLTextDark,
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!
                                                .noDocumentsAvailable,
                                            style: lgLTextDark,
                                          )),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _orderDocCount(docBox),
                              itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CardWidgetWithArrow(
                                    documtName: _getDoc(index, docBox).name,
                                    press: () {
                                      var path = _getDoc(index, docBox).path;
                                      OpenFile.open(path);
                                    },
                                  )),
                            ),
                    );
                  })
            ],
          ))
        ],
      ),
    );
  }

  int _orderDocCount(docBox) {
    if (docBox.containsKey(widget.order.id.toString())) {
      List docs = docBox.get(widget.order.id.toString());
      return docs.length;
    }
    return 0;
  }

  Document _getDoc(index, docBox) {
    var docList = docBox.get(widget.order.id.toString());
    return docList[index];
  }

  Future<void> _refreshDocuments() async {
    setState(() {
      loading = true;
    });
    await OrderDocumentService().retrieveSingleOrderDocs(widget.order.id);
    setState(() {
      loading = false;
    });
  }
}
