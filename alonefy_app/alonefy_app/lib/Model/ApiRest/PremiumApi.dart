class PremiumApi {
  late String phoneNumber;
  late bool premium;

  PremiumApi({required this.phoneNumber, required this.premium});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'premium': premium
  };

  factory PremiumApi.fromJson(Map<String, dynamic> json) {
    return PremiumApi(
        phoneNumber: json['phoneNumber'],
        premium: json['premium']
    );
  }
}