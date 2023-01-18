// full width van image enlarge
import 'package:flutter/material.dart';

class EnlargeFullWidthImge extends StatelessWidget {
  final String imgURL;

  const EnlargeFullWidthImge({
    Key? key,
    required this.imgURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imgeurl = imgURL;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GestureDetector(
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage(imgeurl), fit: BoxFit.cover)),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ImageDetailScreen(imgURL: imgeurl);
          }));
        },
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imgURL;

  const ImageDetailScreen({
    Key? key,
    required this.imgURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'Van Image',
            child: Image.asset(
              imgURL,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
