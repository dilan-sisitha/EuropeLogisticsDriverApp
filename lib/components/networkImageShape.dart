import 'package:flutter/material.dart';

class NetworkImageShape extends StatelessWidget {
  final String imgURL;
  final double widthSize;
  final double heightSize;

  NetworkImageShape({
    Key? key,
    required this.imgURL,
    required this.widthSize,
    required this.heightSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Image.network(
        imgURL,
        fit: BoxFit.cover,
        width: widthSize,
        height: heightSize,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}
