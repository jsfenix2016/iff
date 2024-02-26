// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../historialbd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistorialBDAdapter extends TypeAdapter<HistorialBD> {
  @override
  final int typeId = 10;

  @override
  HistorialBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistorialBD(
      id: fields[0] as int,
      type: fields[1] as String,
      time: fields[2] as DateTime,
      photoDate: (fields[3] as List?)?.cast<Uint8List>(),
      video: fields[4] as Uint8List?,
      groupBy: fields[5] as String,
      listVideosPresigned: (fields[6] as List?)?.cast<VideoPresignedBD>(),
    );
  }

  @override
  void write(BinaryWriter writer, HistorialBD obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.photoDate)
      ..writeByte(4)
      ..write(obj.video)
      ..writeByte(5)
      ..write(obj.groupBy)
      ..writeByte(6)
      ..write(obj.listVideosPresigned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistorialBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
