import 'dart:io';

import 'package:euex/components/fileImageShape.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/driverData.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TopAreaWidget extends StatelessWidget {
  const TopAreaWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var driverDetails = Hive.box('driver_details');
    final panelHeightSize = MediaQuery.of(context).size.height * 0.15;

    return SizedBox(
      height: panelHeightSize,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            child: (driverDetails.containsKey("driverImage") )
                ? FileImageShape(
                    imgURL: File(driverDetails.get("driverImage")),
                    widthSize: 70,
                    heightSize: 70,
                  )
                : Image.asset(
              'asset/images/profile-user.png',
              fit: BoxFit.cover,
              width: 70,
              height: 70,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hello",
                    style: lgLTextDark,
                  ),
                  Flexible(
                    child: Text(
                      _getDriverName(driverDetails),
                      style: normalBTxtDarkFont,

                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  String _getDriverName(driverDetails){
    if(driverDetails.isNotEmpty){
      var driverName = driverDetails.get("driverName");
      var driverLastName = driverName.substring(driverName.lastIndexOf(" ") + 1);
      return driverLastName;
    }
    return '';
  }
}
