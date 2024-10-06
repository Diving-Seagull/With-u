class MemberLocationRequest {
  final double latitude;
  final double longitude;
  final String message;

  MemberLocationRequest({required this.latitude, required this.longitude, required this.message});

  factory MemberLocationRequest.fromJson(Map<String, dynamic> json){
    return MemberLocationRequest(
        latitude: json['latitude'],
        longitude: json['longitude'],
        message: json['message']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'latitude': latitude,
      'longitude': longitude,
      'message': message
    };
  }
}