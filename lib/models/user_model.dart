class User {
  final String phone;
  final String role;
  final String uid;
  final List recentlyConnected;
  final String deviceToken;
  final num walletBalance;

  final String? name;
  final String? email;
  final bool? isOnline;
  final String? gender;
  final String? age;
  final String? description;
  final String? imageUrl;
  final List? reviews;
  final List? languages;
  final List? tags;
  final List? toNotifyTokens;
  final bool? isChatEnabled;
  final bool? isCallEnabled;

  const User(
      {required this.deviceToken,
      required this.role,
      required this.recentlyConnected,
      required this.uid,
      required this.phone,
      required this.walletBalance,
      this.isOnline,
      this.email,
      this.gender,
      this.age,
      this.description,
      this.imageUrl,
      this.reviews,
      this.languages,
      this.tags,
      this.isChatEnabled,
      this.isCallEnabled,
      this.name,
      this.toNotifyTokens});

  static User fromSnap(Map<String, dynamic> json) {
    return User(
        deviceToken: json["deviceToken"],
        role: json["role"],
        recentlyConnected: json["recentlyConnected"],
        uid: json["uid"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        isOnline: json["isOnline"],
        gender: json["gender"],
        age: json["age"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        reviews: json["reviews"],
        languages: json["languages"],
        tags: json["tags"],
        toNotifyTokens: json["toNotifyTokens"],
        isChatEnabled: json["isChatEnabled"],
        isCallEnabled: json["isCallEnabled"],
        walletBalance: json["walletBalance"]);
  }

  static Map<String, dynamic> toSpeakerJson(User user) => {
        "deviceToken": user.deviceToken,
        "role": user.role,
        "recentlyConnected": user.recentlyConnected,
        "uid": user.uid,
        "phone": user.phone,
        "walletBalance": user.walletBalance,
      };

  Map<String, dynamic> toListenerJson(User user) => {
        "deviceToken": user.deviceToken,
        "role": user.role,
        "recentlyConnected": user.recentlyConnected,
        "uid": user.uid,
        "name": user.name,
        "phone": user.phone,
        "email": user.email,
        "isOnline": user.isOnline,
        "gender": user.gender,
        "age": user.age,
        "description": user.description,
        "imageUrl": user.imageUrl,
        "reviews": user.reviews,
        "languages": user.languages,
        "toNotifyTokens": user.toNotifyTokens,
        "isChatEnabled": user.isChatEnabled,
        "isCallEnabled": user.isCallEnabled,
        "walletBalance": user.walletBalance,
        "tags": tags
      };
}
