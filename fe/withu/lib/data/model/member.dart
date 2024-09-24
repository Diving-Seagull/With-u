import 'package:withu/data/model/social_type.dart';

class Member {
  final int id;
  final String email;
  final String name;
  final String profile;
  final SocialType social_type;
  final DateTime created_at;
  final DateTime updated_at;

  Member({
        required this.id,
        required this.email,
        required this.name,
        required this.profile,
        required this.social_type,
        required this.created_at,
        required this.updated_at
      });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json["id"],
      name: json['name'],
      email: json['email'],
      profile: json['profile'],
      social_type: json['social_type'],
      created_at: json['created_at'],
      updated_at: json['updated_at']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile': profile,
      'social_type': social_type,
      'created_at': created_at,
      'updated_at': updated_at
    };
  }
}
