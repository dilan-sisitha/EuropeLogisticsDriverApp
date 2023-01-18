import 'dart:io';

import 'package:euex/helpers/fileHandler.dart';
import 'package:euex/services/driverService.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../config/environment.dart';

class FirebaseCloudStorage{

  final storageRef = FirebaseStorage.instanceFor(bucket: Environment.config.storageBucket).ref();

  Future<String?> uploadChatImage(File image)async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String extension = FileHandler().getFileType(image);
      final imagesRef = storageRef.child('images/$fileName.$extension');
      await imagesRef.putFile(image);
      final customMetaData = SettableMetadata(
        customMetadata: {
          "driver_id":  DriverService().driverId.toString(),
        },
      );
      await imagesRef.updateMetadata(customMetaData);
      return imagesRef.fullPath;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }

  }
  Future<String?> downloadChatImage(String path)async {
    try {
      String fileName = FileHandler().fileNameFromPath(path);
      var filePath = await FileHandler().savePath('chat',fileName);
      final File file = File(filePath);
      final imagesRef = storageRef.child(path);
      await imagesRef.writeToFile(file);
      return file.path;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }

  }

}