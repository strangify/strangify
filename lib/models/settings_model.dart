class SettingsModel {
  final num sessionExpiry;
  final num listenerPay;
  final num listenerCharge;
  final num counsellorPay;
  final num counsellorCharge;

  final String listenerTerms;
  final String listenerPrivacy;
  final String usersTerms;
  final String usersPrivacy;

  SettingsModel(
      {required this.listenerPay,
      required this.listenerTerms,
      required this.sessionExpiry,
      required this.listenerPrivacy,
      required this.listenerCharge,
      required this.usersTerms,
      required this.counsellorPay,
      required this.usersPrivacy,
      required this.counsellorCharge});

  static SettingsModel fromSnap(Map<String, dynamic> json) {
    return SettingsModel(
        listenerTerms: json["listener_terms"],
        listenerPrivacy: json["listener_privacy"],
        usersTerms: json["user_terms"],
        usersPrivacy: json["user_privacy"],
        listenerPay: json["listener_pay"],
        sessionExpiry: json["session_expiry"],
        listenerCharge: json["listener_charge"],
        counsellorPay: json["counsellor_pay"],
        counsellorCharge: json["counsellor_charge"]);
  }
}
