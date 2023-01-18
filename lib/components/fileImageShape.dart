import 'dart:io';

import 'package:flutter/material.dart';

class FileImageShape extends StatelessWidget {
  final File imgURL;
  final double widthSize;
  final double heightSize;

  const FileImageShape({
    Key? key,
    required this.imgURL,
    required this.widthSize,
    required this.heightSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Image.file(
        imgURL,
        fit: BoxFit.cover,
        width: widthSize,
        height: heightSize,
      ),
    );
  }
}
