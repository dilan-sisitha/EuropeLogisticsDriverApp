import 'package:euex/components/cons.dart';
import 'package:euex/config/environment.dart';
import 'package:euex/database/firebasertRtDb.dart';
import 'package:euex/models/activeOrder.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:euex/models/clearanceDocStatus.dart';
import 'package:euex/screens/chat/chatPage.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/chatService.dart';
import 'package:euex/services/driverService.dart';
import 'package:euex/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../helpers/firebaseAuthUser.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Stack(children: [
      FloatingActionButton(
        backgroundColor: darkPrimaryColor,
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatPage(),
              ));
        },
        heroTag: null,
        child: const Icon(Icons.message),
      ),
      ValueListenableBuilder(
        valueListenable: Hive.box<ChatMessage>('messages').listenable(),
        builder: (context, Box<ChatMessage> chatBox, widget)  {
          return (_unReadMessageCount(chatBox)!=0) ?
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
            ),
          ):
          const SizedBox();
        }
      ),
    ]);
  }
  int _unReadMessageCount(Box<ChatMessage>messageBox){
    int count = 0;
    // var messageBox = Hive.box<ChatMessage>('messages');
    List<ChatMessage> messages = messageBox.values.toList();
    for (var message in messages) {
      if(!message.isSent && message.status != 'viewed'){
        count+=1;
      }
    }
    return count;
  }
  _testResetData(context) async {
    OrderService().checkCurrentOrderUpdateTime(context);
    var box = await Hive.openBox<ActiveOrder>('active_orders');
    (await Hive.box<ClearanceDocStatus>('docs_collection')).clear();
    (await Hive.box('order_documents')).clear();
    await box.clear();
    await  ActiveOrderQuery().deleteAll();
    debugPrint('reset complete');
  }
}