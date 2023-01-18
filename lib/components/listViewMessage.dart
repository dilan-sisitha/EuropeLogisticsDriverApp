import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class ListViewMessage extends StatelessWidget {
  const ListViewMessage({
    required this.message,
    Key? key,
  }) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Text(
              message!,
              style: lgLTextDark,
            )),
      ),
    );
  }
}