class TermsAndConditionsApi {
  late String phoneNumber;
  late bool smsCallAccepted;

  TermsAndConditionsApi({required this.phoneNumber, required this.smsCallAccepted});

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'smsCallAccepted': smsCallAccepted
  };

  factory TermsAndConditionsApi.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionsApi(
        phoneNumber: json['phoneNumber'],
        smsCallAccepted: json['smsCallAccepted']
    );
  }
}