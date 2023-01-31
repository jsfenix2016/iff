import 'package:hive/hive.dart';

part 'Adapters/userbd.g.dart';

@HiveType(typeId: 0)
class UserBD {
  UserBD(
      {required this.idUser,
      required this.name,
      required this.lastname,
      required this.email,
      required this.telephone,
      required this.gender,
      required this.maritalStatus,
      required this.styleLife,
      required this.pathImage,
      required this.age,
      required this.country,
      required this.city});

  @HiveField(0)
  String idUser;
  @HiveField(1)
  String name;
  @HiveField(2)
  String lastname;
  @HiveField(3)
  String email;
  @HiveField(4)
  String telephone;
  @HiveField(5)
  String gender;
  @HiveField(6)
  String maritalStatus;
  @HiveField(7)
  String styleLife;
  @HiveField(8)
  String pathImage;
  @HiveField(9)
  String age;
  @HiveField(10)
  String country;
  @HiveField(11)
  String city;
}
