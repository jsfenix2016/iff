class UseMobilApi {
  late String phoneNumber;
  late String dayOfWeek;
  late int time;
  late int index;

  UseMobilApi(this.phoneNumber, this.dayOfWeek, this.time, this.index);

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'dayOfWeek': dayOfWeek,
    'time': time,
    'index': index
  };
}