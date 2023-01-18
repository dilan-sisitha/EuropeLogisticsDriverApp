// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driverData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverDataAdapter extends TypeAdapter<DriverData> {
  @override
  final int typeId = 4;

  @override
  DriverData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverData(
      id: fields[0] as int,
      driverName: fields[1] as String,
      driverImage: fields[2] as String,
      vanImage: fields[3] as String,
      userName: fields[4] as String,
      driverEmail: fields[5] as String?,
      company: fields[6] as String,
      companyAddress: fields[7] as String,
      contactNo: fields[8] as String?,
      vanMake: fields[9] as String,
      vanType: fields[10] as String,
      vanRegistration: fields[11] as String,
      vanColor: fields[12] as String?,
      carrierName: fields[13] as String?,
      carrierEmail: fields[14] as String?,
      carrierPhone: fields[15] as String?,
      bankAccount: fields[16] as String?,
      swiftCode: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DriverData obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.driverName)
      ..writeByte(2)
      ..write(obj.driverImage)
      ..writeByte(3)
      ..write(obj.vanImage)
      ..writeByte(4)
      ..write(obj.userName)
      ..writeByte(5)
      ..write(obj.driverEmail)
      ..writeByte(6)
      ..write(obj.company)
      ..writeByte(7)
      ..write(obj.companyAddress)
      ..writeByte(8)
      ..write(obj.contactNo)
      ..writeByte(9)
      ..write(obj.vanMake)
      ..writeByte(10)
      ..write(obj.vanType)
      ..writeByte(11)
      ..write(obj.vanRegistration)
      ..writeByte(12)
      ..write(obj.vanColor)
      ..writeByte(13)
      ..write(obj.carrierName)
      ..writeByte(14)
      ..write(obj.carrierEmail)
      ..writeByte(15)
      ..write(obj.carrierPhone)
      ..writeByte(16)
      ..write(obj.bankAccount)
      ..writeByte(17)
      ..write(obj.swiftCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
