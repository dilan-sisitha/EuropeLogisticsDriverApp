import 'package:hive_flutter/hive_flutter.dart';
part 'chatMessage.g.dart';
@HiveType(typeId: 7)
class ChatMessage extends HiveObject{

  @HiveField(0)
  DateTime createdAt;

  @HiveField(1)
  String? text;

  @HiveField(2)
  String? lng;

  @HiveField(3)
  String? translatedText;

  @HiveField(4)
  String? translatedLng;

  @HiveField(5)
  String? imageUrl;

  @HiveField(6)
  String contentType;

  @HiveField(7)
  bool isSent;

  @HiveField(8)
  String? status;

  @HiveField(9)
  String chatId;

  @HiveField(10)
  bool showTranslation;



  ChatMessage({
    required this.createdAt,
    this.text,
    this.lng,
    this.translatedText,
    this.translatedLng,
    this.imageUrl,
    required this.contentType,
    required this.isSent,
    this.status,
    required this.chatId,
    this.showTranslation = false
  });
}
enum ContentType {
  image,
  text,
}
enum UserType {
  driver,
  logistic,
}
enum MessageStatus {
  notSent,
  notViewed,
  viewed,
  sent
}
