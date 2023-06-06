class FirebaseTokenApi {
  late String phoneNumber;
  late String fcmToken;

  FirebaseTokenApi({required this.phoneNumber, required this.fcmToken});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'fcmToken': fcmToken
  };

  factory FirebaseTokenApi.fromJson(Map<String, dynamic> json) {
    return FirebaseTokenApi(
        phoneNumber: json['phoneNumber'],
        fcmToken: json['fcmToken']
    );
  }
}