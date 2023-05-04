// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../activitydaybd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityDayBDAdapter extends TypeAdapter<ActivityDayBD> {
  @override
  final int typeId = HiveConstantAdapterInit.idActivityDayDBAdapter;

  @override
  ActivityDayBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityDayBD(
        id: fields[4] as int,
        activity: fields[3] as String,
        allDay: fields[5] as bool,
        day: fields[0] as String,
        dayFinish: fields[6] as String,
        timeStart: fields[2] as String,
        timeFinish: fields[1] as String,
        days: fields[7] as String,
        repeatType: fields[8] as String,
        isDeactivate: fields[9] as bool,
        specificDaysDeactivated: fields[10] as String,
        specificDaysRemoved: fields[11] as String);
  }

  @override
  void write(BinaryWriter writer, ActivityDayBD obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.allDay)
      ..writeByte(6)
      ..write(obj.dayFinish)
      ..writeByte(7)
      ..write(obj.days)
      ..writeByte(8)
      ..write(obj.repeatType)
      ..writeByte(9)
      ..write(obj.isDeactivate)
      ..writeByte(10)
      ..write(obj.specificDaysDeactivated)
      ..writeByte(11)
      ..write(obj.specificDaysRemoved);
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
