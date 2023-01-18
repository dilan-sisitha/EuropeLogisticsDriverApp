import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:euex/components/button.dart';
import 'package:euex/components/customAlertDialog.dart';
import 'package:euex/components/customBanner.dart';
import 'package:euex/components/networkStatus.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/screens/uploadImages/widget/imagePickerUploadphotos.dart';
import 'package:euex/screens/uploadImages/widget/orderIdDropDown.dart';
import 'package:euex/services/imageUploadService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../chat/chatButton.dart';

GlobalKey<ImagePickerUploadImagesPageState> _imagePickerKey = GlobalKey();
GlobalKey<DropdownSearchState<String>> _dropDownKey = GlobalKey();

class UploadImages extends StatefulWidget {
  const UploadImages({Key? key}) : super(key: key);

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  File? imageFile;
  bool _isLoading = false;
  String? errorText;
  String? orderId;
  bool _showBanner = false;
  bool _isUploadSuccess = false;

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double appBarHeight = AppBar().preferredSize.height;
    double height = MediaQuery.of(context).size.height -
        appBarHeight -
        statusBarHeight;
    double deviceHeight = MediaQuery.of(context).size.height;
    double checkHeight = 670.0;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: const ChatButton(),
        backgroundColor: bPrimaryColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: const NetworkStatus(),
            ),
            AppBar(
              title: Text(
                AppLocalizations.of(context)!.uploadImages,
                style:
                    const TextStyle(fontFamily: "openSansB", color: whiteColor),
              ),
              elevation: 0,
              backgroundColor: bPrimaryColor,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: checkHeight > deviceHeight ? checkHeight : height,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60.0),
                          topRight: Radius.circular(60.0)),
                      color: whiteColor,
                    ),
                    child: Column(
                      children: [
                        heightSet,
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: AppLocalizations.of(context)!
                                  .pleaseSelectOrderId,
                              style: normalBTextDark,
                            ),
                          ),
                        ),
                        OrderIdDropDown(
                          dropDownKey: _dropDownKey,
                          getOrderId: (orderId) {
                            this.orderId = orderId;
                          },
                        ),
                        ImagePickerUploadImagesPage(
                          key: _imagePickerKey,
                          uploadedImg: (file) {
                            if (file != null) {
                              setState(() {
                                errorText = null;
                              });
                              imageFile = file;
                            } else {
                              imageFile = null;
                            }
                          },
                        ),
                        Container(
                          child: errorText != null
                              ? Text(errorText!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ))
                              : Container(),
                        ),
                        _showBanner
                            ? CustomBanner(
                                displayText: _isUploadSuccess
                                    ? AppLocalizations.of(context)!
                                        .imageUploadedSuccessfully
                                    : AppLocalizations.of(context)!
                                        .imageUploadFailed,
                                success: _isUploadSuccess)
                            : const SizedBox(),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(35, 35, 25, 20),
                            child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: _isLoading
                                      ? yPrimarytColorLoading
                                      : yPrimarytColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: () => _onUpload(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: _isLoading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              const SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                                height: 19.0,
                                                width: 19.0,
                                              ),
                                              const SizedBox(width: 7),
                                              Text(
                                                  AppLocalizations.of(context)!
                                                      .uploading,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'openSansB',
                                                    fontSize: 18.0,
                                                  ))
                                            ])
                                      : Text(
                                          AppLocalizations.of(context)!
                                              .uploadImage,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'openSansB',
                                            fontSize: 18.0,
                                          ),
                                        ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ));
  }

  Future<bool> _validate() async {
    String? error;
    bool valid = false;
    if (imageFile != null) {
      if (!FileHandler().isValidImageType(imageFile)) {
        error = AppLocalizations.of(context)!.imageMustBeOfFile.replaceAll(
            ':fileTypes', FileHandler.supportedImageTypes.join('|'));
      } else if (!await FileHandler().isValidFileSize(imageFile)) {
        error = AppLocalizations.of(context)!
            .pleaseUploadImageLessThan
            .replaceAll(':size', FileHandler.maxFileSize.toString());
      } else {
        valid = true;
      }
    } else {
      error = AppLocalizations.of(context)!.pleaseSelectAnImage;
    }
    setState(() {
      errorText = error;
    });
    return valid;
  }

  _onUpload() async {
    if (await _validate()) {
      if (!Provider.of<NetworkConnectivityProvider>(context, listen: false)
          .isOnline) {
        _showMyDialog(
            AppLocalizations.of(context)!.yourDeviceIsOffline,
            AppLocalizations.of(context)!.pleaseCheckYourInternetConnection,
            context);
      } else {
        setState(() {
          _isLoading = true;
        });
        bool success =
            await ImageUploadService().uploadAttachments(imageFile, orderId);

        if (success) {
          imageFile = null;
          _imagePickerKey.currentState?.setState(() {
            _imagePickerKey.currentState?.imageFile = null;
          });
          _dropDownKey.currentState?.changeSelectedItem('No Order Id');
          setState(() {
            _isUploadSuccess = true;
          });
        }
        setState(() {
          _showBanner = true;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showMyDialog(title, text, context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: title, body: text, btnTxt: AppLocalizations.of(context)!.ok);
      },
    );
  }
}
