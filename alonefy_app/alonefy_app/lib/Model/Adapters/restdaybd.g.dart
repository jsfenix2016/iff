// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../restdaybd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestDayBDAdapter extends TypeAdapter<RestDayBD> {
  @override
  final int typeId = 1;

  @override
  RestDayBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestDayBD(
      day: fields[0] as String,
      timeWakeup: fields[1] as String,
      timeSleep: fields[2] as String,
      selection: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RestDayBD obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.timeWakeup)
      ..writeByte(2)
      ..write(obj.timeSleep)
      ..writeByte(3)
      ..write(obj.selection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestDayBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
