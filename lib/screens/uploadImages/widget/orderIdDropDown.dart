import 'package:dropdown_search/dropdown_search.dart';
import 'package:euex/services/imageUploadService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderIdDropDown extends StatefulWidget {
  final Function(String? orderI) getOrderId;
  final GlobalKey<DropdownSearchState<String>> dropDownKey;

  const OrderIdDropDown(
      {Key? key, required this.getOrderId, required this.dropDownKey})
      : super(key: key);

  @override
  State<OrderIdDropDown> createState() => OrderIdDropDownState();
}

class OrderIdDropDownState extends State<OrderIdDropDown> {
  String selectedText = 'No Order Id';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
      child: DropdownSearch<String>(
        key: widget.dropDownKey,
        popupItemBuilder: _customPopupItemBuilder,
        showSearchBox: true,
        items: orderIds,
        dropdownSearchDecoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.selectOrderId,
          hintText: "Order ID",
        ),
        maxHeight: height / 3 + 20,
        onChanged: (val) => widget.getOrderId(val),
        selectedItem: selectedText,
      ),
    );
  }

  Widget _customPopupItemBuilder(
      BuildContext context, dynamic item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        title: Text(item.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 102, 100, 100),
            )),
      ),
    );
  }

  List<String>? get orderIds {
    List<String>? orderIds = [];
    Map<String, int>? orderData = ImageUploadService().orderIdsToUploadImages;
    if (orderData != null && orderData.isNotEmpty) {
      orderIds = ImageUploadService().orderIdsToUploadImages?.keys.toList();
    }
    orderIds?.insert(0, 'No Order Id');
    return orderIds;
  }
}
