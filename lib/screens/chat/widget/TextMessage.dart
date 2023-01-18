import 'package:euex/components/cons.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/chatService.dart';
import 'package:flutter/material.dart';

import '../../../helpers/dateTimeFormater.dart';

class TextMessage extends StatefulWidget {
  const TextMessage({required this.message, Key? key}) : super(key: key);

  final ChatMessage message;

  @override
  State<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  bool _translationLoading = false;
  final String currentLng = SettingService().currentLanguage;

  @override
  void initState() {
   /* if(!widget.message.isSent){
      print(widget.message.text);
      print("current language $currentLng");
      print("message lng "+widget.message.lng.toString());
      print("translated lng "+widget.message.translatedLng.toString());
      print("show translation "+widget.message.showTranslation.toString());
      print("\n");

    }*/
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthPercentage = width / 100;
    double chatBubbleWidth = widthPercentage * 50;
    return Container(
      decoration: BoxDecoration(
          // color: bPLightColor,
          // borderRadius: BorderRadius.circular(30),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: bPLightColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: widget.message.isSent
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: vDefaultPadding * 0.85,
                        vertical: vDefaultPadding / 2,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.message.isSent ? grayColor2 : bPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: widget.message.isSent
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Container(
                              alignment: widget.message.isSent
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: chatBubbleWidth),
                                child: Text(
                                  widget.message.text!,
                                  style: TextStyle(
                                    color: widget.message.isSent
                                        ? Colors.black
                                        : whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Container(
                              alignment: widget.message.isSent
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Text(
                                DateTimeFormatter().messageDateTime(
                                    widget.message.createdAt.toString(),
                                    widget.message.isSent),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: widget.message.isSent
                                      ? Colors.black54
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _showTranslation
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: vDefaultPadding * 0.85,
                              vertical: vDefaultPadding / 2,
                            ),
                            decoration: BoxDecoration(
                              color: bPLightColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(widget.message.translatedText!)
                    )
                        : Container()
                  ],
                ),
              ),
              widget.message.isSent
                  ? const SizedBox()
                  : !_showTranslationButton?
                  const SizedBox()
                  :InkWell(
                      focusColor: Colors.blue,
                      onTap: () async {
                        await _processTranslation();
                      },
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: _translationLoading
                              ? Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                      )),
                                )
                              : Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  child: const Opacity(
                                    opacity: 0.8,
                                    child: Image(
                                      height: 20,
                                      width: 20,
                                      image: AssetImage(
                                          "asset/images/translate.png"),
                                    ),
                                  ),
                                )),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  _processTranslation() async {
    bool show = !widget.message.showTranslation;
    if (_needToTranslate) {
      setState(() {
        _translationLoading = true;
      });
      await ChatService().translateText(widget.message, currentLng);
      show = true;
      setState(() {
        _translationLoading = false;
      });
    }
    await ChatService().translationStatusUpdate(widget.message.chatId, show);
  }

  bool get _showTranslation {
    return widget.message.showTranslation &&
        widget.message.translatedText != null;
  }
  bool get _showTranslationButton {
    return (widget.message.showTranslation || widget.message.lng != currentLng);
  }
  bool get _needToTranslate{
    return (widget.message.translatedText != null && widget.message.translatedLng != currentLng)
        ||(widget.message.translatedText ==null && widget.message.lng != currentLng);
  }
}
