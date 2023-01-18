// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geoData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeoDataAdapter extends TypeAdapter<GeoData> {
  @override
  final int typeId = 5;

  @override
  GeoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeoData(
      orderId: fields[0] as int,
      loadingLng: fields[1] as double?,
      loadingLat: fields[2] as double?,
      unloadingLng: fields[3] as double?,
      unloadingLat: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, GeoData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.loadingLng)
      ..writeByte(2)
      ..write(obj.loadingLat)
      ..writeByte(3)
      ..write(obj.unloadingLng)
      ..writeByte(4)
      ..write(obj.unloadingLat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
