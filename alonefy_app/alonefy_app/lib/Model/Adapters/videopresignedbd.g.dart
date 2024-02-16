// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../videopresignedbd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoPresignedBDAdapter extends TypeAdapter<VideoPresignedBD> {
  @override
  final int typeId = 9;

  @override
  VideoPresignedBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoPresignedBD(
      modified: fields[0] as String,
      url: fields[1] as String,
      videoDown: fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoPresignedBD obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.modified)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.videoDown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoPresignedBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
