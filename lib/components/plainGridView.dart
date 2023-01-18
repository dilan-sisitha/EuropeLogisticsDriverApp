import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class gridView extends StatelessWidget {
  const gridView({
    Key? key,
    required this.title,
    required this.imageSrc,
    required this.press,
    required this.subTitle,
  }) : super(key: key);
  final String title, imageSrc, subTitle;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 20,
                color: const Color(0xFFB0CCE1).withOpacity(0.52))
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            press();
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    imageSrc,
                    width: size.width * 0.18,
                  ),
                ),
                Text(
                  title,
                  style: normalBTextgray,
                ),
                Text(
                  subTitle,
                  style: normalBTextgray,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
