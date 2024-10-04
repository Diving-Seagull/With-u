import 'package:withu/data/model/social_type.dart';

class Member {

  final String email;
  final String name;
  final String profile;
  final String socialType;
  final String? description;
  final String? deviceUuid;
  final String? role;

  Member({
        required this.email,
        required this.name,
        required this.profile,
        required this.socialType,
        required this.description,
        required this.deviceUuid,
        required this.role,
      });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      email: json['email'],
      profile: json['profile'],
      socialType: json['socialType'],
      description: json['description'],
      deviceUuid: json['deviceUuid'],
        role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profile': profile,
      'description': description,
      'socialType': socialType,
      'deviceUuid': deviceUuid,
      'role': role
    };
  }
}
