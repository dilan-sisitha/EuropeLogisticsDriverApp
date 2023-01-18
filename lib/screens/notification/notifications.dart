import 'package:euex/components/gpsStatus.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bPrimaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: const NetworkStatus(),
          ),
          const GpsStatus(),
          AppBar(
            title: const Text(
              "Notifications",
              style: TextStyle(fontFamily: "openSansB", color: whiteColor),
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
              Center(
                child: Text(
                  "No Notifications",
                  style: normalLightText,
                  textAlign: TextAlign.center,
                ),
              )
              // ListView.builder(
              //     itemCount: notificationdetails.length,
              //     itemBuilder: (context, index) => NotificationList(
              //           itemIndex: index,
              //           notificationdetails: notificationdetails[index],
              //         )),
            ],
          ))
        ],
      ),
    );
  }
}
