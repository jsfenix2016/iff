// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../contactZoneRiskBD.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactZoneRiskBDAdapter extends TypeAdapter<ContactZoneRiskBD> {
  @override
  final int typeId = HiveConstantAdapterInit.idContactZoneRiskBDAdapter;

  @override
  ContactZoneRiskBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactZoneRiskBD(
      id: fields[0] as int,
      photo: fields[1] as Uint8List?,
      name: fields[2] as String,
      phones: fields[3] as String,
      sendLocation: fields[5] as bool,
      sendWhatsapp: fields[4] as bool,
      code: fields[6] as String,
      isActived: fields[7] as bool,
      sendWhatsappContact: fields[8] as bool,
      callme: fields[9] as bool,
      save: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ContactZoneRiskBD obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.photo)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phones)
      ..writeByte(4)
      ..write(obj.sendWhatsapp)
      ..writeByte(5)
      ..write(obj.sendLocation)
      ..writeByte(6)
      ..write(obj.code)
      ..writeByte(7)
      ..write(obj.isActived)
      ..writeByte(8)
      ..write(obj.sendWhatsappContact)
      ..writeByte(9)
      ..write(obj.callme)
      ..writeByte(10)
      ..write(obj.save);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactZoneRiskBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
