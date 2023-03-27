// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../activitydaybd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityDayBDAdapter extends TypeAdapter<ActivityDayBD> {
  @override
  final int typeId = 3;

  @override
  ActivityDayBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityDayBD(
      day: fields[0] as String,
      timeStart: fields[1] as String,
      timeFinish: fields[2] as String,
      activity: fields[3] as String,
      id: fields[4] as int,
      selection: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityDayBD obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.timeStart)
      ..writeByte(2)
      ..write(obj.timeFinish)
      ..writeByte(3)
      ..write(obj.activity)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.selection);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityDayBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
