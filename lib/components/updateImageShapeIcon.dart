import 'dart:io';

import 'package:euex/components/fileImageShape.dart';
import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateImageShapeIcon extends StatefulWidget {
  final String imgSrc;
  String? imageError;
  final Function(File?) getImage;

  UpdateImageShapeIcon({
    Key? key,
    required this.imgSrc,
    this.imageError,
    required this.getImage,
  }) : super(key: key);

  @override
  State<UpdateImageShapeIcon> createState() => _UpdateImageShapeIconState();
}

class _UpdateImageShapeIconState extends State<UpdateImageShapeIcon> {
  File? imageFile;

  _getFromGallery() async {
    FocusScope.of(context).unfocus();
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1500,
      maxHeight: 1500,
    );
    if (pickedFile != null) {
      setState(() {
        widget.imageError = null;
        imageFile = File(pickedFile.path);
      });
    }
    widget.getImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: yPrimarytColor, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              )),
          child: ClipOval(
            child: imageFile == null
                ? FileImageShape(
                    imgURL: File(widget.imgSrc),
                    widthSize: 120,
                    heightSize: 120,
                  )
                : FileImageShape(
                    imgURL: File(imageFile!.path),
                    widthSize: 120,
                    heightSize: 120,
                  ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
                color: yPrimarytColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                )),
            child: IconButton(
                onPressed: () {
                  _getFromGallery();
                },
                icon: const Icon(Icons.add_a_photo,
                    color: Colors.black, size: 20)),
          ),
        ),
      ],
    );
  }
}
