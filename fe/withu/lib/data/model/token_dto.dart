class TokenDto {
  final String token;
  final String? firebaseToken;

  TokenDto(this.token, [this.firebaseToken]);

  Map<String, dynamic> toJson(){
    return {
      'token': token,
      'firebaseToken': firebaseToken
    };
  }

  factory TokenDto.fromJson(Map<String, dynamic> json){
    return TokenDto(json['token'], json['firebaseToken']);
  }
}
