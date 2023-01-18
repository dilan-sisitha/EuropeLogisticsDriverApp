import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:euex/components/cons.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:euex/screens/chat/widget/chatInput.dart';
import 'package:euex/screens/chat/widget/messageContent.dart';
import 'package:euex/services/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../components/networkStatus.dart';
import '../../providers/chatDataProvider.dart';
import '../../services/chatService.dart';
import '../home/home.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    this.launchedWithNotification = false,
    Key? key
  }) : super(key: key);
  final bool launchedWithNotification;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController listScrollController = ScrollController();
  @override
  void initState() {
   _scrollToEnd();
   _stopPushNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    var chatDataProvider = Provider.of<ChatDataProvider>(context, listen: false);
    _showMessageNotification();
    return WillPopScope(
      onWillPop:  () async {
        chatDataProvider.showNotification = true;
      if(widget.launchedWithNotification){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Home()));
        return false;
      }else{
       bool canPop= Navigator.canPop(context);
       if(canPop){
         Navigator.pop(context);
       }else{
         Navigator.pushReplacement(context,
             MaterialPageRoute(builder: (context) => Home()));
         return false;
       }
        return true;
      }
      },

      child: Scaffold(
          backgroundColor: bPrimaryColor,
          body:Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: const NetworkStatus(),
              ),
              chatAppBar(),
              Container(
                color: bPrimaryColor,
                child: Container(
                  height: 30,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                    color: whiteColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ValueListenableBuilder(
                                valueListenable: Hive.box<ChatMessage>('messages').listenable(),
                                builder: (context, Box<ChatMessage> chatBox, widget) {
                                  return ListView.builder(
                                    reverse: true,
                                    controller: listScrollController,
                                    itemCount:_sortedChat(chatBox).length,
                                    itemBuilder: (context, index) =>
                                        MessageContent(
                                          message: _sortedChat(chatBox)[index],
                                          listController: listScrollController,
                                        ),
                                  );
                                }
                            ),
                          ),
                        ),
                        ChatInput(listController: listScrollController),
                      ],
                    ),
                  )
              ),


            ],
          )
      ),
    );
  }

  AppBar chatAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bPrimaryColor,
      elevation: 0,
      title: Row(
        children: [
          const BackButton(),
          const CircleAvatar(
            backgroundImage: AssetImage("asset/images/man.png"),
          ),
          const SizedBox(width: vDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Logistics Support",
                style: TextStyle(fontSize: 16),
              ),

            ],
          )
        ],
      ),
    );
  }

  _scrollToEnd(){
    Future.delayed(Duration.zero,(){
      listScrollController.jumpTo(0.0);
    });

  }
  _showMessageNotification(){
    ChatDataProvider chatDataProvider = Provider.of<ChatDataProvider>(context, listen: true);
    bool canNotify = chatDataProvider.notifyUser;
    double width = MediaQuery.of(context).size.width;
    Future.delayed(Duration.zero,(){
    const maxPosition = 0.0;//listScrollController.position.maxScrollExtent;
    final currentPosition = listScrollController.offset;
    final difference = currentPosition-maxPosition;
    bool isWithinScrollLimit = difference<500;
    //when use sends an message
    if(chatDataProvider.userMessage ){
     listScrollController.jumpTo(maxPosition);
      Provider.of<ChatDataProvider>(context, listen: false).userMessage = false;
    }
    //when new message received
    if(canNotify){
      listScrollController.jumpTo(maxPosition);
      listScrollController.animateTo(
        maxPosition,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
      Provider.of<ChatDataProvider>(context, listen: false).reset();
        /*if(isWithinScrollLimit){
          listScrollController.jumpTo(maxPosition);
        }else{
          AwesomeDialog(
            context: context,
            dialogType: DialogType.NO_HEADER,
            animType: AnimType.BOTTOMSLIDE,
            desc: 'new message(s)',
            dismissOnBackKeyPress: true,
            width: (width/4)*2.5,
            autoDismiss: true,
            autoHide: const Duration(milliseconds: 1200),
            dismissOnTouchOutside: true,
            barrierColor: Colors.transparent,
            keyboardAware: false
          ).show();
          Provider.of<ChatDataProvider>(context, listen: false).reset();
        }*/
    }

    });
  }
  List<ChatMessage> _sortedChat(Box<ChatMessage> chatBox){
    List<ChatMessage> messages =  chatBox.values.toList();
    for (var message in messages) {
      if (!message.isSent && message.status!='viewed') {
         ChatService().updateMessageStatus(message.chatId, 'viewed');
      }
    }
    messages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return messages;

  }
  _stopPushNotifications() async
  {
    Future.delayed(Duration.zero, () {
      Provider.of<ChatDataProvider>(context, listen: false).showNotification=false;
    });
    await NotificationService().clearAllChatNotifications();
  }
}

