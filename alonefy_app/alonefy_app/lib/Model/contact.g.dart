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
      fields[0] as String,
      fields[1] as Uint8List?,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactBD obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.photo)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.timeSendSMS)
      ..writeByte(4)
      ..write(obj.timeCall)
      ..writeByte(5)
      ..write(obj.timeWhatsapp)
      ..writeByte(6)
      ..write(obj.phones)
      ..writeByte(7)
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
