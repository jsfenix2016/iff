import '../logAlertsBD.dart';

class AlertApi {
  late int id;
  late String phonenumber;
  late String typeaction;
  late DateTime startdate;

  AlertApi({
    required this.phonenumber,
    required this.typeaction,
    required this.startdate});

  AlertApi.fromApi({
    required this.id,
    required this.phonenumber,
    required this.typeaction,
    required this.startdate});

  AlertApi.fromAlert(LogAlertsBD logAlertsBD) {
    typeaction = logAlertsBD.type;
    startdate = logAlertsBD.time;
  }

  Map<String, dynamic> toJson() => {
    'phonenumber': phonenumber,
    'typeaction': typeaction,
    'startdate': startdate.toIso8601String()
  };

  factory AlertApi.fromJson(Map<String, dynamic> json) {
    return AlertApi.fromApi(
      id: json['id'],
      phonenumber: json['phonenumber'],
      typeaction: json['typeaction'],
      startdate: json['startdate']
    );
  }
}