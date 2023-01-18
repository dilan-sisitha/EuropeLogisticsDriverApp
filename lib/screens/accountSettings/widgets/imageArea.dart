import 'dart:io';

import 'package:euex/components/fileImageShape.dart';
import 'package:flutter/material.dart';

class SettingsImage extends StatelessWidget {
  String imgUrl;

  SettingsImage({
    required this.imgUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: FileImageShape(
        imgURL: File(imgUrl),
        widthSize: 90,
        heightSize: 90,
      ),
    );
  }
}
