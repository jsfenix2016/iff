class PermissionApi {
  late String phoneNumber;
  late bool activateNotifications;
  late bool activateCamera;
  late bool activateContacts;
  late bool activateAlarm;
  late bool activateLocation;

  PermissionApi(
      {required this.phoneNumber,
      required this.activateNotifications,
      required this.activateCamera,
      required this.activateContacts,
      required this.activateAlarm,
      required this.activateLocation});

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'activateNotifications': activateNotifications,
        'activateCamera': activateCamera,
        'activateContacts': activateContacts,
        'activateAlarm': activateAlarm,
        'activateLocation': activateLocation
      };

  factory PermissionApi.fromJson(Map<String, dynamic> json) {
    return PermissionApi(
        phoneNumber: json['phoneNumber'],
        activateNotifications: json['activateNotifications'],
        activateCamera: json['activateCamera'],
        activateContacts: json['activateContacts'],
        activateAlarm: json['activateAlarm'],
        activateLocation: json['activateLocation']);
  }
}
