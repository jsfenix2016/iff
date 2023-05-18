class TermsAndConditionsApi {
  late String phoneNumber;
  late bool smsCallAccepted;

  TermsAndConditionsApi(this.phoneNumber, this.smsCallAccepted);

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'smsCallAccepted': smsCallAccepted
  };
}