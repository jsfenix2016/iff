// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userbd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserBDAdapter extends TypeAdapter<UserBD> {
  @override
  final int typeId = 0;

  @override
  UserBD read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserBD(
      idUser: fields[0] as String,
      name: fields[1] as String,
      lastname: fields[2] as String,
      email: fields[3] as String,
      telephone: fields[4] as String,
      gender: fields[5] as String,
      maritalStatus: fields[6] as String,
      styleLife: fields[7] as String,
      pathImage: fields[8] as String,
      age: fields[9] as String,
      country: fields[10] as String,
      city: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserBD obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.idUser)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lastname)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.telephone)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.maritalStatus)
      ..writeByte(7)
      ..write(obj.styleLife)
      ..writeByte(8)
      ..write(obj.pathImage)
      ..writeByte(9)
      ..write(obj.age)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.city);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserBDAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
