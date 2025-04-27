class UserModel {
  final String uid;
  final String email;
  final String userType; // 'normal' or 'owner'
  final String phoneNumber;
  final String profileImage; // base64 encoded image string

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    required this.profileImage,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      userType: json['userType'],
      profileImage: json['profileImage'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userType': userType,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
    };
  }
}
