import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/helpers/photoPicker.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../providers/chatDataProvider.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.listController,
    Key? key}) : super(key: key);
  final ScrollController listController;
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController chatTextController = TextEditingController();
  File? image;
  bool _canSend = true;
  bool _imageUploading = false;

  @override

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthPercentage = width /100;
    double height = MediaQuery.of(context).size.height;
    double heightPercentage = height /100;
    return Container(
      padding:  EdgeInsets.only(
        bottom: heightPercentage * 2,
        top: heightPercentage * 1
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Padding(
              padding:EdgeInsets.symmetric(horizontal: widthPercentage* 1),
              child: _imageUploading?
               SizedBox(
                  height: widthPercentage*7,
                  width: widthPercentage*7,
                  child: const CircularProgressIndicator(
                    backgroundColor: darkPrimaryColor,
                  )):
              IconButton(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: darkPrimaryColor,
                  size: widthPercentage*7.5,
                ), onPressed: () async{

                await _sendImage();

              },
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: darkPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children:  [
                     SizedBox(
                      width: 15,
                      child: Container(color: Colors.black)),
                    Expanded(
                      child: TextField(
                        controller: chatTextController,
                        decoration: const InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                 //   const SizedBox(width: vDefaultPadding / 4),
                  ],
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(left: widthPercentage* 1),
              child: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: darkPrimaryColor,
                  size: widthPercentage*8,
                ), onPressed: () async{
                  if(context
                      .read<NetworkConnectivityProvider>()
                      .isOnline && _canSend){
                    setState(() {
                      _canSend = false;
                    });
                    await _sendMessage();
                    setState(() {
                      _canSend = true;
                    });
                  }
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    chatTextController.dispose();
    super.dispose();
  }

  _sendMessage() async{
    String message = chatTextController.text;
    if(chatTextController.text.isNotEmpty){
     await ChatService().sendMessage(message, context);
    }
    await _scrollToEnd();
    chatTextController.clear();
  }
  _sendImage() async{
    await _showChooseImageDialog(context);
    if(image is File){
      bool isValid = await _isValidImage();
      if(isValid){
        setState(() {
          _imageUploading = true;
          _canSend = false;
        });
        await ChatService().sendImage(image!);
        setState(() {
          _canSend = true;
          _imageUploading = false;
        });
      }
    }
    _scrollToEnd();

  }
  Future<bool> _isValidImage()async{
    bool valid = false;
    if (!FileHandler().isValidImageType(image)) {
      String message = AppLocalizations.of(context)!.imageMustBeOfFile.replaceAll(
          ':fileTypes',FileHandler().supportImageTypeMessage);
      _errorMessage(message).show();

    } else if (!await FileHandler().isValidFileSize(image,maxSize: 2)) {
    String message = AppLocalizations.of(context)!
        .pleaseSelectImageLessThan
        .replaceAll(':size', '2');
    _errorMessage(message).show();

    }else{
      valid = true;
    }
    return valid;
  }
  _scrollToEnd(){
    Provider.of<ChatDataProvider>(context, listen: false).userMessage = true;

  }
  Future<void> _showChooseImageDialog(BuildContext context) {
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
                    onTap: () async{
                     image = await PhotoPicker(quality: 25).galleryImage;
                     Navigator.pop(context);
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
                    onTap: () async{
                      image = await PhotoPicker(quality: 25).cameraImage;
                      Navigator.pop(context);
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
  AwesomeDialog _errorMessage(String message){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        animType: AnimType.BOTTOMSLIDE,
        title: '',
        desc: message,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        width: (width/4)*3,
        btnCancelOnPress:(){}
    );
  }
}


