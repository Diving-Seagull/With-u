class MemberLocation {
  final int memberId;
  final double latitude;
  final double longitude;
  final String? message;

  MemberLocation({required this.memberId, required this.latitude, required this.longitude, required this.message});

  factory MemberLocation.fromJson(Map<String, dynamic> json){
    return MemberLocation(
        memberId: json['memberId'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        message: json['message']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'memberId': memberId,
      'latitude': latitude,
      'longitude': longitude,
      'message': message
    };
  }
}