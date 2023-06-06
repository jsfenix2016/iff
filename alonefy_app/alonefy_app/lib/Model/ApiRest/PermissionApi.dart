class PermissionApi {
  late String phoneNumber;
  late bool activateNotifications;
  late bool activateCamera;
  late bool activateContacts;
  late bool activateAlarm;

  PermissionApi({
    required this.phoneNumber,
    required this.activateNotifications,
    required this.activateCamera,
    required this.activateContacts,
    required this.activateAlarm});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'activateNotifications': activateNotifications,
    'activateCamera': activateCamera,
    'activateContacts': activateContacts,
    'activateAlarm': activateAlarm
  };

  factory PermissionApi.fromJson(Map<String, dynamic> json) {
    return PermissionApi(
        phoneNumber: json['phoneNumber'],
        activateNotifications: json['activateNotifications'],
        activateCamera: json['activateCamera'],
        activateContacts: json['activateContacts'],
        activateAlarm: json['activateAlarm'],
    );
  }
}