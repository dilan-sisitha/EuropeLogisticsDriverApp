import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euex/api/api.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:euex/providers/chatDataProvider.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/notificationService.dart';
import 'package:euex/storage/firebaseCoudStorage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:euex/api/responseFormatter.dart' as http_response;
import 'package:provider/provider.dart';
import '../database/firebaseFirestoreDb.dart';

class ChatService{
  get order => null;

  Future updateInbox(GlobalKey<NavigatorState> key) async{
    await loadOutBox();
    CollectionReference messageRef = await FirebaseCloudFirestore().messageCollectionRef;
    messageRef.where("user_type", isEqualTo: "franchise").snapshots()
        .listen((event) async {
          int count = 0;
      for (var change in event.docChanges) {
        if(change.type == DocumentChangeType.added &&
            !Hive.box<ChatMessage>('messages').containsKey(change.doc.id)){
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          data['created_at'] = (data['created_at'] as Timestamp ).toDate();
          if(data['content_type']=='image'){
            String? savePath = await FirebaseCloudStorage().downloadChatImage(data['message']);
            if(savePath!=null){
              data['FilePath'] = savePath;
            }
          }
          if(!data.containsKey('status')){
            data['status'] ='notViewed';
          }
          await saveMessageLocally(data, change.doc.id);
          if(data['status']!='viewed'){
            count++;
          }
        }
      }
      if(count!=0){
        Provider.of<ChatDataProvider>(key.currentState!.context, listen: false).updateMessageCount(count);
        //showNewMessageNotification();
      }
    });

  }
  sendMessage(String  message,BuildContext context)async{
    {
      final String currentLng = SettingService().currentLanguage;
      var messageData = {
        "message": message,
        "lng": currentLng,
        "created_at": DateTime.now(),
        "content_type": "text",
        "user_type": "driver",
        "translated_text": null,
        "translated_lng": null
      };
      String? chatId = await FirebaseCloudFirestore().addMessage(messageData);
      messageData['status']= chatId!=null? 'sent':'notSent';
      await saveMessageLocally(messageData, chatId);
    }
  }
  saveMessageLocally(messageData,chatId)async{
    if(!Hive.box<ChatMessage>('messages').containsKey(chatId)){
      ChatMessage message = ChatMessage(
        createdAt: messageData['created_at'],
        contentType: messageData['content_type'],
        isSent: messageData['user_type']=='driver'?true:false,
        text: messageData['message'],
        chatId: chatId,
        status:messageData['status'],
        imageUrl: messageData['FilePath'],
        lng:  messageData['lng'],
        translatedLng: messageData['translated_lng'],
        translatedText: messageData['user_type']=='franchise'? messageData['translated_text']:null,
      );
      await Hive.box<ChatMessage>('messages').put(chatId,message);
    }
  }
  updateMessageStatus(String chatId,String status) async{
    var messageBox = Hive.box<ChatMessage>('messages');
    ChatMessage? message = messageBox.get(chatId);
    message?.status = status;
    message?.save();

    CollectionReference messageRef = await FirebaseCloudFirestore().messageCollectionRef;
    messageRef.doc(chatId).update({
      'status':status
    });
  }

  int unReadMessageCount(Box<ChatMessage>messageBox){
    int count = 0;
    List<ChatMessage> messages = messageBox.values.toList();
    for (var message in messages) {
      if(!message.isSent && message.status == 'notViewed'){
        count+=1;
      }
    }
    return count;
  }
  sendImage(File image)async{
    String? imagePath = await FirebaseCloudStorage().uploadChatImage(image);
    if(imagePath!=null){
      var messageData = {
        "message":imagePath,
        "lng":'en',
        "created_at":DateTime.now(),
        "content_type":"image",
        "user_type":"driver",
        "translated_text":null,
        "translated_lng":null
      };
      String? chatId = await FirebaseCloudFirestore().addMessage(messageData);
      if(chatId!=null){
        var filePath = await saveChatImage(image, imagePath);
        messageData['FilePath'] = filePath;
        await saveMessageLocally(messageData,chatId);
      }
    }

  }

  Future<String> saveChatImage(File image,String imagePath)async{
    String fileName = FileHandler().fileNameFromPath(imagePath);
    var filePath = await FileHandler().savePath('chat',fileName);
    await image.copy(filePath);
    return filePath;
  }
  showNewMessageNotification(){
    var messageBox =  Hive.box<ChatMessage>('messages');
    int unreadMessageCount = unReadMessageCount(messageBox);
    if(unreadMessageCount!=0){
      var payload ={
        'title':"Europe Express Driver",
         'body':"You have new message(s)"
      };
     // NotificationService().showMessageNotification(payload);
    }
  }
  Future translateText(ChatMessage messageData,driverLng) async{
    var data = {
      "translation_string":messageData.text,
      "target_lng":driverLng
    };
    var response = await Api().getTranslation(data);
    if(response is http_response.HttpResponse && response.statusCode ==200){
      String translation = response.data['translatedText'];
      updateChatData(messageData.chatId, translation, driverLng);
    }
  }

  updateChatData(chatId,translation,driverLng){
    _updateFirebaseChatTranslationData(chatId,translation,driverLng);
    _updateDatabaseChatTranslationData(chatId,translation,driverLng);
  }
  Future _updateFirebaseChatTranslationData(chatId,translation,driverLng) async{
    var translationData = {
      'translated_lng':driverLng,
      'translated_text':translation
    };
   await FirebaseCloudFirestore().updateMessage(chatId, translationData);
  }
  _updateDatabaseChatTranslationData(chatId,translation,driverLng){
    var messageBox = Hive.box<ChatMessage>('messages');
    ChatMessage? message = messageBox.get(chatId);
    message?.translatedText = translation;
    message?.translatedLng = driverLng;
    message?.save();
  }


  loadOutBox()async{
    CollectionReference messageRef = await FirebaseCloudFirestore().messageCollectionRef;
    messageRef.where("user_type", isEqualTo: "driver").get().then((QuerySnapshot querySnapshot)async {
      for (var element in querySnapshot.docs) {
        if(!Hive.box<ChatMessage>('messages').containsKey(element.id)){
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          data['created_at'] = (data['created_at'] as Timestamp ).toDate();
          if(data['content_type']=='image'){
            String? savePath = await FirebaseCloudStorage().downloadChatImage(data['message']);
            if(savePath!=null){
              data['FilePath'] = savePath;
            }
          }
          await saveMessageLocally(data, element.id);
          }

        }
    });
  }

  deleteChatImages()async{
    await FileHandler().deleteDirectory("chat");
  }

  translationStatusUpdate(String chatId,bool status)async{
    var messageBox = Hive.box<ChatMessage>('messages');
    if(messageBox.containsKey(chatId)){
      ChatMessage? message = messageBox.get(chatId);
      message?.showTranslation = status;
      await message?.save();
    }
  }
  onReceiveNewMessage(BuildContext context, GlobalKey<NavigatorState> key)
  {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      bool canShow = getCanShowNotification(context);
      if (message.data.isNotEmpty && canShow) {
        Map<String, dynamic> data = message.data;
        NotificationService().showMessageNotification(data,context,key);
      }
    });

  }
  
  bool getCanShowNotification(context){
    try{
      return Provider.of<ChatDataProvider>(context, listen: false).showNotification;
    }catch(e){
      return true;
    }
  }

}