part of '../logActivityBd.dart';

class LogActivityBDAdapter extends TypeAdapter<LogActivityBD> {
  @override
  final int typeId = HiveConstantAdapterInit.idLogActivityBDAdapter;

  @override
  LogActivityBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogActivityBD(
        dateTime: fields[0] as DateTime,
        movementType: fields[1] as String
    );
  }

  @override
  void write(BinaryWriter writer, LogActivityBD obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.movementType);
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
