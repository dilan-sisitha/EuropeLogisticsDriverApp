// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatMessage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 7;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      createdAt: fields[0] as DateTime,
      text: fields[1] as String?,
      lng: fields[2] as String?,
      translatedText: fields[3] as String?,
      translatedLng: fields[4] as String?,
      imageUrl: fields[5] as String?,
      contentType: fields[6] as String,
      isSent: fields[7] as bool,
      status: fields[8] as String?,
      chatId: fields[9] as String,
      showTranslation: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.lng)
      ..writeByte(3)
      ..write(obj.translatedText)
      ..writeByte(4)
      ..write(obj.translatedLng)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.contentType)
      ..writeByte(7)
      ..write(obj.isSent)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.chatId)
      ..writeByte(10)
      ..write(obj.showTranslation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
