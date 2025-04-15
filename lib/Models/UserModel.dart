class UserModel {
  final String uid;
  final String email;
  final String userType; // 'normal' or 'owner'
  final String profileImage; // base64 encoded image string

  UserModel({
    required this.uid,
    required this.email,
    required this.userType,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      userType: json['userType'],
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'userType': userType,
      'profileImage': profileImage,
    };
  }
}
