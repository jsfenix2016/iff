// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../contactRiskBD.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactRiskBDAdapter extends TypeAdapter<ContactRiskBD> {
  @override
  final int typeId = 5;

  @override
  ContactRiskBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactRiskBD(
      id: fields[0] as int,
      photo: fields[1] as Uint8List?,
      name: fields[2] as String,
      timeinit: fields[3] as String,
      timefinish: fields[4] as String,
      phones: fields[5] as String,
      titleMessage: fields[6] as String,
      messages: fields[7] as String,
      sendLocation: fields[9] as bool,
      sendWhatsapp: fields[8] as bool,
      isInitTime: fields[10] as bool,
      isFinishTime: fields[11] as bool,
      code: fields[12] as String,
      isActived: fields[13] as bool,
      isprogrammed: fields[14] as bool,
      photoDate: (fields[15] as List).cast<Uint8List>(),
      saveContact: fields[16] as bool,
      createDate: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ContactRiskBD obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.photo)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.timeinit)
      ..writeByte(4)
      ..write(obj.timefinish)
      ..writeByte(5)
      ..write(obj.phones)
      ..writeByte(6)
      ..write(obj.titleMessage)
      ..writeByte(7)
      ..write(obj.messages)
      ..writeByte(8)
      ..write(obj.sendWhatsapp)
      ..writeByte(9)
      ..write(obj.sendLocation)
      ..writeByte(10)
      ..write(obj.isInitTime)
      ..writeByte(11)
      ..write(obj.isFinishTime)
      ..writeByte(12)
      ..write(obj.code)
      ..writeByte(13)
      ..write(obj.isActived)
      ..writeByte(14)
      ..write(obj.isprogrammed)
      ..writeByte(15)
      ..write(obj.photoDate)
      ..writeByte(16)
      ..write(obj.saveContact)
      ..writeByte(17)
      ..write(obj.createDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactRiskBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
