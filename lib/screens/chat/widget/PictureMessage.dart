import 'dart:io';

import 'package:euex/components/cons.dart';
import 'package:euex/helpers/dateTimeFormater.dart';
import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/models/chatMessage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class PictureMessage extends StatelessWidget {
  const PictureMessage({
    required this.message,
    Key? key
  }) : super(key: key);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: ()async{
       if(await _checkImageExists()){
         await OpenFile.open(message.imageUrl);
       }
     },
     child: Container(
       padding: const EdgeInsets.only(
         left: 5,
         right: 5,
         top: 5,
         bottom: 10
       ),
       decoration: BoxDecoration(
         color: message.isSent ? grayColor2 : bPrimaryColor,
         borderRadius: BorderRadius.circular(10)),
       child: Column(
         children: [
           SizedBox(
               width: 160,
               height: 160,
               child: Card(
                   color: grayColor2,
                   child: (message.imageUrl != null)
                       ? FutureBuilder(
                     future: FileHandler().checkFileExists(message.imageUrl),
                         builder: (context,snapShot) {
                          if(snapShot.data == true){
                            return Center(child: Image.file(File(message.imageUrl!)),);
                          }
                           return const Center(child: Text("Image not found"));
                         }
                       )
                       : const Center(child: Text('invalid content'))
               )
           ),
           Padding(
             padding: const EdgeInsets.only(right: 10),
             child: Container(
               alignment:  message.isSent ? Alignment.topRight : Alignment.topLeft,
               child: Text(
                 DateTimeFormatter().messageDateTime(message.createdAt.toString(),message.isSent),
                 style: TextStyle(
                   fontSize: 11,
                   color: message.isSent ? Colors.black54 : Colors.white54,
                 ),
               ),
             ),
           ),
         ],
       ),
     ),
   );


  }
  _checkImageExists()async{
    return await FileHandler().checkFileExists(message.imageUrl);
  }
}
