// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../useMobilbd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UseMobilBDAdapter extends TypeAdapter<UseMobilBD> {
  @override
  final int typeId = 8;

  @override
  UseMobilBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UseMobilBD(
      day: fields[0] as String,
      time: fields[1] as String,
      selection: fields[2] as int,
      isSelect: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UseMobilBD obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.selection)
      ..writeByte(3)
      ..write(obj.isSelect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UseMobilBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
