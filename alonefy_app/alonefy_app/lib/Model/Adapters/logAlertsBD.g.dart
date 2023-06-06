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
      type: fields[0] as String,
      time: fields[1] as DateTime,
      photoDate: (fields[2] as List?)?.cast<Uint8List>(),
      video: fields[3] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, LogAlertsBD obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.photoDate)
      ..writeByte(3)
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
