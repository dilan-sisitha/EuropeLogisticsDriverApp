// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 2;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      orderId: fields[0] as String,
      logisticDate: fields[1] as String,
      totalLoadingTime: fields[2] as String,
      totalUnloadingTime: fields[3] as String,
      amountForLoading: fields[4] as String,
      amountForUnloading: fields[5] as String,
      invoiceDownloadPath: fields[7] as String?,
      invoice: fields[6] as String,
      isCooperate: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.logisticDate)
      ..writeByte(2)
      ..write(obj.totalLoadingTime)
      ..writeByte(3)
      ..write(obj.totalUnloadingTime)
      ..writeByte(4)
      ..write(obj.amountForLoading)
      ..writeByte(5)
      ..write(obj.amountForUnloading)
      ..writeByte(6)
      ..write(obj.invoice)
      ..writeByte(7)
      ..write(obj.invoiceDownloadPath)
      ..writeByte(8)
      ..write(obj.isCooperate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
