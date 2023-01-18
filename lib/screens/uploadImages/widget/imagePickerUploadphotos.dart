import 'dart:io';

import 'package:euex/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUploadImagesPage extends StatefulWidget {
  const ImagePickerUploadImagesPage({required this.uploadedImg, Key? key})
      : super(key: key);
  final Function(File?) uploadedImg;

  @override
  State<ImagePickerUploadImagesPage> createState() =>
      ImagePickerUploadImagesPageState();
}

class ImagePickerUploadImagesPageState
    extends State<ImagePickerUploadImagesPage> {
  File? imageFile;

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.chooseOption,
              style: const TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text(AppLocalizations.of(context)!.gallery),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text(AppLocalizations.of(context)!.camera),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: grayColor2,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Card(
                    color: grayColor2,
                    child: (imageFile == null)
                        ? Center(
                            child:
                                Text(AppLocalizations.of(context)!.chooseImage))
                        : Image.file(File(imageFile!.path)),
                  ),
                ),
                MaterialButton(
                  textColor: Colors.white,
                  color: bPrimaryLightColor,
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                  child:
                      Text(AppLocalizations.of(context)!.pleaseSelectAnImage),
                )
              ],
            ),
            imageFile != null
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          imageFile = null;
                        });
                        widget.uploadedImg(null);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red[700]!,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      widget.uploadedImg(File(pickedFile.path));
    }
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      widget.uploadedImg(File(pickedFile.path));
    }
    Navigator.pop(context);
  }
}
