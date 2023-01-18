import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHandler {
  static const List supportedImageTypes = ['jpg', 'jpeg', 'png'];
  static const double maxFileSize = 15; //MB

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  savePath(filePath, fileName) async {
    final dir = await getDirectory(filePath);
    return '$dir$fileName';
  }

  getDirectory(directoryPath,{create=true}) async {
    var localPath = await _localPath;
    Directory appDocDirFolder = Directory('$localPath/$directoryPath/');
    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else if(create) {
      final Directory appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
    return null;
  }

  Future<bool> checkDirectoryExists(path) async {
    final myDir = Directory(path);
    return await myDir.exists();
  }

  Future<bool> checkFileExists(path) async {
    return await File(path).exists();
  }

  Future<Directory> createDirectory(path, {recursive = false}) async {
    final dir = Directory(path);
    return await dir.create(recursive: recursive);
  }

  deleteDirectory(dirPath) async {
    var localPath = await _localPath;
    final dir = Directory(localPath + '/' + dirPath);
    if(await dir.exists()){
      dir.deleteSync(recursive: true);
    }
  }

  Future deleteFile(filePath, fileName) async {
    try {
      final dirPath = await _localPath;
      final file = File('$dirPath/$filePath/$fileName');
      await file.delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String randomFileName() {
    final randomNumber = Random().nextDouble();
    final randomBytes = utf8.encode(randomNumber.toString());
    final randomString = md5.convert(randomBytes).toString();
    return randomString;
  }

  Future<double> getFileSize(File file) async {
    int bytes = await file.length();
    return bytes / 1000000;
  }

  String getFileType(File file) {
    String path = file.path;
    return path.split('.').last;
  }

  Future<bool> isValidFileSize(file,{maxSize = maxFileSize}) async {
    double fileSize = await getFileSize(file);
    if (fileSize > maxSize) {
      return false;
    }
    return true;
  }

  bool isValidImageType(file) {
    String filetype = getFileType(file);
    if (supportedImageTypes.contains(filetype)) {
      return true;
    }
    return false;
  }

  Future get _downLoadPath async {
    String downloadPath = '';
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      List<String>? fullPath = dir?.path.split('/');
      for (String folder in fullPath!) {
        if (folder != 'Android') {
          if (folder != '') {
            downloadPath += '/$folder';
          }
        } else {
          break;
        }
      }
      return '$downloadPath/Download/EuropeExpress';
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    }
  }

  Future<String?> get downloadDir async {
    if (await Permission.storage.request().isGranted) {
      var path = await _downLoadPath;
      if (!await checkDirectoryExists(path)) {
        await createDirectory(path);
      }
      return path;
    }
    return null;
  }

  String getExtension(String path) {
    var pos = path.lastIndexOf('.');
    String result = (pos != -1) ? path.substring(pos + 1, path.length) : path;
    return result;
  }

  String fileNameFromPath(path) {
    var pos = path.lastIndexOf('/');
    String result = (pos != -1) ? path.substring(pos + 1, path.length) : path;
    return result;
  }

  String get supportImageTypeMessage{
    int len = supportedImageTypes.length-1;
    String message='';
    for( var i = 0 ; i <= len; i++ ) {
      String suffix = '';
      if(len-1 > i){
        suffix = ', ';
      }else if(i==len-1){
        suffix = ' or ';
      }
        message+=supportedImageTypes[i] +suffix;
    }
    return message;
  }
}
