import 'package:euex/components/cons.dart';
import 'package:euex/models/order.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchBox extends StatelessWidget {
  final Function(List<Order>?) filteredList;

  const SearchBox({
    required this.filteredList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 17.0, color: whiteColor),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchOrder,
          hintStyle: const TextStyle(color: btPrimaryColor),
          fillColor: whiteColor,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          prefixIcon: const Icon(
            Icons.search,
            color: whiteColor,
          ),
        ),
        onChanged: (text) {
          if (text.isNotEmpty) {
            filteredList(OrderService().searchOrder('completed_orders', text));
          } else {
            filteredList(null);
          }
        },
      ),
    );
  }
}
