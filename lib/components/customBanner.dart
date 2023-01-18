import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';

class CustomBanner extends StatefulWidget {
  const CustomBanner(
      {required this.displayText, required this.success, Key? key})
      : super(key: key);
  final String displayText;
  final bool success;

  @override
  State<CustomBanner> createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  bool _showBanner = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showBanner = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _showBanner
        ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.success ? lightGreenColor : lightRedColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20)),
                    child: widget.success
                        ? const Icon(
                            Icons.done,
                            color: lightGreenColor,
                          )
                        : const Icon(
                            Icons.clear,
                            color: lightRedColor,
                          ),
                  ),
                  Text(widget.displayText)
                ],
              ),
            ))
        : const SizedBox();
  }
}
