class UseMobilApi {
  late String phoneNumber;
  late String dayOfWeek;
  late int time;
  late int index;
  late bool isSelect;

  UseMobilApi({
      required this.phoneNumber,
      required this.dayOfWeek,
      required this.time,
      required this.index,
      required this.isSelect});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'dayOfWeek': dayOfWeek,
    'time': time,
    'index': index,
    'isSelect': isSelect
  };

  factory UseMobilApi.fromJson(Map<String, dynamic> json) {
    return UseMobilApi(
      phoneNumber: json['phoneNumber'],
      dayOfWeek: json['dayOfWeek'],
      time: json['time'],
      index: json['index'],
      isSelect: json['isSelect'],
    );
  }
}