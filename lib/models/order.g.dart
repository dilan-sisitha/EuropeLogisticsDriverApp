// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 0;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: fields[0] as int,
      orderId: fields[1] as String,
      from: fields[2] as String,
      fromAddress: fields[3] as String,
      to: fields[4] as String,
      toAddress: fields[5] as String,
      status: fields[6] as int,
      collectionTime: fields[7] as String?,
      collectedTime: fields[8] as String?,
      deliveryTime: fields[9] as String?,
      deliveredTime: fields[10] as String?,
      logisticTime: fields[11] as String?,
      loadingStart: fields[12] as String?,
      loadingEnd: fields[13] as String?,
      unloadingStart: fields[14] as String?,
      unloadingEnd: fields[15] as String?,
      mass: fields[16] as int,
      orderSizeId: fields[17] as int,
      phoneOnCollect: fields[18] as String?,
      phoneOnDrop: fields[19] as String?,
      floorOnCollect: fields[20] as int?,
      liftOnCollect: fields[21] as bool?,
      floorOnDrop: fields[22] as int?,
      liftOnDrop: fields[23] as bool?,
      driverHelp: fields[24] as bool,
      hasCustomsClearance: fields[25] as bool,
      cooperateOrderId: fields[26] as int?,
      qrCode: fields[27] as String?,
      documentPickupPoint: fields[28] as String?,
      documentReleasePoint: fields[29] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.fromAddress)
      ..writeByte(4)
      ..write(obj.to)
      ..writeByte(5)
      ..write(obj.toAddress)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.collectionTime)
      ..writeByte(8)
      ..write(obj.collectedTime)
      ..writeByte(9)
      ..write(obj.deliveryTime)
      ..writeByte(10)
      ..write(obj.deliveredTime)
      ..writeByte(11)
      ..write(obj.logisticTime)
      ..writeByte(12)
      ..write(obj.loadingStart)
      ..writeByte(13)
      ..write(obj.loadingEnd)
      ..writeByte(14)
      ..write(obj.unloadingStart)
      ..writeByte(15)
      ..write(obj.unloadingEnd)
      ..writeByte(16)
      ..write(obj.mass)
      ..writeByte(17)
      ..write(obj.orderSizeId)
      ..writeByte(18)
      ..write(obj.phoneOnCollect)
      ..writeByte(19)
      ..write(obj.phoneOnDrop)
      ..writeByte(20)
      ..write(obj.floorOnCollect)
      ..writeByte(21)
      ..write(obj.liftOnCollect)
      ..writeByte(22)
      ..write(obj.floorOnDrop)
      ..writeByte(23)
      ..write(obj.liftOnDrop)
      ..writeByte(24)
      ..write(obj.driverHelp)
      ..writeByte(25)
      ..write(obj.hasCustomsClearance)
      ..writeByte(26)
      ..write(obj.cooperateOrderId)
      ..writeByte(27)
      ..write(obj.qrCode)
      ..writeByte(28)
      ..write(obj.documentPickupPoint)
      ..writeByte(29)
      ..write(obj.documentReleasePoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
