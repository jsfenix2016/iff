// // GENERATED CODE - DO NOT MODIFY BY HAND
// import 'package:hive_flutter/adapters.dart';
// import 'package:ifeelefine/Model/restdaybd.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
// // 
// class RestDayBDAdapter extends TypeAdapter<RestDayBD> {
//   @override
//   final typeId = 1;

//   @override
//   RestDayBD read(BinaryReader reader) {
//     var numOfFields = reader.readByte();
//     var fields = <int, dynamic>{
//       for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return RestDayBD(
//       id: fields[0] as int,
//       day: fields[1] as String,
//       timeWakeup: fields[2] as String,
//       timeSleep: fields[3] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, RestDayBD obj) {
//     writer
//       ..writeByte(obj.id)
//       ..writeByte(0)
//       ..write(obj.day)
//       ..writeByte(1)
//       ..write(obj.timeWakeup)
//       ..writeByte(2)
//       ..write(obj.timeSleep);
//   }
// }
