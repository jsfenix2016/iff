// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logAlertsBD.dart';

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
      typeAction: fields[1] as String,
      time: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LogAlertsBD obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.typeAction)
      ..writeByte(2)
      ..write(obj.time);
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
