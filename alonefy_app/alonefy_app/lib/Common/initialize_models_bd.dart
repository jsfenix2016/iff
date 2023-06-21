import 'package:ifeelefine/Model/user.dart';
import 'package:ifeelefine/Model/userbd.dart';

class InitializeModelsBD {}

User initUser() {
  return User(
      idUser: "-1",
      name: "",
      lastname: "",
      email: "",
      telephone: "",
      gender: "",
      maritalStatus: "",
      styleLife: "",
      pathImage: "",
      age: '',
      country: '',
      city: '');
}

UserBD initUserBD() {
  return UserBD(
      idUser: "d6863ba0-0b4e-11ee-a251-77c3a7886810",
      name: "Javier",
      lastname: "Santana",
      email: "javier.santana@panel.es",
      telephone: "645815116",
      gender: "",
      maritalStatus: "",
      styleLife: "",
      pathImage: "",
      age: '',
      country: '',
      city: '');
}
