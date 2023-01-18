import 'package:euex/components/cons.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/clearanceDocStatus.dart';
import 'package:euex/screens/notification/notifications.dart';
import 'package:euex/services/clearanceDocService.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';


class NotificatioButton extends StatelessWidget {
  const NotificatioButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: FloatingActionButton(
        backgroundColor: bPrimaryLightColor,
        child: const Icon(Icons.notifications),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const Notifications();
              },
            ),
          );
        },
        heroTag: null,
      ),
    );
  }
}

class yElevatedBtn extends StatelessWidget {
  final String btnName;

  const yElevatedBtn({
    required this.btnName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        btnName,
        style: normalBTextDark,
      ),
      style: ElevatedButton.styleFrom(
        primary: yPrimarytColor,
      ),
    );
  }
}

class corporateOrderbadge extends StatelessWidget {
  final String btnTxt;

  const corporateOrderbadge({
    Key? key,
    required this.btnTxt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: bPrimaryLightColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(22), topRight: Radius.circular(22)),
      ),
      //color: bPrimaryLightColor,
      child: Text(
        btnTxt,
        style: normalWBoldText,
      ),
    );
  }
}

//button yellow
class buttonYellow extends StatelessWidget {
  final String btnText;
  final Function press;

  const buttonYellow({
    Key? key,
    required this.btnText,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: yPrimarytColor),
      child: Text(
        btnText,
        style: normalBTextgray,
      ),
      onPressed: () {
        press();
      },
    );
  }
}

//bottom bar button
class bottmBarBtn extends StatelessWidget {
  final String btnText;
  final Function press;

  const bottmBarBtn({
    Key? key,
    required this.btnText,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: yPrimarytColor,
      child: ElevatedButton.icon(
        icon: Icon(
          Icons.photo_camera,
          color: Colors.black,
        ),
        label: Text(
          btnText,
          style: normalBTxtDark,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          shadowColor: Colors.transparent,
          primary: yPrimarytColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          press();
        },
      ),
    );
  }
}

class Greenbadge extends StatelessWidget {
  const Greenbadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(22), topRight: Radius.circular(22)),
        ),
        child: Text(
          AppLocalizations.of(context)!.orderProcessing,
        ),
      ),
    );
  }
}

//button yellow2
class ButtonYellow2 extends StatelessWidget {
  final String btnText;
  final Function press;

  const ButtonYellow2({
    Key? key,
    required this.btnText,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: yPrimarytColor),
      child: Text(
        btnText,
        style: DarkWieghtFont,
      ),
      onPressed: () {
        press();
      },
    );
  }
}
