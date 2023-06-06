class UserRestApi {
  late String phoneNumber;
  late String dayOfWeek;
  late int wakeUpHour;
  late int retireHour;
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
    'wakeUpHour': wakeUpHour,
    'retireHour': retireHour,
    'index': index,
    'isSelect': isSelect
  };

  factory UserRestApi.fromJson(Map<String, dynamic> json) {
    return UserRestApi(
      phoneNumber: json['phoneNumber'],
      dayOfWeek: json['dayOfWeek'],
      wakeUpHour: json['wakeUpHour'],
      retireHour: json['retireHour'],
      index: json['index'],
      isSelect: json['isSelect'],
    );
  }
}