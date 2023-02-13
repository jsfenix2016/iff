// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../userpositionbd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPositionBDAdapter extends TypeAdapter<UserPositionBD> {
  @override
  final int typeId = 2;

  @override
  UserPositionBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPositionBD(
      typeAction: fields[0] as String,
      time: fields[1] as DateTime,
      movRureUser: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserPositionBD obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.typeAction)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.movRureUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPositionBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
