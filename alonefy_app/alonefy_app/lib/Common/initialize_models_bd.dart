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
