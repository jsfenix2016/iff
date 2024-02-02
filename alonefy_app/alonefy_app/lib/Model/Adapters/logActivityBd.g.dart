part of '../logActivityBd.dart';

class LogActivityBDAdapter extends TypeAdapter<LogActivityBD> {
  @override
  final int typeId = 7;

  @override
  LogActivityBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogActivityBD(
      time: fields[0] as DateTime,
      movementType: fields[1] as String,
      groupBy: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LogActivityBD obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.movementType)
      ..writeByte(2)
      ..write(obj.groupBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogActivityBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
