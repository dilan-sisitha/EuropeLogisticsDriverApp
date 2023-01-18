import 'package:euex/components/greyCard.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CollectionTime extends StatelessWidget {
  final String? logisticDate;

  const CollectionTime({
    Key? key,
    required this.logisticDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GreyCard(
              textTop: AppLocalizations.of(context)!.collectionDate,
              subText: DateTimeFormatter().getFormattedDate(logisticDate),
              icon: const Icon(
                Icons.calendar_month,
                color: iconcolors2,
              )),
          GreyCard(
              textTop: AppLocalizations.of(context)!.collectionTime,
              subText: DateTimeFormatter().getFormattedTime(logisticDate),
              icon: const Icon(
                Icons.alarm,
                color: btPrimaryColor,
              )),
        ],
      ),
    );
  }
}
