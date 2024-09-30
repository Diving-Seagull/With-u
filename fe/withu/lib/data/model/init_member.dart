class InitMember {
  final String role;
  final String? description;
  final String deviceUuid;
  final String profileImage;
  final String name;

  InitMember({
    required this.role,
    required this.name,
    required this.description,
    required this.deviceUuid,
    required this.profileImage
  });

  factory InitMember.fromJson(Map<String, dynamic> json) {
    return InitMember(
        name: json['name'],
        profileImage: json['profileImage'],
        description: json['description'],
        deviceUuid: json['deviceUuid'],
        role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'deviceUuid': deviceUuid,
      'role': role,
      'profileImage': profileImage
    };
  }
}