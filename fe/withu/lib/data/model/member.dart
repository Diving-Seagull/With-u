import 'package:withu/data/model/social_type.dart';

class Member {
  final int? id;
  final String email;
  final String name;
  final String profile;
  final String socialType;
  final String? description;
  final String? deviceUuid;
  final String? role;
  final int? teamId;

  Member({
        required this.id,
        required this.email,
        required this.name,
        required this.profile,
        required this.socialType,
        required this.description,
        required this.deviceUuid,
        required this.role,
        required this.teamId
      });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile: json['profile'],
      socialType: json['socialType'],
      description: json['description'],
      deviceUuid: json['deviceUuid'],
        role: json['role'],
      teamId: json['teamId']
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
      'role': role,
      'teamId': teamId
    };
  }
}
