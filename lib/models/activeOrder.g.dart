// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activeOrder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActiveOrderAdapter extends TypeAdapter<ActiveOrder> {
  @override
  final int typeId = 3;

  @override
  ActiveOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActiveOrder(
      id: fields[0] as int,
      loadingStartTime: fields[2] as String?,
      loadingEndTime: fields[3] as String?,
      unloadingStartTime: fields[4] as String?,
      unloadingEndTime: fields[5] as String?,
      currentStatus: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ActiveOrder obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.loadingStartTime)
      ..writeByte(3)
      ..write(obj.loadingEndTime)
      ..writeByte(4)
      ..write(obj.unloadingStartTime)
      ..writeByte(5)
      ..write(obj.unloadingEndTime)
      ..writeByte(6)
      ..write(obj.currentStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
