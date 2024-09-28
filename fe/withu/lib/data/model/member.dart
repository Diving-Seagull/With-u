import 'package:withu/data/model/social_type.dart';

class Member {
  final String email;
  final String name;
  final String profile;
  final String socialType;

  Member({
        required this.email,
        required this.name,
        required this.profile,
        required this.socialType
      });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      email: json['email'],
      profile: json['profile'],
      socialType: json['socialType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profile': profile,
      'socialType': socialType
    };
  }
}
