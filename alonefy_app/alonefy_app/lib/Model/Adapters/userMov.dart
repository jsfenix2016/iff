// GENERATED CODE - DO NOT MODIFY BY HAND
// import 'package:hive_flutter/adapters.dart';
// import 'package:ifeelefine/Model/userPosition.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class UserMovAdapter extends TypeAdapter<UserPositionBD> {
//   @override
//   final typeId = 2;

//   @override
//   UserPositionBD read(BinaryReader reader) {
//     var numOfFields = reader.readByte();
//     var fields = <int, dynamic>{
//       for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return UserPositionBD(
//       time: fields[0] as DateTime,
//       mov: fields[1] as List<double>,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, UserPositionBD obj) {
//     writer
//       ..write(obj.mov)
//       ..writeByte(0)
//       ..write(obj.time)
//       ..writeByte(1);
//   }
// }
