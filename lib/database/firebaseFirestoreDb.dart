import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euex/services/chatService.dart';
import 'package:euex/services/driverService.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/environment.dart';

class FirebaseCloudFirestore{

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static final String chatCollection = Environment.config.chatCollection;

  Future<CollectionReference> get messageCollectionRef async{
    final int? driverId = DriverService().driverId;
    return FirebaseFirestore.instance.collection(chatCollection)
        .doc(driverId.toString()).collection('messages');
  }

  Future<String?>addMessage(messageData) async {
    try{
      CollectionReference messageRef = await messageCollectionRef;
      DocumentReference doc = await messageRef.add(messageData);
      return doc.id;
    }catch(e){
      return null;
      }
    }
  Future<void>updateMessage(docId,messageData) async {
    try{
      CollectionReference messageRef = await messageCollectionRef;
       await messageRef.doc(docId).update(messageData);
    }catch(e){
      debugPrint(e.toString());
    }
  }




}