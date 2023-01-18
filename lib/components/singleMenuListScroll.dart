import 'package:euex/screens/accountSettings/settings.dart';
import 'package:euex/screens/currentOrder/currentOrders.dart';
import 'package:euex/screens/home/home.dart';
import 'package:euex/screens/invoices/invoicePage.dart';
import 'package:euex/screens/nextOrder/nextOrders.dart';
import 'package:euex/screens/orderHistory/orderHistory.dart';
import 'package:euex/screens/uploadImages/uploadImagesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'plainGridView.dart';

class MenuListScrollView extends StatelessWidget {
  const MenuListScrollView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              gridView(
                imageSrc: "asset/images/location.png",
                title: AppLocalizations.of(context)!.current,
                subTitle: AppLocalizations.of(context)!.orders,
                press: () async {
                  var returnStatus = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CurrentOrders(
                          refreshOrders: true,
                        );
                      },
                    ),
                  );
                  if (returnStatus == null || returnStatus == false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Home();
                        },
                      ),
                    );
                  }
                },
              ),
              gridView(
                imageSrc: "asset/images/next-order.png",
                title: AppLocalizations.of(context)!.next,
                subTitle: AppLocalizations.of(context)!.orders,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const NextOrders();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              gridView(
                imageSrc: "asset/images/history.png",
                title: AppLocalizations.of(context)!.orders,
                subTitle: AppLocalizations.of(context)!.history,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const OrderHistory();
                      },
                    ),
                  );
                },
              ),
              gridView(
                imageSrc: "asset/images/upload.png",
                title: AppLocalizations.of(context)!.upload,
                subTitle: AppLocalizations.of(context)!.photos,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const UploadImages();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              gridView(
                imageSrc: "asset/images/profile.png",
                title: AppLocalizations.of(context)!.account,
                subTitle: AppLocalizations.of(context)!.settings,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AccountSetting();
                      },
                    ),
                  );
                },
              ),
              gridView(
                imageSrc: "asset/images/ern-money.png",
                title: AppLocalizations.of(context)!.drivers,
                subTitle: AppLocalizations.of(context)!.help,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const InvoicesPage();
                      },
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
