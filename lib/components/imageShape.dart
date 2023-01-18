import 'package:flutter/material.dart';

class imageShape extends StatelessWidget {
  final String imgURL;
  final double widthSize;
  final double heightSize;

  const imageShape({
    Key? key,
    required this.imgURL,
    required this.widthSize,
    required this.heightSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Image.asset(
        imgURL,
        fit: BoxFit.cover,
        width: widthSize,
        height: heightSize,
      ),
    );
  }
}
