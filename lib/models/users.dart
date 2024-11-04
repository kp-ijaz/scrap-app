class UserModel {
  String name;
  String createdAt;
  String email;
  String phoneNumber;
  String uid;

  UserModel({
    required this.name,
    required this.createdAt,
    required this.email,
    required this.phoneNumber,
    required this.uid,
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      email: map['email'],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "uid": uid,
      'email': email,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
    };
  }
}
