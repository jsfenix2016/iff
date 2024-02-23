import '../../Common/utils.dart';
import '../logAlertsBD.dart';

class AlertApi {
  late int id;
  late String phonenumber;
  late String typeaction;
  late DateTime startdate;
  late String groupBy;

  AlertApi(
      {required this.phonenumber,
      required this.typeaction,
      required this.startdate,
      required this.groupBy});

  AlertApi.fromApi(
      {required this.id,
      required this.phonenumber,
      required this.typeaction,
      required this.startdate,
      required this.groupBy});

  AlertApi.fromAlert(LogAlertsBD logAlertsBD, String phoneNumber) {
    phonenumber = phoneNumber.replaceAll("+34", "").replaceAll(" ", "");
    typeaction = logAlertsBD.type;
    startdate = logAlertsBD.time;
    groupBy = logAlertsBD.groupBy;
  }

  Map<String, dynamic> toJson() => {
        'phoneNumber': phonenumber,
        'typeAction': typeaction,
        'startDate': startdate.toIso8601String(),
        'groupBy': groupBy
      };

  factory AlertApi.fromJson(Map<String, dynamic> json) {
    return AlertApi.fromApi(
        id: json['id'],
        phonenumber: json['phoneNumber'],
        typeaction: json['typeAction'],
        startdate: jsonToDatetime(json['startDate'], getDefaultPattern()),
        groupBy: json['groupBy']);
  }
}
