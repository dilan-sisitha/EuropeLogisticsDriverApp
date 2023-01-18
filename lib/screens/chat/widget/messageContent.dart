import 'package:euex/components/cons.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:euex/providers/chatDataProvider.dart';
import 'package:euex/screens/chat/widget/MessageStatusDot.dart';
import 'package:euex/screens/chat/widget/PictureMessage.dart';
import 'package:euex/screens/chat/widget/TextMessage.dart';
import 'package:euex/services/chatService.dart';
import 'package:euex/services/driverService.dart';
import 'package:euex/services/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageContent extends StatefulWidget {
  const MessageContent({
    Key? key,
    required this.message,
    required this.listController,
  }) : super(key: key);
  final ChatMessage message;
  final ScrollController listController;
  @override
  State<MessageContent> createState() => _MessageContentState();
}

class _MessageContentState extends State<MessageContent> {
  @override
  void initState() {
   // _markMessageAsRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: widget.message.isSent
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.message.isSent) ...[
            const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage("asset/images/man.png"),
              backgroundColor: darkPrimaryColor,
            ),
            const SizedBox(width: 20 / 2),
          ],
          messageContent(widget.message),
          const SizedBox(width: 20 / 2),
          Column(
            children: [
              if (widget.message.isSent) ...[
                CircleAvatar(
                  radius: 12,
                  backgroundImage: DriverService().getDriverImage(),
                  backgroundColor: grayColor2,
                ),
                const SizedBox(height: 5),
                MessageStatusDot(status: widget.message.status)
              ],
            ],
          ),

          //const SizedBox(width: 20 / 2),
        ],
      ),
    );
  }

  Widget messageContent(ChatMessage message) {
    switch (message.contentType) {
      case 'text':
        return TextMessage(message: message);
      case 'image':
        return PictureMessage(message: message);
      default:
        return const Center(child: Text('invalid content'));
    }
  }

  _markMessageAsRead() async{
    if (!widget.message.isSent && widget.message.status!='viewed') {
      await ChatService().updateMessageStatus(widget.message.chatId, 'viewed');
    }

  }

}
