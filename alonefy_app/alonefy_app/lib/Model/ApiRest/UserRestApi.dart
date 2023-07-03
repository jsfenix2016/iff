import 'package:ifeelefine/Common/utils.dart';

class UserRestApi {
  late String phoneNumber;
  late String dayOfWeek;
  late DateTime wakeUpHour;
  late DateTime retireHour;
  late int index;
  late bool isSelect;


  UserRestApi({
      required this.phoneNumber,
      required this.dayOfWeek,
      required this.wakeUpHour,
      required this.retireHour,
      required this.index,
      required this.isSelect});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'dayOfWeek': dayOfWeek,
    'wakeUpHour': wakeUpHour.toIso8601String(),
    'retireHour': retireHour.toIso8601String(),
    'index': index,
    'selected': isSelect
  };

  factory UserRestApi.fromJson(Map<String, dynamic> json) {
    return UserRestApi(
      phoneNumber: json['phoneNumber'],
      dayOfWeek: json['dayOfWeek'],
      wakeUpHour: jsonToDatetime(json['wakeUpHour'], getDefaultPattern()),
      retireHour: jsonToDatetime(json['retireHour'],getDefaultPattern()),
      index: json['index'],
      isSelect: json['selected'],
    );
  }
}