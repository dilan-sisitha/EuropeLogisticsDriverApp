import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class Linehr extends StatelessWidget {
  const Linehr({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: SizedBox(
        width: double.infinity,
        height: 1,
        child: DecoratedBox(decoration: BoxDecoration(color: grayColor)),
      ),
    );
  }
}
