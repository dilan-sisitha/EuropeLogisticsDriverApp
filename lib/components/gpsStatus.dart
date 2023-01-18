import 'package:app_settings/app_settings.dart';
import 'package:euex/providers/gpsStatusProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class GpsStatus extends StatelessWidget {
  const GpsStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GpsStatusProvider>(context, listen: false)
            .previousGpsState &&
        Provider.of<GpsStatusProvider>(context).gpsIsEnabled) {
      return Container();
    } else if (!Provider.of<GpsStatusProvider>(context).gpsIsEnabled) {
      Widget okButton = TextButton(
        child: const Text("OK"),
        onPressed: () async {
          AppSettings.openLocationSettings();
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );

      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      );

      AlertDialog alert = AlertDialog(
        // title: const Text("Location Access"),
        content: Text(AppLocalizations.of(context)!.enableLocationService),
        actions: [okButton, cancelButton],
      );
      Future.delayed(const Duration(seconds: 0), () async {
        bool modalVisible = ModalRoute.of(context)?.isCurrent ?? true;
        if (modalVisible) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              });
        }
      });
      return Container();
    } else {
      return Container();
    }
  }
}
