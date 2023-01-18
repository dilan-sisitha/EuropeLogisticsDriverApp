import 'package:euex/components/cons.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/models/invoice.dart';
import 'package:euex/services/invoiceService.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadIcon extends StatefulWidget {
  const DownloadIcon({required this.index, required this.invoice, Key? key})
      : super(key: key);
  final Invoice invoice;
  final int index;

  @override
  State<DownloadIcon> createState() => _DownloadIconState();
}

class _DownloadIconState extends State<DownloadIcon> {
  bool _isDownloading = false;
  bool _downloadSuccess = false;
  bool _invoiceExists = false;

  @override
  void initState() {
    _checkInvoiceExists;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () async {
          if (await Permission.storage.request().isGranted ) {
            if (widget.invoice.invoiceDownloadPath != null &&
                await _checkInvoiceExists) {
              await OpenFile.open(widget.invoice.invoiceDownloadPath);
            } else {
              await _downloadInvoice(widget.invoice.invoice);
            }
          }else{debugPrint('no permission');}
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 42,
                width: 42,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: yPrimarytColor,
                    ),
                    child: Icon(
                      _downloadSuccess || _invoiceExists
                          ? Icons.download_done_rounded
                          : Icons.download_rounded,
                      size: 25,
                    )),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 42,
                  width: 42,
                  child: _isDownloading
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.black12,
                        )
                      : const SizedBox(),
                ))
          ],
        ),
      ),
    );
  }

  _downloadInvoice(base64) async {
    setState(() {
      _isDownloading = true;
    });
    var response = await InvoiceService()
        .saveInvoicePdf(widget.invoice.invoice, widget.invoice.orderId);
    setState(() {
      _isDownloading = false;
    });
    if (response != null && await FileHandler().checkFileExists(response)) {
      setState(() {
        _downloadSuccess = true;
      });
      InvoiceService().updateInvoicePath(response, widget.index);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: GestureDetector(
          onTap: ()async{
            await OpenFile.open(widget.invoice.invoiceDownloadPath);
            },
            child: Text("File saved in $response")
        ),
      ));

      return response;
    }
  }

  Future<bool> get _checkInvoiceExists async {
    bool status;
    if (widget.invoice.invoiceDownloadPath != null) {
      status = await FileHandler()
          .checkFileExists(widget.invoice.invoiceDownloadPath);
    } else {
      status = false;
    }
    setState(() {
      _invoiceExists = status;
    });
    return status;
  }
}
