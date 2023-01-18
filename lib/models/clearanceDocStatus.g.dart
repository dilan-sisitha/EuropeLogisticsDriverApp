// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clearanceDocStatus.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClearanceDocStatusAdapter extends TypeAdapter<ClearanceDocStatus> {
  @override
  final int typeId = 6;

  @override
  ClearanceDocStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClearanceDocStatus(
      id: fields[0] as int,
      orderId: fields[1] as String,
      type: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClearanceDocStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClearanceDocStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
