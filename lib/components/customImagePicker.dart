import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import 'cons.dart';

class CustomImagePicker extends StatefulWidget {
  CustomImagePicker(
      {required this.hintText,
      required this.getImage,
      this.imageError,
      Key? key})
      : super(key: key);

  final String hintText;
  final Function(File?) getImage;
  String? imageError;

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
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

  _removeImage() {
    setState(() {
      imageFile = null;
      widget.getImage(imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      widget.imageError = null;
      widget.getImage(imageFile);
    }
    return Container(
      child: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => _getFromGallery(),
                  child: Text(AppLocalizations.of(context)!.selectImage)),
            ),
            imageFile == null
                ? Text(
                    widget.hintText,
                    style: normalLightText,
                  )
                : Container(
                    height: 60.0,
                    width: 120.0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () => _removeImage(),
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ],
        ),
        widget.imageError != null
            ? Text(
                widget.imageError!,
                style: const TextStyle(color: Colors.red),
              )
            : Container()
      ]),
    );
  }
}
