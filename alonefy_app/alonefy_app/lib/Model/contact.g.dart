// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactBDAdapter extends TypeAdapter<ContactBD> {
  @override
  final int typeId = 4;

  @override
  ContactBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactBD(
      fields[0] as int,
      fields[1] as String,
      fields[2] as Uint8List?,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactBD obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.displayName)
      ..writeByte(2)
      ..write(obj.photo)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.timeSendSMS)
      ..writeByte(5)
      ..write(obj.timeCall)
      ..writeByte(6)
      ..write(obj.timeWhatsapp)
      ..writeByte(7)
      ..write(obj.phones)
      ..writeByte(8)
      ..write(obj.requestStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
