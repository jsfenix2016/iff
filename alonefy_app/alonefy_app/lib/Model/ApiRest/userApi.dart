class UserApi {
  late String idUser;
  late String name;
  late String lastname;
  late String email;
  late String telephone;
  late String gender;
  late String maritalStatus;
  late String styleLife;
  late String pathImage;
  late String age;
  late String country;
  late String city;
  late String fcmToken;
  late bool premium;
  late bool smsCallAccepted;
  late bool locationAccepted;
  late bool fallAccepted;
  late int timeFall;

  UserApi({
      required this.idUser,
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
      required this.city,
      required this.fcmToken,
      required this.premium,
      required this.smsCallAccepted,
      required this.locationAccepted,
      required this.fallAccepted,
      required this.timeFall});

  factory UserApi.fromJson(Map<String, dynamic> json) {
    return UserApi(
        idUser: json['idUser'],
        name: json['name'],
        lastname: json['lastname'],
        email: json['email'],
        telephone: json['telephone'],
        gender: json['gender'],
        maritalStatus: json['maritalStatus'],
        styleLife: json['styleLife'],
        pathImage: json['pathImage'],
        age: json['age'],
        country: json['country'],
        city: json['city'],
        fcmToken: json['fcmToken'],
        premium: json['premium'],
        smsCallAccepted: json['smsCallAccepted'],
        locationAccepted: json['locationAccepted'],
        fallAccepted: json['fallAccepted'],
        timeFall: json['timeFall']
    );
  }
}
