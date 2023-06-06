// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../logAlertsBD.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogAlertsBDAdapter extends TypeAdapter<LogAlertsBD> {
  @override
  final int typeId = 2;

  @override
  LogAlertsBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogAlertsBD(
      id: fields[0] as int,
      type: fields[1] as String,
      time: fields[2] as DateTime,
      photoDate: (fields[3] as List?)?.cast<Uint8List>(),
      video: fields[4] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, LogAlertsBD obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.photoDate)
      ..writeByte(4)
      ..write(obj.video);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogAlertsBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
