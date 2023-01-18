import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ImageEncoder {
  base64Encode(File image) async {
    Uint8List? imageBytes = await image.readAsBytes();
    return base64.encode(imageBytes);
  }

  Future<String?> base64FromImagePath(String path) async {
    File image = File(path);
    if (await image.exists()) {
      return await ImageEncoder().base64Encode(image);
    }
    return null;
  }
}
