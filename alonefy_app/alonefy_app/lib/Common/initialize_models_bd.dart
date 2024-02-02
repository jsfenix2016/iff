import 'package:ifeelefine/Model/contactRiskBD.dart';
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
      country: '🇪🇸  Spain',
      city: 'Comunidad de Madrid');
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
      country: '🇪🇸  Spain',
      city: 'Comunidad de Madrid');
}

ContactRiskBD initContactRisk() {
  return ContactRiskBD(
      id: -1,
      photo: null,
      name: '',
      timeinit: '00:00',
      timefinish: '00:00',
      phones: '',
      titleMessage: '',
      messages: '',
      sendLocation: false,
      sendWhatsapp: false,
      isInitTime: false,
      isFinishTime: false,
      code: '',
      isActived: false,
      isprogrammed: false,
      photoDate: [],
      saveContact: false,
      createDate: DateTime.now(),
      taskIds: [],
      finish: false);
}
